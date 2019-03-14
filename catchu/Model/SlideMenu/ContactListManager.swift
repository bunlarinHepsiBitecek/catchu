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
    private var contactListPhoneArray = [Provider]()
    private var rawContactList = [CNContact]()
    
    private func resetFetchContactLists() {
        contactListPhoneArray.removeAll()
        rawContactList.removeAll()
    }
    
    func initiateFetchContactBusiness(completion : @escaping (_ finish : Bool, _ providerList: [Provider], _ rawContactList: [CNContact]) -> Void) {
        
        ContactListManager.shared.contactListExists = false
        resetFetchContactLists()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            let keys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactSocialProfilesKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            let store = CNContactStore()
            
            var counter=1
            
            do {
                
                try store.enumerateContacts(with: request) { (contactData, stopPointerIfYouWantToStopEnumeration) in
                    counter += 1
                    
                    print("takasi bomba : \(counter)")
                    
                    self.createPhoneProviderList(contact: contactData)
                    self.createRawContactList(contact: contactData)
                    
                }
            } catch let err {
                print("Failed to enumerate contact list: ", err)
            }
            
            print("yarro bomba")
            
            completion(true, contactListPhoneArray, rawContactList)
            
        default:
            completion(false, [], [])
        }
        
    }
    
    func triggerPermissionForContact(completion: @escaping(_ granted: Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                if let error = error as NSError? {
                    print("error : \(error.localizedDescription)")
                }
            } else {
                if granted {
                    print("contact fetch is granted")
                    completion(granted)
                } else {
                    print("contact fetch is not granted")
                }
            }
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
    
    func returnUserListCount() -> Int {
        
        if let array = ContactListManager.shared.contactListUserArray {
            print("returnUserListCount : \(array.count)")
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
        ContactListManager.shared.contactListPhoneArray.append(provider)
    }
    
    private func createRawContactList(contact : CNContact) {
        ContactListManager.shared.rawContactList.append(contact)
    }
    
    private func createPhoneProviderList(contact : CNContact) {
        
        for phone in contact.phoneNumbers {
            
            print("contact name : \(contact.givenName)")
            print("phone label : \(phone.label)")
            
            print("convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue) : \(convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue))")
            
//            let provider = Provider()
//            provider.providerType = ProviderType.phone.rawValue
//            provider.providerid = convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue)
            
            let providerid = convertPhoneNumberWithCountryCode(inputPhoneString: phone.value.stringValue)
            let provider = Provider(id: providerid, type: ProviderType.phone)
            appendNewProviderToArray(provider: provider)
            
        }
        
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
//                    self.fetchContacts(completion: completion)
                } else {
                    print("contact fetch is not granted")
                }
            }
        }
        
    }
    
    func directToSettingsForEnableContactAccess() {
        
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        
    }
    
    private func convertPhoneNumberWithCountryCode(inputPhoneString : String) -> String {
        
        print("inputPhoneString :\(inputPhoneString)")
        
        //let rawPhoneString = inputPhoneString.replacingOccurrences(of: "[ |()-]", with: "", options: [.regularExpression])
        var rawPhoneString = inputPhoneString.replacingOccurrences(of:"[^0-9]", with: "", options: .regularExpression)
        
        rawPhoneString = "+" + rawPhoneString
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
                reProvider?.providerType = phone.providerType.rawValue
                
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
