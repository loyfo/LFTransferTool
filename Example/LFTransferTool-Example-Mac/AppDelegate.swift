//
//  AppDelegate.swift
//  LFTransferTool-Example-Mac
//
//  Created by 黄维平 on 2020/3/14.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import SwiftUI
import LFTransferTool

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    let transferTool = TransferTool(identifier: "TransferTool")

    private lazy var viewModel = ViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        transferTool.delegate = self
        transferTool.resume()

        let contentView = ContentView().environmentObject(viewModel).environmentObject(transferTool.observerbleDataSource)

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func notify(with package: TransferPackage) {

        switch package.type {
        case .string:

            self.viewModel.message = package.data.transferStringValue() ?? "无内容"
        case .image:
            if let image = package.imageValue() {
                self.viewModel.image = image
            }
        default:
            break
        }
    }

}

extension AppDelegate: TransferToolDelegate {
    func didReceviedPackage(_ package: TransferPackage) {
        self.notify(with: package)
    }

}
