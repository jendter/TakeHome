//
//  UITableView+Refresh.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-13.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit

extension UITableView {
    /// Show/hide refresh control. Compatible with UINavigationController.
    func showRefreshControl(_ visible: Bool, animated: Bool = true) {
        guard let refreshControl = refreshControl else { return }
        
        switch visible {
        case true:
            refreshControl.beginRefreshing()
            setContentOffset(.init(x: 0, y: contentOffset.y-refreshControl.frame.size.height), animated: animated)
        case false:
            refreshControl.endRefreshing()
        }
    }
}
