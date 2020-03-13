//
//  AdListViewController.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-12.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit
import Moya

enum AdListViewEvent {
    case refresh
}

protocol AdListViewDelegate: class {
    func adListViewController(_ viewController: AdListViewController, event: AdListViewEvent)
}

class AdListViewModel: NSObject {
    // Data
    let category: Category
    let imageProvider: ImageProvider
    var ads = [Ad]() {
        didSet {
            let newValue = ads
            DispatchQueue.main.async {
                self.view?.newAdData(previous: oldValue, new: newValue)
            }
        }
    }
    
    // View
    weak var view: AdListViewController?
    
    // Init
    init(category: Category, imageProvider: ImageProvider) {
        self.category = category
        self.imageProvider = imageProvider
    }

    // Binding
    func bind(to view: AdListViewController) {
        self.view = view
        view.tableView.dataSource = self
        view.newAdData(previous: [], new: ads)
    }
}

extension AdListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdListViewController.cellReuseIdentifer, for: indexPath) as! AdCell
        let ad = ads[indexPath.row]
        cell.viewModel = .init(ad: ad, imageProvider: imageProvider)
        return cell
    }
}

class AdListViewController: UIViewController {
    static let cellReuseIdentifer = "AdCell"
    
    weak var delegate: AdListViewDelegate?
    
    let viewModel: AdListViewModel
    
    let tableView = UITableView()
    var isReloading = false
    
    init(viewModel: AdListViewModel, delegate: AdListViewDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.category.name
        
        // View Setup
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(AdCell.self, forCellReuseIdentifier: AdListViewController.cellReuseIdentifer)
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
            tableView.showRefreshControl(true, animated: true)
        }
    }
    
    @objc func refreshData() {
        isReloading = true
        delegate?.adListViewController(self, event: .refresh)
    }
    
    func refreshComplete() {
        isReloading = false
        tableView.showRefreshControl(false)
    }
    
    func newAdData(previous: [Ad], new: [Ad]) {
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
