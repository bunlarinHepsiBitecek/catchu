 //
//  Profile4ViewController.swift
//  catchu
//
//  Created by Erkut Baş on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class Profile4ViewController: UIViewController {

    @IBOutlet var profile4: Profile4!
    @IBOutlet var menubar4: MenuBar4!
    @IBOutlet var slidingView4: SlidingView4!
    @IBOutlet var mainViewOfController: UIView!
    
    var referenceForMainTabBarController = MainTabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtons()
        
        setupProfile4()
        setupMenuBar4()
        setupSlidingView4()
        
        menubar4.setFirstItemSelected()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Profile4ViewController {
    
    func addBarButtons() {
        
        let leftImage = UIImage(named: "baseline_settings_black_24pt_1x")
        let leftItem = UIImageView(image: leftImage)
        
        let rigthImage = UIImage(named: "user_black")
        let rigthItem = UIImageView(image: rigthImage)
        
        let tapGestureRecognizerLeftBarItem = UITapGestureRecognizer(target: self, action: #selector(self.leftBarButtonPressed(_:)))
        leftItem.addGestureRecognizer(tapGestureRecognizerLeftBarItem)
       
        let tapGestureRecognizerRigthBarItem = UITapGestureRecognizer(target: self, action: #selector(self.rigthBarButtonPressed(_:)))
        rigthItem.addGestureRecognizer(tapGestureRecognizerRigthBarItem)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItem)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthItem)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    @objc func leftBarButtonPressed(_ tapGesture : UITapGestureRecognizer) {
        
        print("leftBarButtonPressed starts")
        
    }
    
    @objc func rigthBarButtonPressed(_ tapGesture : UITapGestureRecognizer) {
        
        print("rigthBarButtonPressed starts")
        
        if let destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            
            
            present(destinationViewController, animated: true, completion: nil)
            
        }
        
        
    }
    
    func setupProfile4() {
        
        profile4.translatesAutoresizingMaskIntoConstraints = false
        
        self.profile4.initialize()
        
        self.mainViewOfController.addSubview(profile4)
        
        // set reference for data transfer
        self.profile4.referenceOfProfile4ViewController = self
        self.profile4.referenceOfSlidingView4 = self.slidingView4
        self.profile4.referenceOfMenuBarView4 = self.menubar4
        
        let safeGuide = self.mainViewOfController.safeAreaLayoutGuide
        
        self.profile4.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        self.profile4.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        self.profile4.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        self.profile4.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
        
    }
    
    func setupMenuBar4() {
    
        menubar4.translatesAutoresizingMaskIntoConstraints = false
        
        self.menubar4.initialize()
        self.profile4.middleView.addSubview(menubar4)
        
        // set reference for data transfer
        self.menubar4.referenceOfSlidingView4 = self.slidingView4
        
        let safeGuide = self.profile4.middleView.safeAreaLayoutGuide
        
        self.menubar4.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        self.menubar4.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        self.menubar4.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        self.menubar4.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
        
    }
    
    func setupSlidingView4() {
        
        slidingView4.translatesAutoresizingMaskIntoConstraints = false
        
        self.slidingView4.initialize()
        
        // set reference for data transfer
        self.slidingView4.referenceOfMenubar4 = self.menubar4
        
        self.profile4.bottomView.addSubview(slidingView4)
        
        let safeGuide = self.profile4.bottomView.safeAreaLayoutGuide
        
        self.slidingView4.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        self.slidingView4.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        self.slidingView4.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        self.slidingView4.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
        
    }
    
    
}
