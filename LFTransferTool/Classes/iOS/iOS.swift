//
//  iOS.swift
//  LFTransferTool-iOS
//
//  Created by 黄维平 on 2020/3/14.
//

import UIKit

public extension TransferPackage {
    func imageValue() -> UIImage? {
        guard type == .image else { return nil }
        return UIImage(data: data)
    }

    static func package(with image: UIImage) -> TransferPackage? {
        guard let data = image.pngData() else { return nil }
        return TransferPackage(type: .image, data: data)
    }
}
