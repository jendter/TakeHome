//
//  CategoryNavigationController.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-13.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit

class CategoryNavigationController: UINavigationController {
    func config() {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Env.boldFont, size: 18.0)!]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        config()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        config()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
