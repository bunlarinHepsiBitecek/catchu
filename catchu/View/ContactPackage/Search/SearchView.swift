//
//  SearchView.swift
//  catchu
//
//  Created by Erkut Baş on 7/31/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    @IBOutlet var searchBar: UISearchBar!
    
    // let's create a MasterController object
    var referenceMasterViewController : SearchViewController!
    
    var searchProgressActive: Bool?
    
    // initialize prosess
    func initializeView() {
        
        searchBarPropertyManagement()
        
    }
    
}

// extension for searchBar
extension SearchView : UISearchBarDelegate {
    
    // to make searchBar textField background invisible
    func searchBarPropertyManagement() {
        
        let textFieldInsideSearchBar = searchBar.value(forKey: Constants.searchBarProperties.searchField) as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
        
        searchBar.searchBarStyle = .minimal
        
    }
    
    func searchTrigger(input : String, completion : @escaping (_ result : Bool) -> Void) {
    
        let client = RECatchUMobileAPIClient.default()
        
        client.searchGet(userid: User.shared.userID, searchValue: input).continueWith { (taskRESearchResult) -> Any? in
            
            if taskRESearchResult.error != nil {
                
                print("error : \(taskRESearchResult.error?.localizedDescription)")
                
            } else {
                
                print("result : \(taskRESearchResult.result)")
                
                Search.shared.appendElementIntoSearchArrayResult(httpResult: taskRESearchResult.result!)
                
            }
            
            completion(true)
            
            return nil
            
        }
        
    }
    
    func startSearchDisplay(inputSearchKey : String) {
        
        Search.shared.isSearchProgressActive = true
        Search.shared.searchKey = inputSearchKey
        
        //Search.shared.searchResultArray.removeAll()
        
        referenceMasterViewController.childReferenceContainerSearchResultViewController?.searchKey = inputSearchKey
        referenceMasterViewController.childReferenceContainerSearchResultViewController?.tableView.reloadData()
        
    }
    
    func startSearchResult() {
        
        Search.shared.isSearchProgressActive = false
        referenceMasterViewController.childReferenceContainerSearchResultViewController?.tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // empty searchResult array
//        SectionBasedFriend.shared.emptySearchResult()
        
        Search.shared.searchResultArray.removeAll()
        
        print("textDidChange triggered")
        print("searchText : \(searchText)")
        
        startSearchDisplay(inputSearchKey: searchText)
        
        searchTrigger(input: searchText) { (result) in
            
            if result {
                
                DispatchQueue.main.async {
                    
                    self.startSearchResult()
                    
                }
                
            }
            
        }

        if !searchText.isEmpty {
        
            searchBar.setShowsCancelButton(true, animated: true)
            
//            SectionBasedFriend.shared.isSearchModeActivated = true
            
        } else {
            
            print("search text field is empty")
//            SectionBasedFriend.shared.isSearchModeActivated = false
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.endEditing(true)
            
            Search.shared.searchResultArray.removeAll()
            
            referenceMasterViewController.childReferenceContainerSearchResultViewController?.tableView.reloadData()
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        
        Search.shared.searchResultArray.removeAll()
        
        referenceMasterViewController.childReferenceContainerSearchResultViewController?.tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = Constants.CharacterConstants.SPACE
        self.searchBar.endEditing(true)
        
        Search.shared.searchResultArray.removeAll()
        
        referenceMasterViewController.childReferenceContainerSearchResultViewController?.tableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
        
    }
    
    
}


