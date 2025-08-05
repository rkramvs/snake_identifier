//
//  SnakeContentVM.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//


import SwiftUI

class SnakeContentVM: ObservableObject {
    @Published var model: SnakeModel
    
    init(model: SnakeModel) {
        self._model = Published(wrappedValue: model)
    }
}
