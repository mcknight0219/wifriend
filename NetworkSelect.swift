//
//  NetworkSelect.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/11/15.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NetworkSelect: UIView {

    @IBOutlet var contentView: UIView?
    @IBOutlet weak var networkNameTextField: UITextField!
    
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
                    .observeOn(MainScheduler.asyncInstance)
                    .asDriver(onErrorJustReturn: "")
                    .drive(networkNameTextField.rx.text)
                    .addDisposableTo(disposeBag)
                
                
                networkNameTextField.becomeFirstResponder()
            }
        }
    }
    func setViewModel(viewModel: ShareViewModel) {
        self.viewModel = viewModel
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NetworkSelect", owner: self, options: nil)
        guard let content = contentView else {
            return
        }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content.backgroundColor = UIColor(colorLiteralRed: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        self.addSubview(content)
    }

}
