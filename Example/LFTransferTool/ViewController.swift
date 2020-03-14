//
//  ViewController.swift
//  LFTransferTool
//
//  Created by loyfo on 03/14/2020.
//  Copyright (c) 2020 loyfo. All rights reserved.
//

import UIKit
import LFTransferTool


class ViewController: UIViewController {

    @IBOutlet weak var inputFiled: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let transferTool = TransferTool(identifier: "TransferTool")

    var  availablePeers: [Peer] = []
    var selectedPeers: [Peer] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "DeviceCell")
        transferTool.dataSource = self
        transferTool.delegate = self
        transferTool.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendAction(_ sender: Any) {
        self.inputFiled.resignFirstResponder()
        guard self.selectedPeers.count > 0 else {
            let alertView = UIAlertView(title: "操作无法完成", message: "请先选择设备", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "好")
            alertView.show()
            return
        }
        transferTool.send(package: TransferPackage.package(with: self.inputFiled.text ?? "")!,to: self.selectedPeers)
    }


    func toggle(_ peer: Peer) {
        if selectedPeers.contains(peer) {
            selectedPeers.remove(at: selectedPeers.firstIndex(of: peer)!)
        } else {
            selectedPeers.append(peer)
        }

        self.tableView.reloadData()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePeers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") else { return UITableViewCell() }
        let peer = availablePeers[indexPath.row]

        cell.textLabel?.text = peer.name

        cell.accessoryView = selectedPeers.contains(peer) ? UIImageView(image: UIImage(named: "checkmark")):nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.toggle(availablePeers[indexPath.row])
    }
}


extension ViewController: TransferToolDelegate, TransferToolDatasource {
    func didReceviedPackage(_ package: TransferPackage) {
        switch package.type {
        case .image:
            self.imageView.image = package.imageValue()
        default:
            self.inputFiled.text = package.stringValue()
        }
    }

    func availablePeersDidChange(_ peers: [Peer]) {
        self.availablePeers = peers
        self.selectedPeers = peers.filter({ (peer) -> Bool in
            return self.selectedPeers.map({$0.name}).contains(peer.name)
        })

        self.tableView.reloadData()
    }
}
