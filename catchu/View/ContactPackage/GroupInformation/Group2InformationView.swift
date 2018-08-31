//
//  Group2InformationView.swift
//  catchu
//
//  Created by Erkut Baş on 8/25/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Group2InformationView: UIView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var referenceViewController = GroupInformationViewController()
    
    func initialize() {
        
        imageView.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.image = UIImage.init(named: "8771.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        addSubview(imageView)
        
        tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    @IBAction func backBarButtonTapped(_ sender: Any) {
        
        referenceViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}

extension Group2InformationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "erkut deneme " + String(describing: indexPath.row)
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrollView.contentOffset.y : \(scrollView.contentOffset.y)")
        
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 444)
        
        
        imageView.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: height)
        
    }
    
}
