//
//  AppConstants.swift
//  Snake identifier
//
//  Created by Ram Kumar on 28/07/25.
//


import Foundation
import AIProxy
import PurchaseCore
import Localisation


struct AppConstants {
    static let appGroup = "group.reku.snake"
    static let toMail: String = "support@reku.dev"
    
    struct OpenAIServiceConstants {
        static let partialKey: String = "v2|0192af80|dqqVQ_iKBvBnf70d"
        static let serviceURL: String = "https://api.aiproxy.com/35c09a7a/1362e794"
    }
    
    static var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static func mailBody(purchase: PurchaseManager?) -> [String: String] {
        var body =  ["App version": currentVersion]
        if purchase?.isPurchasedUser == true {
            body["Pro User"] = ""
        }
        return body
    }
    
    static let appStoreReviewURLString = "itms-apps://itunes.apple.com/app/id6749370615?action=write-review"
    static let appStoreURLString = "https://itunes.apple.com/app/id6749370615"
    static let termsURLString = "https://reku-indie.notion.site/Privacy-Policy-2438c096503c80b085e9f6933f598ee7"
    static let privacyURLString = "https://reku-indie.notion.site/Terms-of-Service-2438c096503c80da86dfcf427d367686"
    
    static let freeSnakeLimit: Int = 1
    
    static let freeSnakeChatLimit: Int = 2
}

extension AppConstants.OpenAIServiceConstants {
    
    static var language: Language { Language(rawValue: Bundle.main.preferredLocalizations.first ?? "") ?? .english }
    
    static let prompt: String = "Analyze the provided image to identify the snake species and return a JSON object with its details. If a single type of snake is recognized, return the information in the specified JSON structure below. If no snake is identified or if multiple types are detected, return details of the most prominent species. Return a well-structured JSON object containing the analysis in \(language.title)(\(language.rawValue)), ensuring clarity and accuracy in presenting the results."
    
    static func questionPrompt(snakeName: String, scientificName: String, question: String) -> String {
        return """
        You are a snake identification expert. The identified snake is \(snakeName) (\(scientificName)).
        Answer the following question in a clear and concise manner, using information relevant to this snake only.

        Question: "\(question)"

        If the question is not related to snakes or this specific snake, respond with: "This question is not related to the identified snake."
        The response should be in \(language.title)(\(language.rawValue)).
        """
    }

    static let snakeIdentifierSchema: [String: AIProxyJSONValue] = [
        "type": "object",
        "properties": [
            "snake_common_name": [
                "type": "string",
                "description": "Common name of the snake, e.g., 'King Cobra'"
            ],
            "scientific_name": [
                "type": "string",
                "description": "Scientific name, e.g., 'Ophiophagus hannah'"
            ],
            "confidence": [
                "type": "number",
                "minimum": 0,
                "maximum": 1,
                "description": "Confidence score from 0.0 to 1.0"
            ],
            "venomous": [
                "type": "boolean",
                "description": "Indicates whether the snake is venomous"
            ],
            "length_cm": [
                "type": "object",
                "description": "Estimated length range in centimeters",
                "properties": [
                    "min": ["type": "number", "description": "Minimum estimated length"],
                    "max": ["type": "number", "description": "Maximum estimated length"]
                ],
                "required": ["min", "max"],
                "additionalProperties": false
            ],
            "colors": [
                "type": "array",
                "description": "List of primary colors observed on the snake, with names and hex values",
                "items": [
                    "type": "object",
                    "required": ["name", "hex"],
                    "properties": [
                        "name": ["type": "string", "description": "Color name, e.g., 'olive green'"],
                        "hex": ["type": "string", "pattern": "^#([A-Fa-f0-9]{6})$", "description": "Hex color code"]
                    ],
                    "additionalProperties": false
                ]
            ],
            "habitat": [
                "type": "string",
                "description": "Natural habitat of the snake, e.g., 'forests', 'deserts', 'wetlands'"
            ],
            "diet": [
                "type": "string",
                "description": "Typical diet, e.g., 'rodents', 'birds', 'frogs'"
            ],
            "behavior": [
                "type": "string",
                "description": "General behavior, e.g., 'aggressive', 'shy', 'nocturnal'"
            ],
            "region": [
                "type": "string",
                "description": "Geographic region where the snake is typically found"
            ],
            "danger_level": [
                "type": "string",
                "description": "Perceived danger level to humans, e.g., 'low', 'moderate', 'high'"
            ],
            "toxicity": [
                "type": "string",
                "description": "Toxic effects, if any, from venom or contact"
            ],
            "notes": [
                "type": "string",
                "description": "Additional contextual or identifying notes"
            ],
            "source": [
                "type": "string",
                "description": "Primary data source, e.g., 'Reptile Database, 2025'"
            ],
            "attribution": [
                "type": "string",
                "description": "Attribution information for the data"
            ]
        ],
        "required": [
            "snake_common_name",
            "scientific_name",
            "confidence",
            "venomous",
            "length_cm",
            "colors",
            "habitat",
            "diet",
            "behavior",
            "region",
            "danger_level",
            "toxicity",
            "notes",
            "source",
            "attribution"
        ],
        "additionalProperties": false
    ]
}
