//
//  ViewController.swift
//  tosshomeworkSample
//
//  Created by 정준영 on 23/05/2019.
//  Copyright © 2019 Viva Republica. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let dutchPayViewController = DutchPayViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        setupSubView()
    }
    
    private func setupUI() {
        //상단 UI조정
        title = .localized(of: .dutchViewTitle)
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
    }
    
    private func setupSubView() {
        //더치페이뷰 추가
        addChild(dutchPayViewController)
        view.addSubview(dutchPayViewController.view)
        dutchPayViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dutchPayViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dutchPayViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dutchPayViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dutchPayViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        dutchPayViewController.didMove(toParent: self)
    }
    
}

