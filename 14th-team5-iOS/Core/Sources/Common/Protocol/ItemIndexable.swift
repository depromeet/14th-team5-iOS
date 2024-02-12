//
//  ItemIndexable.swift
//  Core
//
//  Created by 마경미 on 20.01.24.
//

import UIKit
import RxDataSources

public protocol ItemIndexable {
  associatedtype Item
  
  subscript(indexPath: IndexPath) -> Item { get set }
}

extension ItemIndexable {
  public func item(at index: IndexPath) throws -> Item { self[index] }
  public func items(at indexes: [IndexPath]) throws -> [Item] { try indexes.map(self.item(at:)) }
}

extension TableViewSectionedDataSource: ItemIndexable { }
extension CollectionViewSectionedDataSource: ItemIndexable { }
