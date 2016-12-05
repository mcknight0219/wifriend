//
//  Contact.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/12/1.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit

class Contact: UIView {
    
    @IBOutlet var contentView: UIView?
    
    @IBOutlet weak var selectFromContactButton: UIButton!
    @IBOutlet weak var createNewButton: UIButton!
    
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
    
    var viewModel: ShareViewModel! {
        didSet {
            
        }
    }
    func setViewModel(viewModel: ShareViewModel) {
        self.viewModel = viewModel
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Contact", owner: self, options: nil)
        guard let content = contentView else {
            return
        }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content.backgroundColor = UIColor(colorLiteralRed: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        self.addSubview(content)
    }
}
