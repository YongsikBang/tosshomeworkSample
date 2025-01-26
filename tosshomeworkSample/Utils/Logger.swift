//
//  Logger.swift
//  tosshomeworkSample
//
//  Created by 방용식/대리개발 on 1/25/25.
//  Copyright © 2025 Viva Republica. All rights reserved.
//

import Foundation
import OSLog

extension Logger {
    fileprivate static var map: [String: Logger] = [:]
    fileprivate static let queue = DispatchQueue(label: "loggerQueue", attributes: .concurrent)

    fileprivate static func pick(key: String, `default`: Logger) -> Logger {
        queue.sync {
            if let exist = map[key] {
                return exist
            } else {
                queue.async(flags: .barrier) {
                    map[key] = `default`
                }
                return `default`
            }
        }
    }

    public enum MessageOption {
        case date
        case codePosition
    }
}

public func logger(
    _ message: @autoclosure () -> Any,
    level: OSLogType = .debug,
    subsystem: String = Bundle.main.bundleIdentifier ?? "tosshomeworkSample",
    category: String = "public",
    options: [Logger.MessageOption] = [],
    filePath : String = #file,
    funcName : String = #function,
    lineNumber : Int = #line
) {
#if DEBUG
    let key: String = "\(subsystem)_\(category)"
    let logger: Logger = .pick(key: key, default: .init(subsystem: subsystem, category: category))
    var optionString: String = ""
    if options.contains(.date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSSS"
        optionString += "[\(formatter.string(from: Date()))]"
    }
    if options.contains(.codePosition) {
        let fileName = (filePath as NSString).lastPathComponent.split(separator: ".")[0]
        optionString += "[\(fileName)-\(funcName):\(lineNumber)]"
    }
    let message: String = "\(message())"
    logger.log(level: level, "\(optionString)\(options.count > 0 ? " " : "")\(message)")
#endif
}

