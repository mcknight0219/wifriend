//
//  Password.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/11/21.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Password: UIView {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var password: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private var disposeBag = DisposeBag()
    private var viewModel: ShareViewModel? {
        didSet {
            if let vm = viewModel {
                vm.SSID
                    .asDriver(onErrorJustReturn: "")
                    .map { ssid in
                        return "Type password for: \(ssid)"
                    }
                    .drive(hintLabel.rx.text)
                    .addDisposableTo(disposeBag)
                
                password.becomeFirstResponder()
            }
        }
    }
    func setViewModel(viewModel: ShareViewModel) {
        self.viewModel = viewModel
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Password", owner: self, options: nil)
        guard let content = contentView else {
            return
        }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content.backgroundColor = UIColor(colorLiteralRed: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        self.addSubview(content)
    }
}
