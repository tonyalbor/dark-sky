//
//  TableViewExtensions.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/11/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit

protocol Nib {
    static var nib: UINib { get }
}

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol ReusableCell: Nib, ReuseIdentifiable {}

extension ReusableCell where Self: UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_: Cell.Type = Cell.self) where Cell: ReusableCell {
        register(Cell.nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(_: Cell.Type = Cell.self) -> Cell where Cell: ReusableCell {
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as! Cell
    }
}
