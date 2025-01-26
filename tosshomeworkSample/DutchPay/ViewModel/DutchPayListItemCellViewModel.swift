//
//  DutchPayListItemCellViewModel.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/26/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation
import Combine

class DutchPayListItemCellViewModel: ObservableObject {
    @Published private(set) var detailItem: DutchDetail
    @Published var isProgressing: Bool = false
    @Published var isRequestAllowed: Bool = true
    @Published var requestStatus: DetailItemCellRequestStatus

    private var startTime: Date?
    private var duration: TimeInterval = 10
    private var timer: Timer?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(item: DutchDetail, status: DetailItemCellRequestStatus) {
        self.detailItem = item
        self.requestStatus = status
    }
    
    func handleRequest() -> Bool {
        guard isRequestAllowed else { return false}
        guard !isProgressing, requestStatus != .completed  else { return true } //이미 완료된 요청
        isProgressing = true
        requestStatus = .requested
        startProgress()
        return true
    }
    
    func handleCancel() {
        guard isProgressing else { return }
        resetProgress()
    }
    
    private func startProgress() {
        timer?.invalidate()
        
        // 시작 시간을 기록
        startTime = Date()
        
        // 타이머 설정
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self, let startTime = self.startTime else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            
            // 2초 뒤에 isProgressing 상태 업데이트
            if elapsed >= 2.0, self.isProgressing {
                self.isProgressing = false
                self.isRequestAllowed = false
            }
            
            // 10초 뒤에 요청 완료 처리
            if elapsed >= self.duration {
                timer.invalidate()
                self.completeRequest()
            }
        }
    }
    
    func resetProgress() {
        timer?.invalidate()
        isProgressing = false
        startTime = nil
        requestStatus = .none
    }
    
    func completeRequest() {
        resetProgress()
        requestStatus = .completed
        detailItem = DutchDetail(dutchId: detailItem.dutchId,
                                 name: detailItem.name, 
                                 amount: detailItem.amount,
                                 transferMessage: detailItem.transferMessage,
                                 isDone: true)
    }
    
    func restoreProgress() {
        guard isProgressing, let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        if elapsed >= duration {
            completeRequest()
        }
        else {
            startProgress()
        }
    }
}
