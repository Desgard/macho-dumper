//
//  ViewController.swift
//  Devmo
//
//  Created by 段昊宇 on 2017/7/19.
//  Copyright © 2017年 Desgard_Duan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var tableView: UITableView!

    fileprivate let cellData = [
        "PhotoKit",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViews()
        addSubviews()
    }
    
    private func initialViews() {
        title = "Devmo"
        
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = cellData[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cellData[indexPath.row] {
        case "PhotoKit":
            navigationController?.pushViewController(AblumViewController(), animated: true)
        default:
            print("Inviad")
        }
    }
}

