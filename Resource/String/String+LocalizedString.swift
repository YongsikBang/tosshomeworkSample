//
//  String+LocalizedString.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/26/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation

public extension String {
    
    static func localized(of localization: LocalizedString, arguments: CVarArg...) -> String {
        return if arguments.count > 0 {
            String.localizedStringWithFormat(localization.localized, arguments)
        }
        else {
            localization.localized
        }
    }
}
