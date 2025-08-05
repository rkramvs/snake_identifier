//
//  SnakeDetailView.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//


import SwiftUI
import UIComponents
import UIUtility
import Analytics
import Haptic
import IdentifierScanner

struct SnakeDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var alert: AlertModelWrapper
    @Environment(\.dismiss) var dismiss
    @StateObject var model: SnakeModel
    var canShowChat: Bool = true
    
    @State var presentChatView: Bool = false
    
    init(model: SnakeModel, canShowChat: Bool = true) {
        self._model = StateObject(wrappedValue: model)
        self.canShowChat = canShowChat
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            SnakeDetailBaseView(model: model)
            
            if canShowChat {
                HStack {
                    Spacer()
                    Button {
                        AnalyticsManager.logEvent(.SnakeAIChatOpenInDetail)
                        Haptic.impact(.light).generate()
                        presentChatView.toggle()
                    } label: {
                        Image(systemName: "bubble.fill")
                            .font(.title3)
                    }
                    .buttonStyle(CircularButtonStyle(width: 60, height: 60))
                }
                .padding(.bottom, 20)
                .padding(.horizontal)
            }
        }
        .toolbar(content: {
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    Haptic.impact(.light).generate()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .bold()
                        .decorator(ImageDecorator(foregroundColor: .accent))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if model.isInMyCollection {
                    UIElements.navigationButton(systemName: "heart.fill") {
                        removeFromMyCollection()
                    }
                } else {
                    UIElements.navigationButton(systemName: "heart") {
                        addToMyCollection()
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Menu {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        delete()
                    }
                } label: {
                    UIElements.navigationButton(systemName: "ellipsis") {
                        
                    }
                }
            }
        })
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $presentChatView) {
            ChatView(
                viewModel: ChatMessageViewModel(
                    model: model,
                    viewContext: viewContext))
            .paywallWrapper()
        }
        
    }
    
    private func delete() {
        
        var _model = AlertModel(title: String(localized: "Delete Snake"),
                                message: String(localized: "Are you sure you want to delete this Snake? This action cannot be undone."))
        _model.primaryButton = {.destructive(Text("Delete"), action: {
            withAnimation {
                viewContext.perform {
                    SnakeMObject.delete(withId: model.id, context: viewContext)
                    dismiss()
                }
            }
        })}
        _model.secondaryButton = {.cancel()}
        alert.model = _model
    }
    
    private func removeFromMyCollection() {
        withAnimation {
            viewContext.perform {
                SnakeMObject.toggleCollectionStatus(withId:model.id,
                                                   isInMyCollection: false,
                                                   context: viewContext)
                self.model.isInMyCollection = false
            }
        }
    }
    
    private func addToMyCollection() {
        withAnimation {
            viewContext.perform {
                SnakeMObject.toggleCollectionStatus(withId: model.id,
                                                   isInMyCollection: true,
                                                   context: viewContext)
                var _model = AlertModel(title: model.snakeCommonName,
                                        message: String(localized: "This snake has been added to your collections."))
                _model.dismissButton = {.cancel(Text("OK"))}
                alert.model = _model
                self.model.isInMyCollection = true
            }
        }
    }
}
