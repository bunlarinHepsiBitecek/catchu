//
//  DynamicTextView.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 9/19/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

protocol DynamicTextViewDelegate: class {
    func textViewDidChange(_ textView: UITextView)
}

class DynamicTextView: UITextView {
    
    weak var delegateDynamic: DynamicTextViewDelegate!
    
    // limit the height of expansion per intrinsicContentSize
    var maxHeight: CGFloat = 0.0
    
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedConstants.Feed.AddComment
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        isScrollEnabled = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        placeholderLabel.font = font
        
        self.delegate = self
        
        addSubview(placeholderLabel)
        
        let safeLayout = self.safeAreaLayoutGuide
        let leftPadding = self.textContainer.lineFragmentPadding // cursor start +5 leading
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: leftPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
//            invalidateIntrinsicContentSize()
        }
    }
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    
//    override var contentInset: UIEdgeInsets {
//        didSet {
//            placeholderLabel.contentInset = contentInset
//        }
//    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        if size.height == UIViewNoIntrinsicMetric {
            // force layout
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }

        if maxHeight > 0.0 && size.height > maxHeight {
            size.height = maxHeight

            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }

        return size
    }
}


extension DynamicTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
        placeholderLabel.isHidden = !text.isEmpty
        
        guard let delegateDynamic = self.delegateDynamic else { return }
        delegateDynamic.textViewDidChange(textView)
    }
}
