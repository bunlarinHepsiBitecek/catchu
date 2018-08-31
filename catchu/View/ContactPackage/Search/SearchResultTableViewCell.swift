//
//  SearchResultTableViewCell.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet var searchUserImage: UIImageViewDesign!
    @IBOutlet var searchUsername: UILabel!
    @IBOutlet var searchUserExtraLabel: UILabel!
    @IBOutlet var friendRequestButton: UIButton!
    
    var searchResultUser = User()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initiateRelationProcess(inputRequestType : RequestType) {
        
        let client = RECatchUMobileAPIClient.default()
        
        let input = REFriendRequest()
        
        input?.requesterUserid = User.shared.userID
        input?.requestedUserid = searchResultUser.userID
        
//        switch inputRequestType {
//        case .delete:
//
//            if searchResultUser.isUserHasAFriendRelation {
//
//                input?.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Friends.deleteFollow
//
//            } else if searchResultUser.isUserHasPendingFriendRequest {
//
//                input?.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Friends.deletePendingFollowRequest
//
//            }
//
//        case .create:
//
//            if searchResultUser.isUserHasAPrivateAccount {
//
//                input?.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Friends.followRequest
//
//            } else {
//
//                input?.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Friends.createFollowDirectly
//
//            }
//
//        default:
//            print("do nothing")
//            return
//        }
        
        print("input?.requesterUserid : \(input?.requesterUserid)")
        print("input?.requestedUserid : \(input?.requestedUserid)")
        
        client.requestProcessPost(body: input!).continueWith { (taskResponse) -> Any? in
            
            print("taskresponse :\(taskResponse)")
            print("taskResponse.result?.error?.code?.boolValue :\(taskResponse.result?.error?.code?.boolValue)")
            print("taskResponse.result?.error?.code? :\(taskResponse.result?.error?.code)")
            
            if (taskResponse.result?.error?.code?.boolValue)! {
                
//                DispatchQueue.main.async {
//                    
//                    UIView.transition(with: self.friendRequestButton, duration: 0.3, options: .allowAnimatedContent, animations: {
//                        
//                        switch inputRequestType {
//                            
//                        case .delete:
//                            self.friendRequestButton.setTitle(LocalizedConstants.Contact.addFriend, for: .normal)
//                        
//                        case .create:
//                            if self.searchResultUser.isUserHasAPrivateAccount {
//                                self.friendRequestButton.setTitle(LocalizedConstants.Contact.requested, for: .normal)
//                                
//                            } else {
//                                self.friendRequestButton.setTitle(LocalizedConstants.Contact.friends, for: .normal)
//                                
//                            }
//                            
//                        default :
//                            print("do nothing")
//                        }
//
//                        self.blackTones()
//                        
//                    })
//                    
//                }
                
            }
            
            return nil
            
        }
        
    }
    
    func returnRequestType() -> RequestType {
        
        if searchResultUser.isUserHasAFriendRelation {
            return RequestType.deleteFollow
        } else {
            if searchResultUser.isUserHasPendingFriendRequest {
                return RequestType.deletePendingFollowRequest
            } else {
                if searchResultUser.isUserHasAPrivateAccount {
                    return RequestType.followRequest
                } else {
                    return RequestType.createFollowDirectly
                }
            }
        }
    }
    
    func requestButtonVisualManagementWhileLoadingTableView() {
        
        if searchResultUser.isUserHasAFriendRelation {
            self.friendRequestButton.setTitle(LocalizedConstants.Contact.friends, for: .normal)
            blackTones()
        } else if searchResultUser.isUserHasPendingFriendRequest {
            self.friendRequestButton.setTitle(LocalizedConstants.Contact.requested, for: .normal)
            blackTones()
        } else {
            self.friendRequestButton.setTitle(LocalizedConstants.Contact.addFriend, for: .normal)
            defaultButtonColors()
        }
        
    }
    
    // function below decides button titles after updating nodes in neo4j
    func requestButtonVisualManagement(httpResult : REFriendRequestList) {
        
        if (httpResult.updatedUserRelationInfo?._friendRelation.boolValue)! {
           
            UIView.transition(with: self.friendRequestButton, duration: 0.3, options: .allowAnimatedContent, animations: {
                self.friendRequestButton.setTitle(LocalizedConstants.Contact.friends, for: .normal)
                self.blackTones()
            })
            
        } else if (httpResult.updatedUserRelationInfo?._pendingFriendRequest.boolValue)! {
            
            UIView.transition(with: self.friendRequestButton, duration: 0.3, options: .allowAnimatedContent, animations: {
                self.friendRequestButton.setTitle(LocalizedConstants.Contact.requested, for: .normal)
                self.blackTones()
            })

        } else {

            UIView.transition(with: self.friendRequestButton, duration: 0.3, options: .allowAnimatedContent, animations: {
                self.friendRequestButton.setTitle(LocalizedConstants.Contact.addFriend, for: .normal)
                self.defaultButtonColors()
            })
            
        }
        
    }
    
    func updateUserRelationInfo(httpResult : REFriendRequestList) {
        
        print("httpResult.updatedUserRelationInfo?._friendRelation.boolValue : \(httpResult.updatedUserRelationInfo?._friendRelation.boolValue)")
        print("httpResult.updatedUserRelationInfo?._pendingFriendRequest.boolValue : \(httpResult.updatedUserRelationInfo?._pendingFriendRequest.boolValue)")
        
        if let result = httpResult.updatedUserRelationInfo {
            
            if let resultFollowRelation = result._friendRelation as? NSNumber {
                self.searchResultUser.isUserHasAFriendRelation = resultFollowRelation.boolValue
            }
            
            if let resultPendingRequestRelation = result._pendingFriendRequest as? NSNumber {
                self.searchResultUser.isUserHasPendingFriendRequest = resultPendingRequestRelation.boolValue
            }
            
        }
        
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        
        APIGatewayManager.shared.requstProces(inputRequestType: returnRequestType(), reqester: User.shared.userID, requested: searchResultUser.userID) { (response) in
            
            // when httprequest is finished, let's update user cell information
            if let responseData = response as? REFriendRequestList {
                
                DispatchQueue.main.async {
                    
                    self.updateUserRelationInfo(httpResult: responseData)
                    self.requestButtonVisualManagement(httpResult: responseData)
                    
                }
                
            }
            
        }
        
//        print("yarroooooooooooo")
//
//        if searchResultUser.isUserHasAFriendRelation || searchResultUser.isUserHasPendingFriendRequest{
//
//            initiateRelationProcess(inputRequestType: .delete)
//
//        } else {
//
//            initiateRelationProcess(inputRequestType: .create)
//
//        }
        
    }

}

