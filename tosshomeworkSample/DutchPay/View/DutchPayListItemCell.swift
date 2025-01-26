//
//  DutchPayListItemCell.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import UIKit
import Combine

class DutchPayListItemCell: UITableViewCell {
    
    private var viewModel: DutchPayListItemCellViewModel?
    private var cancallables = Set<AnyCancellable>()
    
    private let profileImageView: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.backgroundColor = .white
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    private let statusLabelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    private let statusIcon: ProgressButton = {
        let button = ProgressButton()
        button.isHidden = true
        return button
    }()
    
    private let mainStackView = UIStackView()
    
    var showAlert: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupAction()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.spacing = 16
        
        let textTopStackView = UIStackView(arrangedSubviews: [nameLabel, amountLabel, statusLabelButton])
        textTopStackView.axis = .horizontal
        textTopStackView.spacing = 8
        
        let textStackView = UIStackView(arrangedSubviews: [textTopStackView, commentLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        
        mainStackView.addArrangedSubview(profileImageView)
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(statusIcon)
        
        statusIcon.setContentHuggingPriority(.defaultLow, for: .horizontal)
        statusIcon.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            statusLabelButton.widthAnchor.constraint(equalToConstant: 80),
            
            statusIcon.widthAnchor.constraint(equalToConstant: 40),
            statusIcon.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupAction() {
        statusLabelButton.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
        statusIcon.addTarget(self, action: #selector(progressButtonPressed), for: .touchUpInside)
    }
    
    @objc private func statusButtonPressed() {
        logger("statusButtonPressed")
        guard let viewModel = viewModel else { return }
        
        //요청가능 여부 체크
        let canRequest = viewModel.handleRequest()
        if !canRequest {
            showAlert?()
        }
        
    }
    
    @objc private func progressButtonPressed() {
        guard let viewModel = viewModel else { return }
        viewModel.resetProgress()
    }
    
    func configureCell(viewModel: DutchPayListItemCellViewModel) {
        self.viewModel = viewModel
        setupBind()
    }
    
    private func setupBind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$detailItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] detail in
                guard let self else { return }
                profileImageView.text = detail.profileDisplayString
                nameLabel.text = detail.name
                amountLabel.text = detail.amountDisplayString
                commentLabel.text = detail.transferMessage
                commentLabel.isHidden = detail.commentHidden
                statusLabelButton.setTitle(detail.statusDisplayString, for: .normal)
                statusLabelButton.setTitleColor(detail.statusTextColor, for: .normal)
            })
            .store(in: &cancallables)
        
        viewModel.$isProgressing
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isProgressing in
                guard let self else { return }
                logger("isProgressing: \(isProgressing)",options: [.codePosition])
                updateStatusAninmation(for: isProgressing)
            })
            .store(in: &cancallables)
        viewModel.$requestStatus
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in
                guard let self else { return }
                logger("status: \(status)",options: [.codePosition])
                updateStatusUI(for: status)
            })
            .store(in: &cancallables)
    }
    
    private func updateStatusAninmation(for isProgressing: Bool) {
        if isProgressing {
            statusIcon.isHidden = false
            statusLabelButton.isHidden = true
            statusIcon.animate(from: 0)
        }
        else {
            statusIcon.isHidden = true
            statusLabelButton.isHidden = false
            statusIcon.cancel()
            updateStatusUI(for: viewModel?.requestStatus ?? DetailItemCellRequestStatus.none)
        }
    }
    
    private func updateStatusUI(for status: DetailItemCellRequestStatus) {
        
        amountLabel.textColor = .lightGray
        
        switch status {
        case .completed:
            statusIcon.isHidden = true
            statusLabelButton.isHidden = false
            statusIcon.cancel()
            
            let status = viewModel?.detailItem.isDone == true ? String.localized(of: .statusButtonTitleDone) : String.localized(of: .statusButtonTitleFalse)
            statusLabelButton.setTitle(status, for: .normal)
            statusLabelButton.setTitleColor(viewModel?.detailItem.isDone == true ? .black : .systemBlue, for: .normal)
            
        case .requested:
            statusLabelButton.setTitle(.localized(of: .statusButtonTitleProgressing), for: .normal)
            statusLabelButton.setTitleColor(.systemBlue, for: .normal)
            
        case .none:
            let status = viewModel?.detailItem.isDone == true ? String.localized(of: .statusButtonTitleDone) : String.localized(of: .statusButtonTitleFalse)
            statusLabelButton.setTitle(status, for: .normal)
            statusLabelButton.setTitleColor(viewModel?.detailItem.isDone == true ? .black : .systemBlue, for: .normal)
        }
    }
}
