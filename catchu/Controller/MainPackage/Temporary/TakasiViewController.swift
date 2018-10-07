//
//  TakasiViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class TakasiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    
    var tableViewDataForRequests : REFriendRequestList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return User.shared.requestingFriendList.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var tempObj = User()
        
        tempObj = User.shared.requestingFriendList[indexPath.row]

        if let userid = tempObj.userid {
            cell.textLabel?.text = userid
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let client = RECatchUMobileAPIClient.default()
        
        guard let inputBody = REFriendRequest() else { return }
        
        inputBody.requestType = Constants.AwsApiGatewayHttpRequestParameters.RequestOperationTypes.Friends.acceptRequest
        inputBody.requesterUserid = cell?.textLabel?.text
        if let userid = User.shared.userid {
            inputBody.requestedUserid = userid
        }
        
        
        // TODO: Authorization
        FirebaseManager.shared.getIdToken { (tokenResult, finished) in
            
            if finished {
                
                client.followRequestPost(authorization: tokenResult.token, body: inputBody).continueWith { (task) -> Any? in
                    print("task : \(task.result)")
                    
                    
                    if task.error != nil {
                        print("error : \(task.error)")
                    }else {
                        print("task result :\(task.result)")
                    }
                    
                    return nil
                }
                
                
            }
            
        }
        
    }
    
    
    


}
