//
//  ExtensionContainerGroupViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/6/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

// tableView functions
extension ContainerGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("SectionBasedGroup.shared.returnSectionNumber.count : \(SectionBasedGroup.shared.returnSectionNumber(index: section))")
        
        if SectionBasedGroup.shared.groupNameInitialBasedDictionary.count > 0 {
            
            return SectionBasedGroup.shared.returnSectionNumber(index: section)
            
        } else {
            
            print("zalama")
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.tableViewCellGroup, for: indexPath) as? GroupTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        let groupObject = SectionBasedGroup.shared.returnGroupFromSectionBasedDictionary(indexPath: indexPath)
        
        cell.group = groupObject
        
        cell.groupImage.setImagesFromCacheOrFirebaseForFriend(groupObject.groupPictureUrl)
        cell.groupName.text = groupObject.groupName
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.NumericValues.rowHeight50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionBasedGroup.shared.groupNameInitialBasedDictionary.keys.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return SectionBasedGroup.shared.groupSectionKeyData
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionBasedGroup.shared.groupSectionKeyData[section]
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cellAtIndex = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
        
        let delete = UITableViewRowAction(style: .destructive, title: Constants.TableViewEditingStyleButtons.Delete) { (action, indexPath) in
            
        }
        
        let info = UITableViewRowAction(style: .default, title: Constants.TableViewEditingStyleButtons.More) { (action, indexPath) in
            
            self.openActionsForGroupInfo(group: cellAtIndex.group)
            
        }
        
        info.backgroundColor = UIColor.lightGray
        
        return [delete, info]
        
    }
    
}

// row properties
extension ContainerGroupViewController {
    
    func openActionsForGroupInfo(group: Group) {
        
        let groupInfoAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let infoFlowAction = UIAlertAction(title: Constants.AlertControllerConstants.Titles.titleGroupInfo, style: .default) { (alertAction) in
            
            print("Info tapped")
            
            //self.gotoGroupInformationViewController()
            self.startGroupInformationPresentation(group: group)
            
        }
        
        let exitGroupAction = UIAlertAction(title: Constants.AlertControllerConstants.Titles.titleExitGroup, style: .destructive) { (alertAction) in
            
            print("Exit group tapped")
            
        }
        
        let cancelAlertAction = UIAlertAction(title: Constants.AlertControllerConstants.Titles.titleCancel, style: .cancel) { (alertAction) in
            
            print("Cancel is tapped")
            
        }
        
        groupInfoAlertController.addAction(infoFlowAction)
        groupInfoAlertController.addAction(exitGroupAction)
        groupInfoAlertController.addAction(cancelAlertAction)
        
        self.present(groupInfoAlertController, animated: true, completion: nil)
        
    }
    
    func gotoGroupInformationViewController() {

        if let destinationViewController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.GroupInformationViewController) as? GroupInformationViewController {

            present(destinationViewController, animated: true, completion: nil)

        }

    }
    
    func startGroupInformationPresentation(group: Group) {
        
        print("startGroupInformationPresentation starts")
        print("groupId : \(group.groupID)")
        
        print("Participant.shared.participantDictionary[group.groupID] : \(Participant.shared.participantDictionary[group.groupID])")
        
        if Participant.shared.participantDictionary[group.groupID] != nil {
            
            if let destinationViewController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.GroupInformationViewController) as? GroupInformationViewController {
                
                destinationViewController.group = group
                destinationViewController.referenceOfContainerGroupViewController = self
                self.present(destinationViewController, animated: true, completion: nil)
                
            }
            
        } else {
            
            LoaderController.shared.showLoader()
            
            APIGatewayManager.shared.getGroupParticipantList(requestType: .get_group_participant_list, groupId: group.groupID) { (groupRequestResult, responseBool) in
                
                if responseBool {
                    
                    LoaderController.shared.removeLoader()
                    
                    for item in groupRequestResult.resultArrayParticipantList! {
                        
                        let tempUser = User()
                        
                        tempUser.setUserProfileProperties(httpRequest: item)
                        
                        if Participant.shared.participantDictionary[group.groupID] == nil {
                            Participant.shared.participantDictionary[group.groupID] = [User]()
                        }

                        Participant.shared.participantDictionary[group.groupID]?.append(tempUser)
                        
                    }
                    
                    print("***COUNT : \(Participant.shared.participantDictionary[group.groupID]?.count)")
                    
                    DispatchQueue.main.async {
                        
                        if let destinationViewController = UIStoryboard(name: Constants.Storyboard.Name.Contact, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.GroupInformationViewController) as? GroupInformationViewController {
                            
                            destinationViewController.group = group
                            destinationViewController.referenceOfContainerGroupViewController = self
                            self.present(destinationViewController, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
