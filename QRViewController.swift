//
//  QRViewController.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/12/4.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit
import ChameleonFramework

class QRViewController: UIViewController {
    
    var qrImage: UIImage?
    init(qrImage: UIImage?) {
        self.qrImage = qrImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cardView: QRCard = {
        let view = QRCard(frame: CGRect(x: 0, y: 0, width: 250, height: 400))
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FlatBlackDark()

        let card = WifiCard()
        cardView.network.text = card.network!
        if let contact = card.contact {
            cardView.contact.text = "\(contact.familyName) \(contact.givenName)"
        }
        cardView.qrImage.image = qrImage
        cardView.center = view.center
        view.addSubview(cardView)
        
        navigationItem.title = "My QR Code"
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    func doneButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

}
