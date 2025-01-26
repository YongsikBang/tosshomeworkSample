//
//  DutchDetail.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation
import UIKit

//더치페이를 요청받은 사람들 목록
struct DutchDetail: Codable {
    let dutchId: Int
    let name: String
    let amount: Int
    let transferMessage: String?
    let isDone: Bool
    
    var profileDisplayString: String {
        let profileName = name.prefix(1)
        return String(profileName)
    }
    
    var amountDisplayString: String {
        return amount.toCurrencyString()
    }
    
    var commentHidden: Bool {
        
        return (transferMessage != nil) ? false : true
    }
    
    var statusDisplayString: String {
        return isDone ? String.localized(of: .statusButtonTitleDone) : String.localized(of: .statusButtonTitleFalse)
    }
    
    var statusTextColor: UIColor {
        return isDone ? UIColor.black : UIColor.systemBlue
    }
}

