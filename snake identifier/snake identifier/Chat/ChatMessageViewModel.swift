//
//  ChatMessageViewModel.swift
//  Snake identifier
//
//  Created by Ram Kumar on 26/05/25.
//

import SwiftUI
import Foundation
import CoreData
import IdentifierScanner

class ChatMessageViewModel: ObservableObject {
    var model: SnakeModel
    @Published var messages: [ChatMessage] = []
    
    let suggestedQuestions = [
        "What is the name of this snake?",
        "What is the scientific name of this snake?",
        "Is this snake venomous?",
        "Where is this snake commonly found?",
        "What kind of habitat does this snake prefer?",
        "What does this snake usually eat?",
        "What is the typical behavior of this snake?",
        "What is the average length range of this snake?",
        "What colors are typically seen on this snake?",
        "Is this snake dangerous to humans?",
        "What region is this snake native to?",
        "What are the distinctive features of this snake?",
        "Is this snake active during the day or night?",
        "Does this snake have any ecological importance?",
        "Are there any snakes that look similar to this one?",
        "Is this snake safe to handle or observe closely?",
        "Does this snake play a role in controlling pests?",
        "What is the reproduction behavior of this snake?",
        "How can this snake be identified in the wild?"
    ]
    
    init(model: SnakeModel, viewContext: NSManagedObjectContext) {
        self.model = model
        self.messages = (try? ChatMessageMObject.fetchMessages(for: model.id, context: viewContext)) ?? []
    }
}
