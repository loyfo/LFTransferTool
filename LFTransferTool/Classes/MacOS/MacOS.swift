//
//  MacOS.swift
//  LFTransferTool-iOS
//
//  Created by 黄维平 on 2020/3/14.
//

import Cocoa

public extension TransferPackage {
    func imageValue() -> NSImage? {
        guard type == .image else { return nil }
        return NSImage(data: data)
    }

    static func package(with image: NSImage) -> TransferPackage? {
        guard let data = image.tiffRepresentation else { return nil }
        return TransferPackage(type: .image, data: data)
    }
}
