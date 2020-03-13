//
//  AdCell.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-13.
//  Copyright © 2020 JRE. All rights reserved.
//

import UIKit
import Moya

//protocol AdCellDelegate: class {
//    
//}

class AdCellViewModel {
    // Data
    let ad: Ad
    let imageProvider: ImageProvider
    init(ad: Ad, imageProvider: ImageProvider) {
        self.ad = ad
        self.imageProvider = imageProvider
    }
    
    // Image Request
    var imageRequest: Cancellable?
    
    // View
    weak var view: AdCell?
    
    // Binding
    func bind(to view: AdCell) {
        self.view = view
        
        // Set text labels
        view.titleLabel.text = ad.title
        view.priceLabel.text = ad.price
        
        // Load ad image
        imageRequest?.cancel()
        view.imageView?.image = AdCell.placeholderProductImage
        if let imageUrl = ad.imageUrl {
            imageRequest = imageProvider.request(.retrieve(url: imageUrl)) { [weak view] (result) in
                switch result {
                case .success(let response):
                    // Set image with small crossfade animation
                    DispatchQueue.main.async {
                        guard let imageView = view?.productImageView else { return }
                        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                            view?.productImageView.image = UIImage(data: response.data)
                        }, completion: nil)
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}

class AdCell: UITableViewCell {
    var viewModel: AdCellViewModel? {
        didSet {
            viewModel?.bind(to: self)
        }
    }
    
    static let placeholderProductImage: UIImage? = nil
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.masksToBounds = true
        productImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.leftMargin)
            make.top.bottom.equalToSuperview().inset(6)
            make.width.equalTo(productImageView.snp.height)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Env.standardFont, size: 15)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView)
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.right.equalTo(contentView.snp.rightMargin)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.font = UIFont(name: Env.boldFont, size: 17)
        priceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        priceLabel.setContentHuggingPriority(.required, for: .vertical)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(titleLabel)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalTo(productImageView)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
