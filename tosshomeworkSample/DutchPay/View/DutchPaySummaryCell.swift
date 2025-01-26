//
//  DutchPaySummaryCell.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import UIKit

class DutchPaySummaryCell: UITableViewCell {
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
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
        contentView.addSubview(bgView)
        bgView.addSubview(dateLabel)
        bgView.addSubview(amountLabel)
        bgView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        contentView.addSubview(lineView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 20),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            dateLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: 0),

            amountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 0),
            amountLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: 0),

            messageView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 12),
            messageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 0),
            messageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: 0),
            messageView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 0),

            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(dateString: String, amountString: String, ownerMessage: String) {
        dateLabel.text = dateString
        amountLabel.text = amountString
        messageLabel.text = ownerMessage
    }

}
