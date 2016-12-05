//
//  ViewController.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/11/15.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var placeholder: UIView = {
        let v = UINib(nibName: "Greeting", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        v.frame = UIScreen.main.bounds
        return v
    }()
    
    lazy var placeholderButton: UIButton = {
       self.placeholder.viewWithTag(1) as! UIButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        addLeftBarButtonWithImage(UIImage(named: "navigationbar_more")!)
        
        view.addSubview(placeholder)
        placeholderButton.addTarget(self, action: #selector(MainViewController.shareButtonPushed), for: .touchUpInside)
    }
    
    @objc func shareButtonPushed() {
        let ns = ShareViewController()
        ns.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(ns, animated: true)
    }
}

