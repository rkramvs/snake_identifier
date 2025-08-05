//
//  OnboardModel.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//

import Foundation
import UIKit
import Localisation

struct OnboardModel {
    static let model = {
        let model: SnakeModel
        
        let language = Language(rawValue: Bundle.main.preferredLocalizations.first ?? "") ?? .english
        
//        switch language {
//        case .english:
//            model = SnakeModel(with: englishJson)
//        case .chineseSimplified:
//            model = SnakeModel(with: chineseSimplifiedJson)
//        case .traditionalChinese:
//            model = SnakeModel(with: traditionalChineseJson)
//        case .czech:
//            model = SnakeModel(with: czechJson)
//        case .danish:
//            model = SnakeModel(with: danishJson)
//        case .dutch:
//            model = SnakeModel(with: dutchJson)
//        case .arabic:
//            model = SnakeModel(with: arabicJson)
//        case .french:
//            model = SnakeModel(with: frenchJson)
//        case .german:
//            model = SnakeModel(with: germanJson)
//        case .italian:
//            model = SnakeModel(with: italianJson)
//        case .japanese:
//            model = SnakeModel(with: japaneseJson)
//        case .korean:
//            model = SnakeModel(with: koreanJson)
//        case .polish:
//            model = SnakeModel(with: polishJson)
//        case .portugese:
//            model = SnakeModel(with: portugeseJson)
//        case .spanish:
//            model = SnakeModel(with: spanishJson)
//        case .finnish:
//            model = SnakeModel(with: finnishJson)
//        case .hindi:
//            model = SnakeModel(with: hindiJson)
//        case .norwegian:
//            model = SnakeModel(with: norwegianJson)
//        case .russian:
//            model = SnakeModel(with: russianJson)
//        case .romanian:
//            model = SnakeModel(with: romanianJson)
//        case .brazilianPortuguese:
//            model = SnakeModel(with: brazilianPortugueseJson)
//        case .swedish:
//            model = SnakeModel(with: swedishJson)
//        case .thai:
//            model = SnakeModel(with: thaiJson)
//        case .turkish:
//            model = SnakeModel(with: turkishJson)
//        case .hebrew:
//            model = SnakeModel(with: hebrewJson)
//        case .tamil:
//            model = SnakeModel(with: tamilJson)
//        case .malay:
//            model = SnakeModel(with: malayJson)
//        case .vietnamese:
//            model = SnakeModel(with: vietnameseJson)
//        }
    
        model = SnakeModel(with: englishJson)
        model.isInMyCollection = false
        model.lastUpdatedDate = Date()
        model.imageData = UIImage(named: "onboard_snake")?.jpegData(compressionQuality: 1.0)
        return model
    }()
    
    static let englishJson: [String: Any] = [
        "snake_common_name": "European Adder",
        "scientific_name": "Vipera berus",
        "confidence": 0.92,
        "venomous": true,
        "length_cm": [
            "min": 50.0,
            "max": 90.0
        ],
        "colors": [
            ["name": "brown", "hex": "#8B4513"],
            ["name": "dark brown", "hex": "#5C4033"]
        ],
        "habitat": "forests, meadows, rocky hillsides",
        "diet": "rodents, lizards, amphibians",
        "behavior": "shy, terrestrial, hibernates in winter",
        "region": "Europe and parts of Asia",
        "danger_level": "moderate",
        "toxicity": "Venom can cause pain and swelling, rarely fatal to humans",
        "notes": "Easily identified by its zigzag dorsal pattern and broad triangular head.",
        "source": "Reptile Database, 2025",
        "attribution": "Photo by Arvid Høidahl on Unsplash"
    ]
}
