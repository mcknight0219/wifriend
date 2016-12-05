//
//  NetworkSelectViewController.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/11/15.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import UIKit
import ChameleonFramework
import ContactsUI
import RxSwift
import MBProgressHUD

enum ShareStage: Int {
    case network = 1
    case password = 2
    case card = 3
    
    var navigationRightButtonName: String {
        switch self {
        case .card:
            return "Skip"
        default:
            return "Next"
        }
    }
}

class ShareViewController: UIViewController {
    
    var viewModel = ShareViewModel()
    
    var disposeBag = DisposeBag()
    
    var stage: ShareStage = .network
    
    enum dataKey {
        case network
        case password
        case contact
    }
    var wifi = WifiCard()
    
    lazy var nextButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(stageSegue))
    }()
    
    lazy var stepOne: NetworkSelect = {
        let v = NetworkSelect(frame: UIScreen.main.bounds)
        v.setViewModel(viewModel: self.viewModel)
        v.networkNameTextField.rx.text
            .asObservable()
            .map { $0 != nil && $0!.characters.count > 3 }
            .bindTo(self.nextButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
        return v
    }()
    
    lazy var stepTwo: Password = {
        // Make it offscreen first so we can animate them
        let v = Password(frame: UIScreen.main.bounds)
        v.setViewModel(viewModel: self.viewModel)
        v.password.rx.text
            .asObservable()
            .map { $0 != nil && $0!.characters.count > 0 }
            .bindTo(self.nextButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
        return v
    }()

    lazy var stepThree: Contact = {
        let v = Contact(frame: UIScreen.main.bounds)
        v.setViewModel(viewModel: self.viewModel)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Share"
        navigationItem.rightBarButtonItem = self.nextButton
        
        self.setCurrentStageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ShareViewController {
    func setCurrentStageView() {
        switch self.stage {
        case .network:
            view.addSubview(stepOne)
        
        case .password:
            wifi.network = stepOne.networkNameTextField.text
            UIView.transition(from: stepOne, to: stepTwo, duration: 0.33, options: [.transitionFlipFromLeft], completion: nil)
        
        case .card:
            wifi.password = stepTwo.password.text
            UIView.transition(from: stepTwo, to: stepThree, duration: 0.33, options: [.transitionFlipFromRight]) { [weak self] completed in
                if let weakSelf = self {
                    weakSelf.stepThree.selectFromContactButton.rx.tap
                        .subscribeOn(MainScheduler.instance)
                        .subscribe(onNext: { _ in
                            let pickerViewController = CNContactPickerViewController()
                            pickerViewController.delegate = weakSelf
                            pickerViewController.modalPresentationStyle = .fullScreen
                            pickerViewController.modalTransitionStyle = .crossDissolve
                            
                            weakSelf.present(pickerViewController, animated: true, completion: nil)
                        })
                        .addDisposableTo(weakSelf.disposeBag)
                    
                    weakSelf.stepThree.createNewButton.rx.tap
                        .subscribeOn(MainScheduler.instance)
                        .subscribe(onNext: { _ in
                            let newContactViewController = CNContactViewController(forNewContact: nil)
                            newContactViewController.delegate = weakSelf
                            newContactViewController.modalPresentationStyle = .fullScreen
                            newContactViewController.modalTransitionStyle = .coverVertical
                            
                            weakSelf.navigationController?.pushViewController(newContactViewController, animated: true)
                        })
                        .addDisposableTo(weakSelf.disposeBag)
                }
            }
            
        }
        nextButton.title = stage.navigationRightButtonName
    }
    
    func stageSegue() {
        switch self.stage {
        case .network:
            self.stage = .password
        
        case .password:
            self.stage = .card
        
        case .card:
            self.pushQRViewController()
            return
        }
        
        self.setCurrentStageView()
    }
    
    private func pushQRViewController() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Loading"
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            let data = wifi.data
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.applying(transform) {
                // output is the qr code, show it after some delay 
                // to make user think We are hard working
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    if let weakSelf = self {
                        MBProgressHUD.hide(for: weakSelf.view, animated: true)
                        let qrViewController = QRViewController(qrImage: UIImage(ciImage: output))
                        weakSelf.navigationController?.pushViewController(qrViewController, animated: true)
                    }
                }
            }
        }
    }
}

extension ShareViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.wifi.contact = contact
    }
}

extension ShareViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.navigationController?.popViewController(animated: true)
        self.wifi.contact = contact
    }
    
}
