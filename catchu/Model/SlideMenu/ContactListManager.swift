//
//  ContactListManager.swift
//  catchu
//
//  Created by Erkut Baş on 11/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import Contacts

class ContactListManager {
    
    public static let shared = ContactListManager()
    
    var contactListUserArray : [User]?
    var contactListViewModelUserArray : [ViewModelUser]?
    var contactListExists : Bool = false
    var contactListPhoneArray : [Provider]?
    var rawContactList : [CNContact]?
    
    func initiateFetchContactBusiness(completion : @escaping (_ finish : Bool) -> Void) {
        
        ContactListManager.shared.contactListExists = false
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            fetchContacts(completion: completion)
        case .notDetermined:
            startFetchingContact(completion: completion)
        case .denied, .restricted:
            directToSettingsForEnableContactAccess()
        }
        
    }
    
    func returnRawContact(index : Int) -> CNContact {
        
        if let array = ContactListManager.shared.rawContactList {
            return array[index]
        } else {
            return CNContact()
        }
        
    }
    
    func returnViewModelUser(index : Int) -> ReturnResult<ViewModelUser> {
        
        if let viewModelUserArray = ContactListManager.shared.contactListViewModelUserArray {
            return .success(viewModelUserArray[index])
        }
        
        return .failure(User())
    }
    
    func appendViewModelUserArray(viewModelUser : ViewModelUser) {
        
        if ContactListManager.shared.contactListViewModelUserArray == nil {
            ContactListManager.shared.contactListViewModelUserArray = [ViewModelUser]()
        }
        
        ContactListManager.shared.contactListViewModelUserArray?.append(viewModelUser)
        
    }
    
    func isAtLeastOneContactListExist() -> Bool {
        
        if let array = ContactListManager.shared.contactListUserArray {
            if array.count > 0 {
                return true
            }
        }
        
        if let array = ContactListManager.shared.rawContactList {
            if array.count > 0 {
                return true
            }
        }
        
        return false
        
    }
    
    func returnUserListCount() -> Int {
        
        if let array = ContactListManager.shared.contactListUserArray {
            print("returnUserListCount : \(array.count)")
            return array.count
        } else {
            return 0
        }
        
    }
    
    func returnRawContactListCount() -> Int {
        
        if let array = ContactListManager.shared.rawContactList {
            print("returnRawContactListCount : \(array.count)")
            return array.count
        } else {
            return 0
        }
        
    }
    
    private func appendNewUserToContactListUserArray(user : User) {
        
        if ContactListManager.shared.contactListUserArray == nil {
            ContactListManager.shared.contactListUserArray = [User]()
        }
        
        ContactListManager.shared.contactListUserArray?.append(user)
        
        let viewModelUser = ViewModelUser(user: user)
        ContactListManager.shared.appendViewModelUserArray(viewModelUser: viewModelUser)
        
    }
    
    private func appendNewProviderToArray(provider : Provider) {
        
        if ContactListManager.shared.contactListPhoneArray == nil {
            ContactListManager.shared.contactListPhoneArray = [Provider]()
        }
        
        ContactListManager.shared.contactListPhoneArray?.append(provider)
        
    }
    
    private func createPhoneProviderList(contact : CNContact) {
        
        for phone in contact.phoneNumbers {
            
            print("contact name : \(contact.givenName)")
            print("phone label : \(phone.label)")
            
            print("convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue) : \(convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue))")
            
            let provider = Provider()
            provider.providerType = ProviderType.phone.rawValue
            provider.providerid = convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue)
            
            appendNewProviderToArray(provider: provider)
            
        }
        
    }
    
    func createRawContactList(contact : CNContact) {
        
        if ContactListManager.shared.rawContactList == nil {
            ContactListManager.shared.rawContactList = [CNContact]()
        }
        
        ContactListManager.shared.rawContactList?.append(contact)
        
    }
    
    private func startFetchingContact(completion : @escaping (_ finish : Bool) -> Void) {
        
        CNContactStore().requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                if let error = error as NSError? {
                    print("error : \(error.localizedDescription)")
                }
            } else {
                if granted {
                    print("contact fetch is granted")
                    self.fetchContacts(completion: completion)
                } else {
                    print("contact fetch is not granted")
                }
            }
        }
        
    }
    
    private func fetchContacts(completion : @escaping (_ finish : Bool) -> Void) {
        
        let keys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactSocialProfilesKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        let store = CNContactStore()
        
        do {
            try store.enumerateContacts(with: request) { (contactData, stopPointerIfYouWantToStopEnumeration) in
                
                self.createPhoneProviderList(contact: contactData)
                self.createRawContactList(contact: contactData)
                
            }
        } catch let err {
            print("Failed to enumerate contact list: ", err)
        }
        
        self.getUsersSyncedOnDatabase(completion: completion)
        
    }
    
    private func directToSettingsForEnableContactAccess() {
        
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        
    }
    
    private func convertPhoneNumberWithCountryCode(inputPhoneString : String) -> String {
        
        print("inputPhoneString :\(inputPhoneString)")
        
        let rawPhoneString = inputPhoneString.replacingOccurrences(of: "[ |()-]", with: "", options: [.regularExpression])
        
        print("rawPhoneString :\(rawPhoneString)")
        
        if inputPhoneString.contains("+") {
            return rawPhoneString
        } else {
            return Country.currentCountry.phoneExtension + rawPhoneString
        }
        
    }
    
    private func convertReUserToClientUserList(reUserList : [REUser]) {
        
        if reUserList.count > 0 {
            ContactListManager.shared.contactListExists = true
        }
        
        for reUser in reUserList {
            
            let user = User(user: reUser)
            appendNewUserToContactListUserArray(user: user)
        
        }
        
    }
    
    private func getUsersSyncedOnDatabase(completion : @escaping (_ finish : Bool) -> Void) {
        print("getUsersSyncedOnDatabase starts")
        
        guard let userid = User.shared.userid else { return }
        
        let providerList = REProviderList()
        
        if providerList?.items == nil {
            providerList?.items = [REProvider]()
        }
        
        if let phoneArray = ContactListManager.shared.contactListPhoneArray {
            for phone in phoneArray {
                
                let reProvider = REProvider()
                reProvider?.providerid = phone.providerid
                reProvider?.providerType = phone.providerType
                
                providerList?.items?.append(reProvider!)
            }
        }
        
        APIGatewayManager.shared.initiateDeviceContactListExploreOnCatchU(userid: userid, providerList: providerList!) { (result) in
        
            switch result {
            case .success(let data):
                print("data : \(data.items)")
                print("data count : \(data.items?.count)")
                
                if let error = data.error {
                    print("error code : \(error.code)")
                    print("error message : \(error.message)")
                    
                    completion(false)
                }
                
                if let userItems = data.items {
                    self.convertReUserToClientUserList(reUserList: userItems)
                    completion(true)
                }
                
            case .failure(let error):
                print("error : \(error)")
                completion(false)
                return
            }
            
        }
        
    }
    
    
}
