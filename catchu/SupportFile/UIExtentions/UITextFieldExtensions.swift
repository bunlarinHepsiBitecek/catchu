//
//  UITextFieldExtensions.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/30/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit


extension UITextView {
    
    func readMoreCheck() {
        print("readMoreArrange orginalText: \(self.text ?? "")")
        
        guard !self.text.isEmpty else {
            return
        }
        guard let textLength = self.text?.count else { return }
        let maxCharacterCount = Constants.Feed.ReadMoreCaracterCount
        
        if (textLength > maxCharacterCount) {
            let readMorePrefix = self.attributedText?.mutableCopy() as! NSMutableAttributedString
            readMorePrefix.mutableString.setString("... ")
            
            let defaultReadMoreText = LocalizedConstants.Feed.More
            
            let linkAttributes: [NSAttributedStringKey: Any] = [
                .link: "\(defaultReadMoreText):",
                .underlineColor: Constants.Feed.ReadMoreUnderlineColor,
                .font: self.font ?? Constants.Feed.ReadMoreFont,
                .foregroundColor: Constants.Feed.ReadMoreColor
            ]
            
            let readMoreAttributedString = NSMutableAttributedString(string: defaultReadMoreText, attributes: linkAttributes)
            
            let location = maxCharacterCount
            let length = textLength - maxCharacterCount
            let range = NSMakeRange(location, length)
            
            // set space from maksimum character count to remaining
            let trimmedForReadMoreText = (self.text! as NSString).replacingCharacters(in: range, with: "")
            
            var fullAttributedString = self.attributedText?.mutableCopy() as! NSMutableAttributedString
            fullAttributedString.mutableString.setString(trimmedForReadMoreText)
            
            fullAttributedString = resolveHasTagsAfterReadMore(attributedString: fullAttributedString, text: trimmedForReadMoreText)
            
            fullAttributedString.append(readMorePrefix)
            fullAttributedString.append(readMoreAttributedString)
            
            self.attributedText = fullAttributedString
        }
    }
    
    private func resolveHasTagsAfterReadMore(attributedString: NSMutableAttributedString, text: String) -> NSMutableAttributedString {
        
        let schemeMap = [
            "#": SchemeType.hash,
            "@": SchemeType.mention
        ]
        
        // Separate the string into individual words.
        // Whitespace is used as the word boundary.
        // You might see word boundaries at special characters, like before a period.
        // But we need to be careful to retain the # or @ characters.
        let words = text.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        
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
            
            // MARK: xcode 9.3
//            let remainingRange = Range(bookmark..<text.endIndex)
            let remainingRange = bookmark..<text.endIndex
            
            // URL syntax is http://123abc
            
            // Replace custom scheme with something like hash://123abc
            // URLs actually don't need the forward slashes, so it becomes hash:123abc
            // Custom scheme for @mentions looks like mention:123abc
            // As with any URL, the string will have a blue color and is clickable
            
            
            if let matchRange = text.range(of: word, options: .literal, range: remainingRange),
                let escapedString = wordWithTagRemoved.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                
                let linkAttributes: [NSAttributedStringKey: Any] = [
                    .link: NSURL(string: "\(schemeMatch):\(escapedString)")!,
                    .foregroundColor: UIColor.blue
                ]
                attributedString.addAttributes(linkAttributes, range: text.NSRangeFromRange(range: matchRange)!)
            }
            
            // just cycled through a word. Move the bookmark forward by the length of the word plus a space
            bookmark = text.index(bookmark, offsetBy: word.count)
        }
        
        return attributedString
    }
    
    
    
    public func resolveHashTags() {
        
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

            // MARK: xcode 9.3
//            let remainingRange = Range(bookmark..<text.endIndex)
            let remainingRange = bookmark..<text.endIndex
            
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
    
    func timeAgoSinceDate() -> String {
        let timeAgo = "Just Now"
        if self.isEmpty {
            return timeAgo
        }
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime,
                                       .withFractionalSeconds]
        guard let date = dateFormatter.date(from: self) else {return timeAgo}
        
        return date.timeAgoSinceDate(date)
    }
}


/*
 
 let dateString = "2018-09-14T14:19:18.304000000Z"
 let dateFormatter = ISO8601DateFormatter()
 dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds ]
 let dateSon = dateFormatter.date(from: dateString)
 
 if let dateSon = dateSon {
    dateSon.timeAgoSinceDate(dateSon)
 }
 
 */
extension Date {
    
    func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}
