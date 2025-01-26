//
//  DutchPayViewModel.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import UIKit
import Combine

class DutchPayViewModel {
    @Published var dutchItems: [DutchItem] = []
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var listItemCellViewModels: [Int: DutchPayListItemCellViewModel] = [:] // Key: dutchId

    func fetchDutchList() {
        Task {
            let url = "https://ek7b8b8yq2.execute-api.us-east-2.amazonaws.com/default/toss_ios_homework_dutch_detail"
            do {
                let response: DutchListResponse = try await networkManager.fetchData(from: url, responseType: DutchListResponse.self)
//                logger("response : \(response)")
                await updateDutchItems(with: response)
            } catch {
                await updateErrorMessage(error.localizedDescription)
            }
        }
    }

    @MainActor
    private func updateDutchItems(with response: DutchListResponse) {
        let items = createDutchItems(from: response)
        dutchItems = items
        
        // Cell ViewModels 생성
        for item in items {
            if case .detailItem(let detail) = item {
                if listItemCellViewModels[detail.dutchId] == nil {
                    let status = detail.isDone ? DetailItemCellRequestStatus.completed : DetailItemCellRequestStatus.none
                    listItemCellViewModels[detail.dutchId] = DutchPayListItemCellViewModel(item: detail, status: status)
                }
            }
        }
        
//        logger("dutchItems : \(dutchItems)")
    }

    @MainActor
    private func updateErrorMessage(_ message: String) {
        errorMessage = message
    }

    ///광고 처리를 위한 데이터 가공
    private func createDutchItems(from response: DutchListResponse) -> [DutchItem] {
        var items: [DutchItem] = []
        
        // Summary 추가
        let summary = response.dutchSummary
        items.append(.summary(summary))
        
        let details = response.dutchDetailList
        let firstDetail = DutchDetail(dutchId: 0, name: summary.ownerName, amount: summary.ownerAmount, transferMessage: "", isDone: true)
        items.append(.detailItem(firstDetail))
        
        let middleIndex = details.count / 2
        
        // detail 데이터 중간에 광고 추가
        for (index, detail) in details.enumerated() {
            items.append(.detailItem(detail))
            if index == middleIndex {
                items.append(.ad)
            }
        }
        return items
    }
    
    ///cell에서 사용할 viewModel 추출
    func viewModelForItem(at indexPath: IndexPath) -> DutchPayListItemCellViewModel? {
        guard indexPath.row < dutchItems.count else { return nil }
        if case .detailItem(let detail) = dutchItems[indexPath.row] {
            return listItemCellViewModels[detail.dutchId]
        }
        return nil
    }
}

