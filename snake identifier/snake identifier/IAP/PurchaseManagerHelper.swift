//
//  PurchaseManagerHelper.swift
//  Snake identifier
//
//  Created by Ram Kumar on 11/11/24.
//


import PurchaseCore
import Foundation
import UIUtility
import Analytics
import UIComponents
import PurchaseUI

class PurchaseManagerHelper: PurchaseManagerDelegate {
    
    static let shared: PurchaseManagerHelper = PurchaseManagerHelper()
    
    func track(error: any Error) {
        CrashManager.shared.track(error: error)
    }
    
    func didUpdatePurchaseInfo() {
    }
    
    var features: [PaywallFeatures] {
        return [
        ]
    }
    
    var ratings: PaywallView.RatingModel {
        PaywallView.RatingModel(averageRating: "5",
                                reviews: [])
    }

    var model: PaywallView.Model {
        return PaywallView.Model(title: "",
                                 features: features,
                                 privacyURL: URL(string: AppConstants.privacyURLString)!,
                                 termsURL: URL(string: AppConstants.termsURLString)!,
                                 reviewURl: URL(string: AppConstants.appStoreReviewURLString)!,
                                 supportMail: AppConstants.toMail,
                                 mailModel: MailModel(toMail: AppConstants.toMail,
                                                      subject: "Snake Identifier Subscription",
                                                      body: "",
                                                      info: AppConstants.mailBody(purchase: nil)),
                                 ratingModel: ratings,
                                 cansShowFAQ: true)
    }
    
   
}

