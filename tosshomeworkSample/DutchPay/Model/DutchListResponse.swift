//
//  DutchListResponse.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation

//더치페이 전체 데이터
struct DutchListResponse: Codable {
    let dutchSummary: DutchSummary
    let dutchDetailList: [DutchDetail]
}

