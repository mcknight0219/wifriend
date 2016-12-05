//
//  WifiCard.swift
//  WiFriend
//
//  Created by Qiang Guo on 2016/12/4.
//  Copyright © 2016年 Qiang Guo. All rights reserved.
//

import Foundation
import Contacts

struct WifiCard {
    enum DefaultKeys: String {
        case network = "NetworkName"
        case password = "NetworkPassword"
        case contactCard = "ContactCard"
        
        static let allKeys = [network, password, contactCard].map { $0.rawValue }
    }
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    init(fromData: Data) {
        self.init()
        // initialize from Data scanned from QR code
    }
    
    var data: Data? {
        var dataString: String
        if let network = network, let password = password {
            dataString = "\(network);\(password)"
            if let contact = self.contact {
                dataString += "\(contact.givenName) \(contact.familyName);\(contact.phoneNumbers.first?.value.stringValue)"
            }
            
            return dataString.data(using: .utf8)
        }

        return nil
    }
    
    var network: String? {
        get {
            return defaults.string(forKey: DefaultKeys.network.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: DefaultKeys.network.rawValue)
        }
    }
    
    var password: String? {
        get {
            return defaults.string(forKey: DefaultKeys.password.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: DefaultKeys.password.rawValue)
        }
    }
    
    var contact: CNContact? {
        get {
            if let data = defaults.object(forKey: DefaultKeys.contactCard.rawValue) as? Data {
                do {
                    let contacts = try CNContactVCardSerialization.contacts(with: data)
                    return contacts.isEmpty ? nil : contacts.first
                } catch {
                    return nil
                }
            }
            return nil
        }
        set {
            if let contact = newValue {
                let vcard = try! CNContactVCardSerialization.data(with: [contact])
                defaults.setValue(vcard, forKey: DefaultKeys.contactCard.rawValue)
            }
        }
    }
}

extension WifiCard {
    func delete() {
        DefaultKeys.allKeys.forEach { k in
            defaults.setValue(nil, forKey: k)
        }
    }
}
