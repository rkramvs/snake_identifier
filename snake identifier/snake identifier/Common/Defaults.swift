//
//  Defaults.swift
//  Snake identifier
//
//  Created by Ram Kumar on 10/07/25.
//


import SwiftUI

let appGroupStore = UserDefaults(suiteName: AppConstants.appGroup)

class Defaults: ObservableObject {

    public static var shared = Defaults()
   
    @AppStorage("IS_ONBOARDING_COMPLETED", store: appGroupStore)
    var isOnboardCompleted: Bool = false
    
    @AppStorage("SNAKE_SCANNED_COUNT", store: appGroupStore)
    var snakeScannedCount: Int = 0
}
