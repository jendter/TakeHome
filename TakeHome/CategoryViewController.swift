//
//  CategoryViewController.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-11.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit
import SnapKit

enum CategoryViewEvent {
    case refresh
    case selectedCategory(Category)
}

protocol CategoryViewDelegate: class {
    func categoryViewController(_ viewController: CategoryViewController, event: CategoryViewEvent)
}

class CategoryViewModel: NSObject {
    // Data
    var categories = [Category]() {
        didSet {
            let newValue = categories
            DispatchQueue.main.async {
                self.view?.newCategoryData(previous: oldValue, new: newValue)
            }
        }
    }
    
    // View
    weak var view: CategoryViewController?
    
    // Binding
    func bind(to view: CategoryViewController) {
        self.view = view
        view.tableView.dataSource = self
        view.newCategoryData(previous: [], new: categories)
    }
}

extension CategoryViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewController.cellReuseIdentifer, for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
        cell.viewModel = .init(category: category)
        return cell
    }
}

class CategoryViewController: UIViewController {
    static let cellReuseIdentifer = "CategoryCell"
    
    let viewModel: CategoryViewModel
    weak var delegate: CategoryViewDelegate?
    
    let tableView = UITableView()
    var isReloading = false
    
    init(viewModel: CategoryViewModel = .init(), delegate: CategoryViewDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
                
        // View Setup
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryViewController.cellReuseIdentifer)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // ViewModel Binding
        viewModel.bind(to: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If the data is loading, show the refresh control.
        if isReloading {
            tableView.showRefreshControl(true, animated: false)
        }
    }
    
    @objc func refreshData() {
        isReloading = true
        delegate?.categoryViewController(self, event: .refresh)
    }
    
    func refreshComplete() {
        isReloading = false
        tableView.showRefreshControl(false)
    }
    
    func newCategoryData(previous: [Category], new: [Category]) {
        // we could do an animated update if needed with both the previous and new data.
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = viewModel.categories[indexPath.row]
        delegate?.categoryViewController(self, event: .selectedCategory(category))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}
