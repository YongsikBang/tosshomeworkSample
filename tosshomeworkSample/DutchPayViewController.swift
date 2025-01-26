//
//  DutchPayViewController.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import UIKit
import Combine

class DutchPayViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel = DutchPayViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupTableView()
        setupTableViewRefresh()
        setupBind()
        viewModel.fetchDutchList()
        observeAppLifecycle()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        //cell 등록
        tableView.register(DutchPaySummaryCell.self, forCellReuseIdentifier: DutchPaySummaryCell.cellReuseIdentifier)
        tableView.register(DutchPayListItemCell.self, forCellReuseIdentifier: DutchPayListItemCell.cellReuseIdentifier)
        tableView.register(DutchPayADCell.self, forCellReuseIdentifier: DutchPayADCell.cellReuseIdentifier)
        
        //tableview 기본설정
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableViewRefresh() {
        //새로고침 추가
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupBind() {
        //데이터 처리
        viewModel.$dutchItems
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                tableView.reloadData()
                
                //새로고침 완료후 UI처리
                if tableView.refreshControl?.isRefreshing == true {
                    tableView.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancellables)
        
        //오류처리
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] errorMessage in
                guard let self else { return }
                
                //error alert 추가
                showAlertMessage(message: errorMessage, type: .error)
                
                //새로고침 UI처리
                if tableView.refreshControl?.isRefreshing == true {
                    tableView.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancellables)
    }
    
    private func observeAppLifecycle() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restoreTimers),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    //백그라운드 처리
    @objc private func restoreTimers() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    ///새로고침
    @objc private func refreshData() {
        viewModel.fetchDutchList()
    }

    private func showAlertMessage(message: String, type: AlertType) {
        var showMessage: String?
        switch type {
        case .error:
            let errorMessage = String.localized(of: .alertErrorMessage)
            showMessage = message.isEmpty ? errorMessage : "\(errorMessage)\n\(message)"
        case .request:
            showMessage = message
        }
        
        let alert = UIAlertController(title: "알림", message: showMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

enum AlertType {
    case error
    case request
}

extension DutchPayViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dutchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.dutchItems[indexPath.row]
        logger("item :\(item)")
        switch item {
        case .summary(let summary):
            guard 
                let cell = tableView.dequeueReusableCell(withIdentifier: DutchPaySummaryCell.cellReuseIdentifier, for: indexPath) as? DutchPaySummaryCell
            else { return UITableViewCell() }
            
            cell.configureCell(dateString: summary.dateDisplayString, amountString: summary.amountDisplayString, ownerMessage: summary.ownerDisplayMessage)
            
            return cell
        case .detailItem( _ ):
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: DutchPayListItemCell.cellReuseIdentifier, for: indexPath) as? DutchPayListItemCell
            else { return UITableViewCell() }
            
            if let cellViewModel = viewModel.viewModelForItem(at: indexPath) {
//                logger("viewmodel : \(cellViewModel.detailItem)",options: [.codePosition])
                cell.configureCell(viewModel: cellViewModel)
                
                cell.showAlert = { [weak self] in
                    guard let self else { return }
                    let message = String.localized(of: .alertNotAllowMessage)
                    showAlertMessage(message: message, type: .request)
                }
            }
            
            return cell
        case .ad:
            guard 
                let cell = tableView.dequeueReusableCell(withIdentifier: DutchPayADCell.cellReuseIdentifier, for: indexPath) as? DutchPayADCell
            else { return UITableViewCell() }
            return cell
        }
    }
}
