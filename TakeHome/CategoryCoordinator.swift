//
//  AppCoordinator.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-11.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit
import Moya
import Mapper
import Moya_ModelMapper

class CategoryCoordinator {
    let apiProvider: MoyaProvider<APICall>
    
    init(apiProvider: MoyaProvider<APICall> = .standardProvider(timeout: 10)) {
        self.apiProvider = apiProvider
    }
    
    lazy var rootViewController: UINavigationController = {
        let categoryViewController = CategoryViewController(delegate: self)
        categoryViewController.refreshData()
        return CategoryNavigationController(rootViewController: categoryViewController)
    }()
    
    func activate(window: UIWindow?) {
        //let categoryViewContoller = CategoryViewController(delegate: self)
        //let rootViewController = UINavigationController(rootViewController: categoryViewContoller)
        //self.window = window
        window?.rootViewController = rootViewController
    }
    
    // or put it as a Extension somewhere (showStandardError -or- showStandardMessage ?)  , completion: (()->())? = nil
    func showServerError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}

extension CategoryCoordinator: CategoryViewDelegate {
    func categoryViewController(_ viewController: CategoryViewController, event: CategoryViewEvent) {
        switch event {
        case .refresh:
            apiProvider.request(.categories) { [weak viewController, weak self] (result) in
                DispatchQueue.main.async {
                    viewController?.refreshComplete()
                }
                
                switch result {
                case .success(let response):
                    do {
                        let categories = try response.map(to: [Category].self)
                        viewController?.viewModel.categories = categories
                    } catch let error {
                        // In a user facing app we would probably log this and present a more helpful message to the user.
                        self?.showServerError(title: "Mapping Error", message: error.localizedDescription)
                    }
                case .failure(let error):
                    self?.showServerError(title: "Error", message: error.networkLocalizedDescription)
                }
            }
            
        case .selectedCategory(let category):
            let adList = AdListViewController(viewModel: .init(category: category), delegate: self)
            adList.refreshData()
            rootViewController.pushViewController(adList, animated: true)
        }
    }
}

extension CategoryCoordinator: AdListViewDelegate {
    func adListViewController(_ viewController: AdListViewController, event: AdListViewEvent) {
        switch event {
        case .refresh:
            apiProvider.request(.ads(categoryId: viewController.viewModel.category.id)) { [weak viewController, weak self] (result) in
                DispatchQueue.main.async {
                    viewController?.refreshComplete()
                }
                
                switch result {
                case .success(let response):
                    do {
                        let ads = try response.map(to: [Ad].self)
                        viewController?.viewModel.ads = ads
                    } catch let error {
                        self?.showServerError(title: "Mapping Error", message: error.localizedDescription)
                    }
                case .failure(let error):
                    self?.showServerError(title: "Error", message: error.networkLocalizedDescription)
                }
            }
        }
    }
}


