//
//  ContentView.swift
//  LFTransferTool-Example-Mac
//
//  Created by 黄维平 on 2020/3/14.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import LFTransferTool

final class ViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var image: NSImage = NSImage(named: "AppIcon")!
    @Published var selectedPeers: [Peer] = []

    func toggle(_ peer: Peer) {
        if selectedPeers.contains(peer) {
            selectedPeers.remove(at: selectedPeers.firstIndex(of: peer)!)
        } else {
            selectedPeers.append(peer)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var dataSource: MultipeerDataSource

    @State private var showErrorAlert = false

    var body: some View {
        VStack {
            Form {
                TextField("Message", text: $viewModel.message)

                Button(action: { self.sendToSelectedPeers(self.viewModel.message) }) {
                    Text("SEND")
                }
            }

            Image(nsImage: self.viewModel.image ).resizable().aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text("Peers").font(.system(.headline)).padding()

                List {
                    ForEach(dataSource.availablePeers) { peer in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(peer.isConnected ? .green : .gray)

                            Text(peer.name)

                            Spacer()

                            if self.viewModel.selectedPeers.contains(peer) {
                                Image("checkmark")
                            }
                        }.onTapGesture {
                            self.viewModel.toggle(peer)
                        }
                    }
                }
            }
        }.alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Please select a peer"), message: nil, dismissButton: nil)
        }

    }

    func sendToSelectedPeers(_ message: String) {
        guard !self.viewModel.selectedPeers.isEmpty else {
            showErrorAlert = true
            return
        }

        if FileManager.default.fileExists(atPath: message)  {
            let url = URL(fileURLWithPath: message)
            if let data = try? Data(contentsOf: url) {
                let imageLoad = TransferPackage(type: .image, data: data)
                dataSource.transceiver.send(imageLoad, to: viewModel.selectedPeers)
                return
            }
        }

        if let data = self.viewModel.message.data(using: .utf8) {
             let payload = TransferPackage(type: .string, data:data )
            dataSource.transceiver.send(payload, to: viewModel.selectedPeers)
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
