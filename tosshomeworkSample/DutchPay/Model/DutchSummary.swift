//
//  DutchSummary.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation

///더치페이 요약 정보
struct DutchSummary: Codable {
    let ownerName: String
    let message: String
    let ownerAmount: Int
    let completedAmount: Int
    let totalAmount: Int
    let date: String
    
    var dateDisplayString: String {
        // ISO8601DateFormatter를 설정
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // +0000에 맞게 설정

        // ISO 8601 문자열을 Date로 변환
        guard let isoDate = date as? String, let dateObject = isoFormatter.date(from: isoDate) else {
            logger("Failed to parse date: \(date)", options: [.date, .codePosition])
            return date // 변환 실패 시 원본 반환
        }

        // Date를 원하는 형식으로 변환
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return formatter.string(from: dateObject)
    }
    
    var amountDisplayString: String {
        return "\(completedAmount.toCurrencyString()) 완료 / 총 \(totalAmount.toCurrencyString())"
    }
    
    var ownerDisplayMessage: String {
        return "\(ownerName): \(message)"
    }
}