extension SearchResultTableViewCell {
    
    // disableButton
    func disableRequestButton() {
        
        self.friendRequestButton.isEnabled = false
        
    }
    
    func enableRequestButton() {
        
        self.friendRequestButton.isEnabled = true
        
    }
    
    // initialize cell properties
    func initializeCellProperties() {

        self.searchUsername.text = Constants.CharacterConstants.SPACE
        self.searchUserExtraLabel.text = Constants.CharacterConstants.SPACE

        initializeButtonSettings()

        self.searchUserImage.image = UIImage()

    }

    func initializeButtonSettings() {

        friendRequestButton.setTitle(LocalizedConstants.Contact.addFriend, for: .normal)

        friendRequestButton.layer.borderWidth = 1.0
        friendRequestButton.clipsToBounds = true
        friendRequestButton.layer.cornerRadius = 10

        self.defaultButtonColors()

    }

    func defaultButtonColors() {
        friendRequestButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        friendRequestButton.layer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        friendRequestButton.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    
    func blackTones() {
        
        friendRequestButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        friendRequestButton.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        friendRequestButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    func requestedMapping() {
        
        friendRequestButton.setTitle(LocalizedConstants.Contact.requested, for: .normal)
        
        blackTones()
        
    }
    
    func friendMapping() {
        
        friendRequestButton.setTitle(LocalizedConstants.Contact.friends, for: .normal)
        
        blackTones()
        
    }
    
    func setInitialButtonSettings() {

        friendRequestButton.setTitle(LocalizedConstants.Contact.addFriend, for: .normal)

        friendRequestButton.layer.borderWidth = 1.0
        friendRequestButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        friendRequestButton.layer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        friendRequestButton.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        friendRequestButton.clipsToBounds = true
        friendRequestButton.layer.cornerRadius = 10

    }

    func changeButtonSelectedSettings() {

        friendRequestButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        friendRequestButton.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        friendRequestButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    }

    func changeButtonSelectedSettingsForPending() {

        friendRequestButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        friendRequestButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.7692478895, blue: 0.8473142982, alpha: 1)
        friendRequestButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    }

    func changeButtonDeSelectedSettings() {

        friendRequestButton.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        friendRequestButton.layer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        friendRequestButton.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

    }
    
}

