//
//  ExtensionContainerSearchResultViewController.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

extension ContainerSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Search.shared.isSearchProgressActive {
            
            return 1
            
        } else {
            
            return Search.shared.searchResultArray.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // if search process is active, an activity indicator should be seen in a prototype of the tableView
        if Search.shared.isSearchProgressActive {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.tableViewCellSearchProcess, for: indexPath) as? SearchProcessTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.searchProcessInformation.text = LocalizedConstants.SearchBar.searchingFor + searchKey!
            
            cell.activityIndicator.hidesWhenStopped = true
            cell.activityIndicator.activityIndicatorViewStyle = .gray
    
            DispatchQueue.main.async {
                
                cell.activityIndicator.center = cell.viewForActivityIndicator.center
                cell.activityIndicator.startAnimating()
                cell.viewForActivityIndicator.addSubview(cell.activityIndicator)
            }
            
            
            return cell
          
        }  else {
            
            // if search process is done (AWSTASK is completed), the code below lists users
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Collections.TableView.tableViewCellSearchResult, for: indexPath) as? SearchResultTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            // first of all initiate cell properties
            cell.initializeCellProperties()
            
            print("indexPath.row : \(indexPath.row)")
            print("searchData : \(Search.shared.searchResultArray.count)")
            
            // getting search result from neo4j
            let searchObject = Search.shared.searchResultArray[indexPath.row]
            cell.searchResultUser = searchObject
            cell.searchUsername.text = searchObject.userName
            cell.searchUserExtraLabel.text = searchObject.name
            
            if searchObject.profilePictureUrl != Constants.CharacterConstants.SPACE {
                
                cell.searchUserImage.setImagesFromCacheOrFirebaseForFriend(searchObject.profilePictureUrl)
                
            }
            
            cell.requestButtonVisualManagementWhileLoadingTableView()
            
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    // didselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !Search.shared.isSearchProgressActive {

            let cell = tableView.cellForRow(at: indexPath) as! SearchResultTableViewCell

            //cell.defaultButtonColors()
            
            let storyboard = UIStoryboard(name: Constants.Storyboard.Name.Main, bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileMainViewController") as! ProfileMainViewController
//            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            //navigationController?.pushViewController(vc, animated: true)
            
//            self.tabBarController?.selectedIndex = 3
//            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "totoViewController") as? totoViewController {
//
//                if let navigator = self.tabBarController?.viewControllers?[3] as? UINavigationController {
//                    navigator.pushViewController(controller, animated: true)
//                }
//            }
            

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.NumericValues.rowHeight
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Constants.NumberOrSections.section1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Search.shared.isSearchProgressActive {
            
            return LocalizedConstants.SearchBar.searching
            
        } else {
            
            if Search.shared.searchResultArray.count > 0 {
                
                return LocalizedConstants.SearchBar.searchResult
                
            } else {
                
                return Constants.CharacterConstants.SPACE
                
            }
            
        }
        
    }
    
    
}
