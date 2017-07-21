//
//  AblumViewController.swift
//  Devmo
//
//  Created by 段昊宇 on 2017/7/21.
//  Copyright © 2017年 Desgard_Duan. All rights reserved.
//

import UIKit

class AblumViewController: UIViewController {
    private var tableView: UITableView!
    
    private var manager: AlbumManager = AlbumManager.shared
    fileprivate var cellModels: [AblumModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initialViews()
        reloadDatas()
        addSubviews()
    }
    
    
    private func initialViews() {
        title = "Ablums"
        
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func reloadDatas() {
        manager.getAlbumItems { (ablums) in
            var newModels: [AblumModel] = []
            for item in ablums {
                newModels.append(AblumModel.init(item: item))
            }
            self.cellModels = newModels
            self.tableView.reloadData()
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
}

extension AblumViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension AblumViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = cellModels[indexPath.row].title
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
