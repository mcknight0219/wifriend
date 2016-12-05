//
//  MenuViewController.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/11/15.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit
import ChameleonFramework

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 34/255, blue: 45/255, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let headerHeight = (self.view.frame.size.height - 38 * 3) / 2;
        //tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        cell.textLabel?.textColor = FlatWhiteDark()
        cell.backgroundColor = UIColor.clear
        
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(colorLiteralRed: 28/255, green: 28/255, blue: 37/255, alpha: 1)
        cell.selectedBackgroundView = selectedBg
        
        switch row {
        case 0:
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "WiFriend"
        case 1:
            cell.imageView?.image = UIImage(named: "home")
            cell.textLabel?.text  = "Home"
        case 2:
            cell.imageView?.image = UIImage(named: "radar")
            cell.textLabel?.text  = "Discover"
        case 3:
            cell.imageView?.image = UIImage(named: "setting")
            cell.textLabel?.text  = "Settings"
        default:
            break
        }
        
        return cell
    }
}
