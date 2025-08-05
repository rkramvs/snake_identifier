//
// SnakeThumbView.swift
//  Snake Id
//
//  Created by Ram Kumar on 27/07/25.
//


import SwiftUI
import Haptic
import UIComponents

struct SnakeThumbView: View {
    var model: SnakeModel
    
    init(model: SnakeModel) {
        self.model = model
    }
    
    var body: some View {
        if let uiImage = UIImage(data: model.imageData ?? Data()) {
            
            if uiImage.size.width > uiImage.size.height {
                return AnyView(Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit))
            } else {
                return AnyView(Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill())
            }
          
        } else {
            return AnyView(EmptyView())
        }
    }
}
