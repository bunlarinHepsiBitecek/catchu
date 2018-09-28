//
//  DifferenceCalculator.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stan Ostrovskiy on 9/20/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation

class CellChanges {
    var inserts = [IndexPath]()
    var deletes = [IndexPath]()
    var reloads = [IndexPath]()
    
    init(inserts: [IndexPath] = [], deletes: [IndexPath] = [], reloads: [IndexPath] = []) {
        self.inserts = inserts
        self.deletes = deletes
        self.reloads = reloads
    }
}

struct ReloadableCell<N:Equatable>: Equatable {
    var key: String
    var value: [N]
    var index: Int
    
    static func ==(lhs: ReloadableCell, rhs: ReloadableCell) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}

struct ReloadableCellData<N: Equatable> {
    var items = [ReloadableCell<N>]()
    
    subscript(key: String) -> ReloadableCell<N>? {
        get {
            return items.filter { $0.key == key }.first
        }
    }
    
    subscript(index: Int) -> ReloadableCell<N>? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
}

class DifferenceCalculator {
    static func calculate<N>(oldItems: [ReloadableCell<N>], newItems: [ReloadableCell<N>]) -> CellChanges {
        
        let cellChanges = CellChanges()
        
        let oldCellIData = ReloadableCellData(items: oldItems)
        let newCellData = ReloadableCellData(items: newItems)
        
        let uniqueCellKeys = (oldCellIData.items + newCellData.items)
            .map { $0.key }
            .filterDuplicates()
        
        for cellKey in uniqueCellKeys {
            let oldCellItem = oldCellIData[cellKey]
            let newCellItem = newCellData[cellKey]
            if let oldCellItem = oldCellItem, let newCelItem = newCellItem {
                if oldCellItem != newCelItem {
                    cellChanges.reloads.append(IndexPath(row: oldCellItem.index, section: 0))
                }
            } else if let oldCellItem = oldCellItem {
                cellChanges.deletes.append(IndexPath(row: oldCellItem.index, section: 0))
            } else if let newCellItem = newCellItem {
                cellChanges.inserts.append(IndexPath(row: newCellItem.index, section: 0))
            }
        }
        
        return cellChanges
    }
}

extension Array where Element: Hashable {
    
    /// Remove duplicates from the array, preserving the items order
    func filterDuplicates() -> Array<Element> {
        var set = Set<Element>()
        var filteredArray = Array<Element>()
        for item in self {
            if set.insert(item).inserted {
                filteredArray.append(item)
            }
        }
        return filteredArray
    }
}
