//
//  GroupInfoEditTableViewController.swift
//  catchu
//
//  Created by Erkut Baş on 12/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class GroupInfoEditTableViewController: UITableViewController {

    var groupViewModel: CommonGroupViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareViewController()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupInfoEditTableViewCell.identifier, for: indexPath) as? GroupInfoEditTableViewCell else { return UITableViewCell() }
        
        cell.initiateCellDesign(item: groupViewModel)
        
        return cell
    }
    
    func addListenerToGroupNameChangeState(completion : @escaping (_ newString : String) -> Void) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - major functions
extension GroupInfoEditTableViewController {
    
    private func prepareViewController() {
        print("\(#function)")
        
        groupViewModel?.groupNameChanged.value = "gazgaz"
        
        addBarButtons()
        setupViewSettings()
        
    }
    
    private func setupViewSettings() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.title = LocalizedConstants.TitleValues.ViewControllerTitles.groupInfoEdit
        self.tableView.register(GroupInfoEditTableViewCell.self, forCellReuseIdentifier: GroupInfoEditTableViewCell.identifier)
    }
    
    private func addBarButtons() {
        
        let leftBarButton = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.cancel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.dismissViewController(_:)))
        let rigthBarButton = UIBarButtonItem(title: LocalizedConstants.TitleValues.ButtonTitle.save, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.saveChanges(_:)))
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rigthBarButton
        
    }
    
    @objc func dismissViewController(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveChanges(_ sender : UIButton) {
        //self.dismiss(animated: true, completion: nil)
    }
}
