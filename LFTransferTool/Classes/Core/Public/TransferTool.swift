//
//  TransferTool.swift
//  TransferTool
//
//  Created by 黄维平 on 2020/3/13.
//  Copyright © 2020 hwp. All rights reserved.
//


public protocol TransferToolDelegate: NSObjectProtocol {
    func didReceviedPackage(_ package: TransferPackage)
}

public protocol TransferToolDatasource: NSObjectProtocol {
    func availablePeersDidChange(_ peers: [Peer])
}

@objcMembers
public class TransferTool: NSObject {

    // MARK: - Public

    /// 初始化传输工具
    /// - Parameter identifier: 标识符(长度在1至15个字符之间，由ASCII字母、数字和“-”组成，不能以“-”为开头或结尾，不能包含除了“-”之外的其他特殊字符)
    public required init(identifier: String) {
        transferIdentifier = identifier
        super.init()
    }

    /// 可用节点
    public private(set) var availablePeers: [Peer] = []

    public weak var delegate: TransferToolDelegate?

    public weak var dataSource: TransferToolDatasource? {
        didSet {
            transceiver.availablePeersDidChange =  { [weak self] peers in
                self?.availablePeers = peers
                self?.dataSource?.availablePeersDidChange(peers)
            }
        }
    }

    /// 可观察数据源,适用于SwiftUI
    @available(iOS 13.0, *)
    @available(OSX 10.15, *)
    public private(set) lazy var observerbleDataSource: MultipeerDataSource = {
           MultipeerDataSource(transceiver: transceiver)
    }()

    /// 开始监听
    public func resume() {
        transceiver.resume()
    }

    /// 停止监听
    public func stop() {
        transceiver.stop()
    }

    /// 发送包
    /// - Parameters:
    ///   - package: 包
    ///   - peers: 节点列表
    public func send(package: TransferPackage, to peers: [Peer]) {
        self.transceiver.send(package, to: peers)
    }

    // MARK: - Private

    private let transferIdentifier: String

    private lazy var transceiver: MultipeerTransceiver = {
        var config = MultipeerConfiguration.default
        config.serviceType = transferIdentifier.count > 15 ? String(transferIdentifier.suffix(12)) : transferIdentifier
        config.security.encryptionPreference = .required
        let t = MultipeerTransceiver(configuration: config)
        t.receive(TransferPackage.self) { [weak self] package in
            print("Got payload: \(package)")
            self?.notify(with: package)
        }
        return t
    }()

    private func notify(with package: TransferPackage) {
        self.delegate?.didReceviedPackage(package)
    }
}
