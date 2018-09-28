//
//  CommentAccessoryView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/19/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

protocol CommentAccessoryViewDelegate: class {
    func send(_ sender: UIButton)
//    func textViewDidChange(_ textView: UITextView)
}

class CommentAccessoryView: BaseView {
    
    weak var delegate: CommentAccessoryViewDelegate!
    
    private let padding = CGFloat(8)
    
    lazy var messageTextView: DynamicTextView = {
        let textView = DynamicTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.autocorrectionType = .no
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = LocalizedConstants.Feed.AddComment
        textView.maxHeight = 80
        textView.layer.cornerRadius = 10

        return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedConstants.Feed.Send, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
        
        // MARK: Button size dynamic content
//        button.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
//        button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
//         button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    override func setupView() {
        messageTextView.delegateDynamic = self
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(messageTextView)
        addSubview(sendButton)
        
        let safeLayout = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: padding),
            messageTextView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -padding),
            messageTextView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: padding),
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -padding),
            
            sendButton.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -padding),
            sendButton.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -padding),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
            ])
        
    }
    
    // MARK: autoresizingMask ile birlikte kullanildi. Eger
    // this is needed so that the inputAccesoryView is properly sized from the auto layout constraints
    // actual value is not important
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
}

// MARK: textView
extension CommentAccessoryView: DynamicTextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
//        guard let delegate = self.delegate else { return }
//        delegate.textViewDidChange(textView)
    }
    
}


// MARK: send button
extension CommentAccessoryView {
    
    // when click send button
    @objc func send(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.send(sender)
    }
}
