//
//  ContactButton.swift
//  Snake identifier
//
//  Created by Ram Kumar on 11/11/24.
//


import SwiftUI
import Haptic
import UIUtility
import UIComponents
import UtilityKit
import MessageUI
import PurchaseCore

struct ContactButton: View {
    @EnvironmentObject var mail: MailModelWrapper
    @EnvironmentObject var purchase: PurchaseManager
    @Environment(\.openURL) var openURL
    var color: Color = .accentColor
    
    var body: some View {
        Menu(content: {
            Button(action: {
                Haptic.impact(.light).generate()
                mail.model = MailModel(toMail: AppConstants.toMail,
                                       subject: "Snake Identifier Support",
                                       body: "",
                                       info: AppConstants.mailBody(purchase: purchase))
                
            },label: {
                Label("Contact Us", systemImage: "envelope.fill")
                    .labelStyle(InvertLabelStyle(spacing: 2))
            })
            
            Button(action: {
                Haptic.impact(.light).generate()
                openURL(URL(string: AppConstants.appStoreReviewURLString)!)
            },label: {
                Label("Rate the Application", systemImage: "star.circle.fill")
                    .labelStyle(InvertLabelStyle(spacing: 2))
            })
            
        }, label: {
            Image(systemName: "ellipsis.bubble.fill")
                .foregroundStyle(color)
            
        })
    }
}


