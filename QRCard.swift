//
//  QRCard.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/12/4.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit

class QRCard: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var network: UILabel!
    @IBOutlet weak var contact: UILabel!
    
    @IBOutlet weak var qrImage: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("QRCard", owner: self, options: nil)
        guard let content = contentView else {
            return
        }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content.backgroundColor = UIColor.white
        
        self.addSubview(content)
    }
}
