//
//  FeedViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/15/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}


class FeedViewCell: BaseTableCell {
    
    
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        headerView.backgroundColor = UIColor.yellow
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    lazy var conteinerView: SwipingView = {
        let conteinerView = SwipingView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 250))
        conteinerView.backgroundColor = UIColor.orange
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        return conteinerView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //we use lazy properties for each view
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        profileImageView.image = UIImage(named: "baseline_person_black_48pt.png")
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.cyan
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        name.text = "catchuname"
        name.backgroundColor = UIColor.blue
        name.translatesAutoresizingMaskIntoConstraints = false
       
        return name
    }()
    
    let username: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 17, weight: .light)
        username.text = "catchuuser"
        
        username.backgroundColor = UIColor.red
        username.translatesAutoresizingMaskIntoConstraints = false
        
        return username
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-more"), for: UIControlState())
        button.backgroundColor = UIColor.lightGray
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.text = "Live as @remzi if #yildirim you were to die tomorrow; learn as if you were to live forever.\nThe weak can never forgive. Forgiveness is the attribute of the strong.\nHappiness is when what you think, what you say, and what you do are in harmony."

        textView.backgroundColor = UIColor.green
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        textView.resolveHashTags()
        
        return textView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Like", for: .normal)
        button.setImage(UIImage(named: "icon-like"), for: UIControlState())
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comment", for: .normal)
        button.setImage(UIImage(named: "icon-comment"), for: UIControlState())
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.red
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.setImage(UIImage(named: "icon-share"), for: UIControlState())
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.yellow
        return button
    }()
    
    lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(commentButton)
        stackView.addArrangedSubview(shareButton)
        return stackView
    }()
    
    let likeCount: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("780.423 likes", for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.cyan
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        headerView.addSubview(profileImageView)
        headerView.addSubview(name)
        headerView.addSubview(username)
        headerView.addSubview(moreButton)
        headerView.addSubview(statusTextView)
        
        addSubview(headerView)
        addSubview(conteinerView)
        
        footerView.addSubview(footerStackView)
        footerView.addSubview(likeCount)
        addSubview(footerView)
        
        NSLayoutConstraint.activate([
            //pin profileImage to headerView
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageView.frame.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageView.frame.height),
            
            
            //pin name to headerView
            name.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            name.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -10),
            name.heightAnchor.constraint(equalToConstant: 20),
            
            //pin username to headerView
            username.topAnchor.constraint(equalTo: name.bottomAnchor),
            username.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            username.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            //layout addButton in headerView
            moreButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            moreButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 30),
            moreButton.heightAnchor.constraint(equalToConstant: 30),
            
            // pin statustext to headerview
            statusTextView.topAnchor.constraint(equalTo: username.bottomAnchor),
            statusTextView.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            statusTextView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            statusTextView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            //pin headerView to top
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerView.frame.height),
            
            conteinerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            conteinerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            conteinerView.heightAnchor.constraint(equalToConstant: self.conteinerView.frame.height)
            
            ])
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: conteinerView.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ])
        
        let footerLayout = self.footerView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            footerStackView.topAnchor.constraint(equalTo: footerLayout.topAnchor),
            footerStackView.leadingAnchor.constraint(equalTo: footerLayout.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: footerLayout.trailingAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        let footerStackLayout = self.footerStackView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            likeCount.topAnchor.constraint(equalTo: footerStackLayout.bottomAnchor),
            likeCount.leadingAnchor.constraint(equalTo: footerLayout.leadingAnchor),
            likeCount.trailingAnchor.constraint(equalTo: footerLayout.trailingAnchor),
            likeCount.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        
        // sil
//        let readMore: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("More", for: .normal)
//
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.backgroundColor = UIColor.blue
//            return button
//        }()
//
//        statusTextView.addSubview(readMore)
//        readMore.backgroundColor = UIColor.red
//        let statusLayout = self.statusTextView.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            readMore.bottomAnchor.constraint(equalTo: statusLayout.bottomAnchor),
//            readMore.trailingAnchor.constraint(equalTo: footerLayout.trailingAnchor),
//            readMore.heightAnchor.constraint(equalToConstant: 10)
//            ])
        
        // sil
    }
    
}

extension FeedViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        print("shouldInteractWith")
        // check for our fake URL scheme hash:helloWorld
        switch URL.scheme {
        case SchemeType.hash.rawValue :
            print("Hash basildi")
        case SchemeType.mention.rawValue :
            print("mention basildi")
        default:
            print("just a regular url")
        }

        return true
    }
}

