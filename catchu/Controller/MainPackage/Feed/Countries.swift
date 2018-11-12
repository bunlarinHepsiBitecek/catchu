//
//  Countries.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/19/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

public class Countries {
    
    public private(set) static var countries: [Country] = {
        return Countries.countriesFromJson()
    }()
    
    
    // Populates the metadata from the included json file resource
    
    /// sorted array with data
    ///
    /// - Returns: sorted array with all information phone
    private static func countriesFromJson() -> [Country] {
        var countries = [Country]()
        let frameworkBundle = Bundle(for: self)
        guard let jsonPath = frameworkBundle.path(forResource: Constants.Bundle.Path.Country, ofType: Constants.Bundle.FileType.Json), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return countries
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                
                for jsonObject in jsonObjects {
                    
                    guard let countryObj = jsonObject as? NSDictionary else {
                        return countries
                    }
                    
                    guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let isMain = countryObj["is_main"] as? Bool  else {
                        return countries
                    }
                    
                    let country = Country(countryCode: code, phoneExtension: phoneCode, isMain: isMain)
                    countries.append(country)
                }
                
            }
        } catch {
            return countries
        }
        return countries
    }
    
    public class func countryFromPhoneExtension(phoneExtension: String) -> Country {
        let phoneExtension = (phoneExtension as NSString).replacingOccurrences(of: "+", with: "")
        for country in countries {
            if country.isMain && phoneExtension == country.phoneExtension {
                return country
            }
        }
        return Country.emptyCountry
    }
    
    public class func countryFromCountryCode(countryCode: String) -> Country {
        for country in countries {
            if countryCode == country.countryCode {
                return country
            }
        }
        return Country.emptyCountry
    }
    
    public class func countriesFromCountryCodes(countryCodes: [String]) -> [Country] {
        return countryCodes.map { Countries.countryFromCountryCode(countryCode: $0) }
    }
    
}
