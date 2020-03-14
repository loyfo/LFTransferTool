//
//  TransferPackage.swift
//  TransferTool
//
//  Created by 黄维平 on 2020/3/13.
//  Copyright © 2020 hwp. All rights reserved.
//

import Foundation

public enum TransferPackageType: Int,Codable {
    case image
    case string
    case other
}

public struct TransferPackage: Hashable, Codable {
    public let type: TransferPackageType
    public let data: Data
    public init(type: TransferPackageType, data: Data) {
        self.type = type
        self.data = data 
    }
}


public extension Data {
    func transferStringValue() ->  String? {
        return String(bytes: self, encoding: .utf8)
    }
}

public extension TransferPackage{
    func stringValue() -> String? {
        guard type == .string else { return nil }
        return String(bytes: data, encoding: .utf8)
    }

    static func package(with string: String) -> TransferPackage? {
        guard let data = string.data(using: .utf8) else { return nil }
        return TransferPackage(type: .string, data: data)
    }
}
