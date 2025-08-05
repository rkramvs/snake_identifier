//
//  SnakeModel.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//

import Foundation
import UtilityKit
import IdentifierScanner
import SwiftUI

class SnakeModel: ObservableObject, ScannerObjectRepresentable, Identifiable, Hashable {

    var id: UUID = UUID()
    
    var snakeCommonName: String = ""
    var scientificName: String = ""
    var confidence: Double = 0.0
    var venomous: Bool = false
    var lengthCM: EntitySizeRangeModel = EntitySizeRangeModel()
    var colors: [EntityColorModel] = []
    var habitat: String = ""
    var diet: String = ""
    var behavior: String = ""
    var region: String = ""
    var dangerLevel: String = ""
    var toxicity: String = ""
    var notes: String = ""
    var source: String = ""
    var attribution: String = ""
    
    @Published var isInMyCollection: Bool = false
    var lastUpdatedDate = Date()
    var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case snakeCommonName = "snake_common_name"
        case scientificName = "scientific_name"
        case confidence
        case venomous
        case lengthCM = "length_cm"
        case colors
        case habitat
        case diet
        case behavior
        case region
        case dangerLevel = "danger_level"
        case toxicity
        case notes
        case source
        case attribution
    }
    
    init() { }
    
    public required init(with json: [String : Any]) {
        snakeCommonName = json.string(forKey: "snake_common_name")
        scientificName = json.string(forKey: "scientific_name")
        confidence = json.nsNumber(forKey: "confidence").doubleValue
        venomous = json.bool(forKey: "venomous")
        lengthCM = json.customModel(type: EntitySizeRangeModel.self, key: "length_cm", defaultValue: EntitySizeRangeModel())
        colors = json.customModelArray(type: EntityColorModel.self, key: "colors")
        habitat = json.string(forKey: "habitat")
        diet = json.string(forKey: "diet")
        behavior = json.string(forKey: "behavior")
        region = json.string(forKey: "region")
        dangerLevel = json.string(forKey: "danger_level")
        toxicity = json.string(forKey: "toxicity")
        notes = json.string(forKey: "notes")
        source = json.string(forKey: "source")
        attribution = json.string(forKey: "attribution")
    }
    
    static func == (lhs: SnakeModel, rhs: SnakeModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
