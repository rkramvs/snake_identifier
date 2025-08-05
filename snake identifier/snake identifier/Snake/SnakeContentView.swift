//
//  SnakeContentView.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//


import SwiftUI
import UIComponents
import UIUtility
import UtilityKit
import CoreData
import Haptic
import Analytics

struct SnakeContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var alert: AlertModelWrapper
    @State var presentChatView: Bool = false
    
    var viewModel: SnakeContentVM

    init(viewModel: SnakeContentVM) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                SnakeThumbView(model: viewModel.model)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                HStack {
                    Text(viewModel.model.snakeCommonName)
                        .decorator(TextDecorator(font: .footnote, fontDesign: .rounded, fontWeight: .medium, foregroundColor: .primary))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.all)
                .background(.ultraThinMaterial)
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .sheet(isPresented: $presentChatView) {
            ChatView(viewModel: ChatMessageViewModel(model: viewModel.model,
                                                     viewContext: viewContext))
                .paywallWrapper()
        }
    }
}
