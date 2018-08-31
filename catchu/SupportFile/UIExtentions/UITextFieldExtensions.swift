//
//  UITextFieldExtensions.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit


//func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
//    for (k, v) in right {
//        left.updateValue(v, forKey: k)
//    }
//}

extension UITextView {
    
    public func resolveHashTags(possibleUserDisplayNames:[String]? = nil) {
        
        let schemeMap = [
            "#": SchemeType.hash,
            "@": SchemeType.mention
        ]
        
        // Separate the string into individual words.
        // Whitespace is used as the word boundary.
        // You might see word boundaries at special characters, like before a period.
        // But we need to be careful to retain the # or @ characters.
        let words = self.text.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        let attributedString = attributedText.mutableCopy() as! NSMutableAttributedString
        
        // keep track of where we are as we interate through the string.
        // otherwise, a string like "#test #test" will only highlight the first one.
        var bookmark = text.startIndex
        
        // Iterate over each word.
        // So far each word will look like:
        // - I
        // - visited
        // - #123abc.go!
        // The last word is a hashtag of #123abc
        // Use the following hashtag rules:
        // - Include the hashtag # in the URL
        // - Only include alphanumeric characters.  Special chars and anything after are chopped off.
        // - Hashtags can start with numbers.  But the whole thing can't be a number (#123abc is ok, #123 is not)
        for word in words {
            
            var scheme:SchemeType? = nil
            
            if word.hasPrefix("#") {
                scheme = schemeMap["#"]
            } else if word.hasPrefix("@") {
                scheme = schemeMap["@"]
            }
            
            // Drop the # or @
            var wordWithTagRemoved = String(word.dropFirst())
            
            // Drop any trailing punctuation
            wordWithTagRemoved.dropTrailingNonAlphaNumericCharacters()
            
            // Make sure we still have a valid word (i.e. not just '#' or '@' by itself, not #100)
            guard let schemeMatch = scheme, Int(wordWithTagRemoved) == nil && !wordWithTagRemoved.isEmpty
                else { continue }
            
            let remainingRange = Range(bookmark..<text.endIndex)
            
            // URL syntax is http://123abc
            
            // Replace custom scheme with something like hash://123abc
            // URLs actually don't need the forward slashes, so it becomes hash:123abc
            // Custom scheme for @mentions looks like mention:123abc
            // As with any URL, the string will have a blue color and is clickable
            
            
            if let matchRange = text.range(of: word, options: .literal, range: remainingRange),
                let escapedString = wordWithTagRemoved.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                // MARK: swift 3 and old version
//                attributedString.addAttribute(NSLinkAttributeName, value: "\(schemeMatch):\(escapedString)", range: text.NSRangeFromRange(range: matchRange))
                
                let linkAttributes: [NSAttributedStringKey: Any] = [
                    .link: NSURL(string: "\(schemeMatch):\(escapedString)")!,
                    .foregroundColor: UIColor.blue
                ]
                attributedString.addAttributes(linkAttributes, range: text.NSRangeFromRange(range: matchRange)!)
            }
            
            // just cycled through a word. Move the bookmark forward by the length of the word plus a space
            bookmark = text.index(bookmark, offsetBy: word.count)
        }
        
        self.attributedText = attributedString
    }
}

extension String {
    func NSRangeFromRange(range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    mutating func dropTrailingNonAlphaNumericCharacters() {
        let nonAlphaNumericCharacters = NSCharacterSet.alphanumerics.inverted
        let characterArray = components(separatedBy: nonAlphaNumericCharacters)
        if let first = characterArray.first {
            self = first
        }
    }
}

