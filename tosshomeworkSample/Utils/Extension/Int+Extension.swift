//
//  Int+Extension.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/26/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation

extension Int {
    /// 숫자를 `천 단위 쉼표`와 `원` 단위로 변환
    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 천 단위 쉼표
        formatter.locale = Locale(identifier: "ko_KR")
        guard let formattedString = formatter.string(from: NSNumber(value: self)) else {
            return "\(self)원"
        }
        return "\(formattedString)원"
    }
}
