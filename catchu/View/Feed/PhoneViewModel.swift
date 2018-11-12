//
//  PhoneViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class PhoneViewModel: BaseViewModel {
    let sectionCount = 1
    var footerTitle: String?
    var items = [PhoneViewModelItem]()
    var verificationId = Dynamic("")
    var isComplateVerify = Dynamic(false)
    
    var confirmationItem = PhoneViewModelConfirmationItem()
    
    override func setup() {
        super.setup()
    }
    
    func loadData() {
        let user = User.shared
        var country = Country.currentCountry
        var phoneNum = ""
        if let phone = user.phone {
            if let countryCode = phone.countryCode {
                country = Countries.countryFromCountryCode(countryCode: countryCode)
            }
            if let phoneNumber = phone.phoneNumber {
                phoneNum = "\(phoneNumber)"
            }
        }
        
        items.removeAll()
        setup(country: country, phoneNum: phoneNum)
    }
    
    private func setup(country: Country, phoneNum: String) {
        let countryItem = PhoneViewModelCountryItem(country: country)
        let phoneItem = PhoneViewModelPhoneItem(country: country, phone: phoneNum)
        
        items.append(countryItem)
        items.append(phoneItem)
    }
    
    func loadConfirmation() {
        items.removeAll()
        items.append(confirmationItem)
    }
    
    //MARK: Validation
    public var isValidCountry: Bool {
        for item in items {
            if let country = item.country {
                return country != Country.emptyCountry && country.countryCode.count > 1 && country.countryCode.count < 5
            }
        }
        return false
    }
    
    public var phoneNum: String {
        for item in items {
            if let phoneItem = item as? PhoneViewModelPhoneItem, let country = phoneItem.country, let phoneNumber = phoneItem.phone, !phoneNumber.isEmpty {
                return country.phoneExtension + phoneNumber
            }
        }
        return ""
    }
    
    
    /// call from PhoneViewController
    public func sendSMSVerificationCode() {
        if !phoneNum.isEmpty {
            FirebaseManager.shared.phoneSendSMSVerification(phoneNum: phoneNum) { (verificationId) in
                print("phoneSendSMSVerification success verificationId: \(verificationId)")
                self.verificationId.value = verificationId
            }
        } else {
            isComplateVerify.value = true
        }
    }
    
    /// call from PhoneViewConfirmationViewController
    public func smsConfirmation() {
        FirebaseManager.shared.phoneSMSConfirmation(verificationId: verificationId.value, verificationCode: confirmationItem.confirmationCode) { (success) in
            print("smsConfirmation Success: \(success)")
            if success {
                self.isComplateVerify.value = true
            }
        }
    }
    
}


enum PhoneViewModelItemType {
    case country
    case phone
    case confirmation
    
    var reuseIdentifier: String {
        switch self {
        case .country:
            return PhoneViewCountryCell.identifier
        case .phone:
            return PhoneViewPhoneCell.identifier
        case .confirmation:
            return PhoneViewConfirmationCell.identifier
        }
    }
}

protocol PhoneViewModelItem {
    var type: PhoneViewModelItemType { get }
    var country: Country? {get set}
}

class PhoneViewModelCountryItem: PhoneViewModelItem {
    var type: PhoneViewModelItemType {
        return .country
    }
    
    var country: Country?
    
    init(country: Country?) {
        self.country = country
    }
}

class PhoneViewModelPhoneItem: PhoneViewModelItem {
    var type: PhoneViewModelItemType {
        return .phone
    }
    
    var country: Country?
    var phone: String?
    
    init(country: Country?, phone: String?) {
        self.country = country
        self.phone = phone
    }
}

class PhoneViewModelConfirmationItem: PhoneViewModelItem {
    var type: PhoneViewModelItemType {
        return .confirmation
    }
    
    var country: Country?
    var confirmationCode = ""
    var isValidConfirmation = Dynamic(false)
    
    init() {}
}

extension PhoneViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    // data method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // data method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .country:
            if let cell = tableView.dequeueReusableCell(withIdentifier: item.type.reuseIdentifier, for: indexPath) as? PhoneViewCountryCell {
                
                cell.configure(item: item)
                return cell
            }
        case .phone:
            if let cell = tableView.dequeueReusableCell(withIdentifier: item.type.reuseIdentifier, for: indexPath) as? PhoneViewPhoneCell {
                
                cell.configure(item: item)
                return cell
            }
        case .confirmation:
            if let cell = tableView.dequeueReusableCell(withIdentifier: item.type.reuseIdentifier, for: indexPath) as? PhoneViewConfirmationCell {
                
                cell.configure(item: item)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitle
    }
}
