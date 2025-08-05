//
//  UIElements+Extension.swift
//  Snake identifier
//
//  Created by Ram Kumar on 28/07/25.
//

import SwiftUI
import Haptic
import UIComponents
import UniformTypeIdentifiers
import UIUtility

extension UIElements {
    static func crownButton( _ handler: @escaping () -> Void) -> some View {
        Button{
            Haptic.impact(.soft).generate()
            handler()
        }label: {
            Image(systemName: "crown.fill")
                .foregroundStyle(Color.primary)
                .imageScale(.medium)
                .fontWeight(.regular)
                .font(.title3)
        }
    }
    
    static func navigationButton(systemName: String, color: Color = .accentColor, _ handler: @escaping () -> Void) -> some View {
        Button {
            Haptic.impact(.light).generate()
            handler()
        } label: {
            Image(systemName: systemName)
                .decorator(ImageDecorator(foregroundColor: color))
        }
        .frame(width: 35, height: 35)
        .background(Material.thickMaterial)
        .clipShape(Circle())
    }
    
    static func navigationTittle(title: String) -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .foregroundStyle(.primary)
    }
    
    static func floatingActionButton(systemImage: String, _ handler: @escaping () -> Void) -> some View {
        Button{
            Haptic.impact(.soft).generate()
            handler()
        }label: {
            Image(systemName: systemImage)
                .decorator(ImageDecorator(font: .title2, foregroundColor: Color.white))
                .imageScale(.large)
                .fontWeight(.bold)
                .fontDesign(.rounded)
        }
        .buttonStyle(CircularButtonStyle(backgroundColor: .accent, width: 70, height: 70))
    }
    
    static func menuButton(title: LocalizedStringKey,
                           systemImage: String,
                           role: ButtonRole? = nil,
                           _ handler: @escaping () -> Void) -> some View {
        Button(role: role) {
            Haptic.impact(.soft).generate()
            handler()
        } label: {
            Label(title, systemImage: systemImage)
                .foregroundStyle(Color.primary)
                .imageScale(.medium)
                .font(.callout)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
        }
    }
    
    static func emptyView(title: LocalizedStringKey, subtitle: LocalizedStringKey) -> some View {
        VStack(alignment: .center,spacing: 10) {
            Spacer()
            Image(.empty)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 4) {
                    Text(title)
                        .decorator(TextDecorator(font: .body, fontWeight: .medium, foregroundColor: .secondary))
                        .multilineTextAlignment(.center)
                    Text(subtitle)
                        .decorator(TextDecorator(font: .body, fontWeight: .medium, foregroundColor: .secondary))
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            Spacer()
            
        }
        .padding(.horizontal)
    }
    
    static func navigationClose( _ handler: @escaping () -> Void) -> some View {
        Button(action: {
            Haptic.impact(.light).generate()
            handler()
        }){
            Image(systemName: "xmark")
                .foregroundStyle(Color.secondary)
                .imageScale(.small)
                .fontWeight(.medium)
                .frame(width: 30, height: 30, alignment: .center)
                .background(Color(uiColor: UIColor.tertiarySystemBackground))
                .clipShape(Circle())
        }
        .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}


