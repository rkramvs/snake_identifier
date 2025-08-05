//
//  SnakeDetailBaseView.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//


import SwiftUI
import UIUtility
import UIComponents
import IdentifierScanner

struct SnakeDetailBaseView: View {
    @State private var scrollOffset: CGFloat = 0
    var model: SnakeModel
    @State var forceReload: Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            List {
                ZStack {
                    GeometryReader { geo in
                        let offset = geo.frame(in: .global).minY
                        let height = max(300 + offset, 300)
                        
                        if let data = model.imageData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: height)
                                .clipped()
                                .overlay(
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            ConfidenceCircle(confidence: model.confidence)
                                                .frame(width: 35, height: 35)
                                                .padding()
                                        }
                                    }
                                )
                                .offset(y: offset < 0 ? 0 : -offset)
                        }
                    }
                    .frame(height: 300)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(model.snakeCommonName)
                            .decorator(TextDecorator(font: .title3, fontDesign: .rounded, fontWeight: .bold, foregroundColor: .primary))
                            .multilineTextAlignment(.leading)
                        
                        
                        Text(model.scientificName)
                            .decorator(TextDecorator(font: .footnote, fontDesign: .rounded, fontWeight: .regular, foregroundColor: .accent))
                            .multilineTextAlignment(.leading)
                        
                        Text(model.notes)
                            .decorator(TextDecorator(font: .callout, fontDesign: .rounded, fontWeight: .regular, foregroundColor: .primary))
                            .multilineTextAlignment(.leading)
                        
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                basicSection()
                
                Spacer()
                    .frame(height: 120)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
            }
            .listStyle(.plain)
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func imageWidth(_ proxy: GeometryProxy) -> CGFloat {
        let width = proxy.size.width - 32
        if width > 0 {
            return width
        } else {
            return 0
        }
    }
  
    @ViewBuilder
    func metricsDetail(title: LocalizedStringKey, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .decorator(TextDecorator(font: .callout,
                                         fontDesign: .rounded,
                                         fontWeight: .regular,
                                         foregroundColor: .accentColor))
                .multilineTextAlignment(.leading)
            Text(value)
                .decorator(TextDecorator(font: .callout,
                                         fontDesign: .rounded,
                                         fontWeight: .regular,
                                         foregroundColor: .primary))
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    func basicSection() -> some View {
        
        
        Section {
            VStack(spacing: 16) {
                IdentifierHorizontalDetailView(
                    title: String(localized: "Venomous"),
                    value: model.venomous ? "Yes" : "No")
                
                Divider()
                
                IdentifierHorizontalDetailView(
                    title: String(localized: "Danger Level"),
                    value: model.dangerLevel)
                
                Divider()
                
                IdentifierHorizontalDetailView(
                    title: String(localized: "Region"),
                    value: model.region)
            }
            .padding(.all)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(uiColor: .secondarySystemBackground)))
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
        Section {
            
            IdentifierVerticalDetailSectionView(
                title: String(localized: "Toxicity"),
                value: model.toxicity)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
        Section {
            IdentifierVerticalCustomSectionView(
                title: String(localized: "Estimated Length")) {
                MinMaxRangeView(
                    min: MeasurementFormat.formate(measurement: Measurement(value: model.lengthCM.min, unit: UnitLength.centimeters)),
                    max: MeasurementFormat.formate(measurement: Measurement(value: model.lengthCM.max, unit: UnitLength.centimeters)))
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
        Section {
            IdentifierColorSectionView(
                title: String(localized: "Colors"),
                models: model.colors)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
        Section {
            
            IdentifierVerticalDetailSectionView(
                title: String(localized: "Habitat"),
                value: model.habitat)
    
            IdentifierVerticalDetailSectionView(
                title: String(localized: "Diet"),
                value: model.diet)
            
            IdentifierVerticalDetailSectionView(
                title: String(localized: "Behavior"),
                value: model.behavior)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)

    }
}

//#Preview {
//    SnakeDetailBaseView(model: OnboardModel.model)
//}

