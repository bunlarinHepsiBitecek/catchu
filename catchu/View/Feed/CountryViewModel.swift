//
//  CountryViewModel.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/17/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

fileprivate extension Selector {
    static let countryName = #selector(getter: Country.name)
}

class CountryViewModel: BaseViewModel {
    
    public var unfilteredCountries = [[Country]]() {
        didSet {
            filteredCountries.value = unfilteredCountries
        }
    }
    public var filteredCountries = Dynamic([[Country]]())
    
    weak var searchController: UISearchController!
    
    var selectedCountry: Country?
    var selectedIndex: Dynamic<IndexPath>?
    
    func loadData(selectedCountry: Country?) {
        self.selectedCountry = selectedCountry
        
        unfilteredCountries = partionedArray(array: Countries.countries, usingSelector: .countryName)
        
        selectedIndex = Dynamic(findSelectedIndex())
    }
    
    func partionedArray<T: AnyObject>(array: [T], usingSelector selector: Selector) -> [[T]] {
        let collation = UILocalizedIndexedCollation.current()
        let numberOfSectionTitles = collation.sectionTitles.count
        
        var unsortedSections: [[T]] = Array(repeating: [], count: numberOfSectionTitles)
        for object in array {
            let sectionIndex = collation.section(for: object, collationStringSelector: selector)
            unsortedSections[sectionIndex].append(object)
        }
        
        var sortedSections: [[T]] = []
        for section in unsortedSections {
            let sortedSection = collation.sortedArray(from: section, collationStringSelector: selector) as! [T]
            sortedSections.append(sortedSection)
        }
        return sortedSections
    }
    
    private func findSelectedIndex() -> IndexPath {
        if let selectedCountry = selectedCountry {
            for (index, countries) in unfilteredCountries.enumerated() {
                if let countryIndex = countries.index(of: selectedCountry) {
                    return IndexPath(row: countryIndex, section: index)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
}

extension CountryViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.value.count
    }
    
    // data method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.value[section].count
    }
    
    // data method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let country = filteredCountries.value[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CountryViewCell.identifier, for: indexPath) as? CountryViewCell {
            
            cell.configure(country: country)

            cell.accessoryType = .none
            if let selectedCountry = selectedCountry, country == selectedCountry {
                cell.accessoryType = .checkmark
            }

            return cell
        }
        
        return UITableViewCell()
        
    }
    
    // data method
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredCountries.value[section].isEmpty ? nil : UILocalizedIndexedCollation.current().sectionTitles[section]
        
    }
    
    // data method
    /// when click index then work
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    // MARK: when click SearchBar then work
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : UILocalizedIndexedCollation.current().sectionTitles
    }
    
}

// SearchController
extension CountryViewModel: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    //    public func willPresentSearchController(_ searchController: UISearchController) {
    //        tableView.reloadSectionIndexTitles()
    //    }
    //
    //    public func willDismissSearchController(_ searchController: UISearchController) {
    //        tableView.reloadSectionIndexTitles()
    //    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        searchForText(text: searchString)
    }
    
    private func searchForText(text: String) {
        if text.isEmpty {
            filteredCountries.value = unfilteredCountries
        } else {
            let allCountries: [Country] = Countries.countries.filter { $0.name.range(of: text) != nil }
            filteredCountries.value = partionedArray(array: allCountries, usingSelector: .countryName)
        }
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filteredCountries.value = unfilteredCountries
    }
    
}
