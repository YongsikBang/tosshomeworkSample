//
//  StringResource.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/26/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation

extension LocalizedString {
    //title
    static let dutchViewTitle = makeInfo("dutchview_title", "더치페이", "더치페이 뷰 타이틀")
    
    //alert
    static let alertTitle = makeInfo("alert_title_text", "알림", "alert 타이틀 문구")
    static let alertErrorMessage = makeInfo("alert_error_text", "잠시후에 다시 시도해주세요.", "alert 오류 안내 문구")
    static let alertNotAllowMessage = makeInfo("alert_notAllow_text", "재요청은 한 번만 가능합니다.", "alert 재요청 안내 문구")
    static let alertConfirmButtonTitle = makeInfo("alert_confirm_text", "확인", "alert confirm button 문구")
    
    //cell
    static let adCellText = makeInfo("ad_cell_text", "토스 공동계좌를 개설해보세요.", "adcell 광고 문구")
    
    //progress
    static let statusButtonTitleProgressing = makeInfo("statusButton_title_progressing", "요청함", "재요청한 상태 문구")
    static let statusButtonTitleDone = makeInfo("statusButton_title_done", "완료", "완료한 상태 문구")
    static let statusButtonTitleFalse = makeInfo("statusButton_title_false", "재요청", "재요청 필요한 상태 문구")
}
