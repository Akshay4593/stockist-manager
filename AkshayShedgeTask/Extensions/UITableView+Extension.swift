//
//  UITableView+Extension.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import UIKit

extension UITableView {
    
    // Register a UITableViewCell or UITableViewHeaderFooterView
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    
    // Dequeue a reusable UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellType)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error: Could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
