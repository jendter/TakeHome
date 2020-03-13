//
//  CategoryCell.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-11.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit
import SnapKit

class CategoryCellViewModel {
    // Data
    let category: AdCategory
    init(category: AdCategory) {
        self.category = category
    }
    
    // View
    weak var view: CategoryCell?
    
    // Binding
    func bind(to view: CategoryCell) {
        self.view = view
        view.nameLabel.text = category.name
        view.countView.countLabel.text = "\(category.count)"
    }
}

class CategoryCell: UITableViewCell {
    var viewModel: CategoryCellViewModel? {
        didSet {
            viewModel?.bind(to: self)
        }
    }
    
    let nameLabel = UILabel()
    let countView = CategoryCountView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(countView)
        contentView.addSubview(nameLabel)
        
        nameLabel.backgroundColor = .clear
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: Env.standardFont, size: 17)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.centerY.equalToSuperview()
        }
        
        countView.translatesAutoresizingMaskIntoConstraints = false
        countView.countLabel.font = UIFont(name: Env.boldFont, size: 17)
        countView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.right.equalTo(self.snp.rightMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(countView.snp.height)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CategoryCountView: UIView {
    let countLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemTeal
        
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
