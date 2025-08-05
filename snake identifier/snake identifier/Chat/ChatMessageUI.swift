//
//  ChatMessage.swift
//  Snake Identifier
//
//  Created by Ram Kumar on 26/05/25.
//


import SwiftUI
import UIComponents
import IdentifierScanner
import PurchaseCore
import UIUtility

struct ChatView: View {
    
    @EnvironmentObject var purchase: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var alert: AlertModelWrapper
    @State private var inputText: String = ""
    @StateObject var chatService = AIChatService(configuration: AIConfiguration(partialKey: AppConstants.OpenAIServiceConstants.partialKey,
                                                                                     serviceURL: AppConstants.OpenAIServiceConstants.serviceURL))
    let fetchingId: String = "Fetching View Id"
    @State var scrollViewProxy: ScrollViewProxy?
    
    @StateObject var viewModel: ChatMessageViewModel
    
    @State var showDetail: Bool = false
    
    init( viewModel: ChatMessageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            
                            VStack(alignment: .leading, spacing: 6) {
                                SnakeThumbView(model: viewModel.model)
                                    .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .padding(.leading, 25)
                                Text("What kind of snake is this?")
                                    .decorator(AppDecorators.primaryTextDecorator)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.all)
                            
                            HStack(alignment: .top, spacing: 4) {
                                Image(.snakeAI)
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(viewModel.model.snakeCommonName), \(viewModel.model.scientificName)")
                                        .foregroundColor(.primary)
                                    Button("View All") {
                                        showDetail.toggle()
                                    }
                                    .foregroundStyle(Color.blue)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding(.all)
                            
                            ForEach(viewModel.messages) { msg in
                                HStack {
                                    if msg.sender == .ai {
                                        HStack(alignment: .top, spacing: 4) {
                                            Image(.snakeAI)
                                                .frame(width: 35, height: 35)
                                                .clipShape(Circle())
                                            
                                            Text(msg.message)
                                                .decorator(AppDecorators.primaryTextDecorator)
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(10)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .id(msg.id)
                                        
                                    } else {
                                        Text(msg.message)
                                            .decorator(TextDecorator(font: .callout,
                                                                     fontDesign: .rounded,
                                                                     fontWeight: .medium,
                                                                     foregroundColor: .white))
                                            .padding()
                                            .background(Color.accentColor)
                                            .cornerRadius(10)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .id(msg.id)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            
                            if chatService.isRequestInProgress {
                                HStack(alignment: .top, spacing: 4) {
                                    Image(.snakeAI)
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                    
                                    if #available(iOS 18.0, *) {
                                        Image(systemName: "ellipsis.bubble.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.accentColor)
                                            .symbolEffect(.bounce, isActive: chatService.isRequestInProgress)
                                    } else {
                                        Image(systemName: "ellipsis.bubble.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.accentColor)
                                    }
                                    
                                }
                                .padding(.all)
                                .id(fetchingId)
                            }
                        }
                        .padding(.vertical, 10)
                        
                    }
                    .onAppear{
                        scrollViewProxy = proxy
                    }
                }
                
                // Suggested Questions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.suggestedQuestions, id: \.self) { question in
                            Button(action: {
                                
                                if let isPROUser = purchase.isPurchasedUser {
                                    if isPROUser || viewModel.messages.count <= AppConstants.freeSnakeChatLimit
                                    {
                                        sendMessage(question)
                                    }
                                    else
                                    {
                                        purchase.shownPaywall = true
                                    }
                                }
                                else
                                {
                                    sendMessage(question)
                                }
                                
                            }) {
                                Text(question)
                            }
                            .buttonStyle(PrimaryCompactCapsuleButtonStyle(backgroundColor: Color.accentColor))
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
                
//                 Input Field
                HStack(spacing: 10) {
                    TextField("Ask anything about this snake...", text: $inputText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    Button(action: {
                        if let isPROUser = purchase.isPurchasedUser
                        {
                            if isPROUser || viewModel.messages.count <= AppConstants.freeSnakeChatLimit
                            {
                                sendMessage(inputText)
                                inputText = ""
                            }
                            else
                            {
                                purchase.shownPaywall = true
                            }
                            
                        }
                        else
                        {
                            sendMessage(inputText)
                            inputText = ""
                        }
                        
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Snake AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    UIElements.navigationClose {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showDetail) {
                SnakeDetailView(model: viewModel.model, canShowChat: false)
            }
        }
        .onChange(of: chatService.isRequestInProgress) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation {
                        scrollViewProxy?.scrollTo(fetchingId, anchor: .bottom)
                    }
                }
            }
        }
        
    }

    private func sendMessage(_ text: String) {
        
        guard !chatService.isRequestInProgress else { return }
        
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let msg = ChatMessage(sender: .user, message: text, timestamp: Date())
        
        ChatMessageMObject(context: viewContext).extract(from: msg,
                                                         for: viewModel.model.id,
                                                         context: viewContext)
        try? viewContext.save()
        
        appendNewMessage(msg: msg)
        
        Task {
            do {
                let response = try await chatService.requestIdentifierScan(
                    promptText: AppConstants.OpenAIServiceConstants.questionPrompt(snakeName: viewModel.model.snakeCommonName,
                                                                                   scientificName: viewModel.model.scientificName,
                                                                                   question: text))
                
              
                    let msg = ChatMessage(sender: .ai, message: response, timestamp: Date())
                    ChatMessageMObject(context: viewContext).extract(from: msg,
                                                                     for: viewModel.model.id,
                                                                     context: viewContext)
                    try? viewContext.save()
                    
                    self.appendNewMessage(msg: msg)
                
            }catch {
                alert.model = AlertModel(title: String(localized: "Error"),
                                         message: text)
            }
        }
    }
    
    private func appendNewMessage(msg: ChatMessage) {
        viewModel.messages.append(msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                scrollViewProxy?.scrollTo(msg.id, anchor: .bottom)
            }
        }
    }
}
