//
//  AppShortcutItemType.swift
//  Snake identifier
//
//  Created by Ram Kumar on 10/07/25.
//


import Foundation
import SwiftUI
import UIComponents

enum AppShortcutItemType: String, AppShortCutItemRepresentable {
    case support, review
}

class AppShortCutItemModelWrapper: ObservableObject {
    
    static var shared = AppShortCutItemModelWrapper()
    @Published var model: AppShortCutItemModel<AppShortcutItemType> = AppShortCutItemModel<AppShortcutItemType>()
}
