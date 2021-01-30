//
//  StoreReviewHelper.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/26/19.
//  Copyright © 2019 Ian Clawson Apps. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func checkAndAskForReview(hasAskedThisSession: Bool, numTimesAppOpened: Int, numTimesReviewPrompted: Int) -> Bool {
        
        // only ask once per session
        if hasAskedThisSession {
            return
        }
        
        // never ask more than 3 times in total ever
        guard numTimesReviewPrompted <= 3 else {
            return
        }
        
        switch numTimesAppOpened {
        case 10:
            StoreReviewHelper().requestReview()
            return true
        case _ where numTimesAppOpened % 20 == 0 :
            StoreReviewHelper().requestReview()
            return true
        default:
            print("App run count is : \(numTimesAppOpened)")
            return false
        }
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            // `requestReview` will not be shown everytime. Apple has some internal logic on how to show this.
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
        }
    }
}
