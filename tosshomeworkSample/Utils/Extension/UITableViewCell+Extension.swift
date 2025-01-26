//
//  UITableViewCell+Extension.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var cellReuseIdentifier: String {
        return String(describing: Self.self)
    }
}
