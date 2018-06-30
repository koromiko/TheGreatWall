//
//  ProfileCell.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import UIKit
import SwiftIconFont

class MemberCell: UITableViewCell, CellConfiguraable {
    lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(btn)

        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4

        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

        btn.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: 14.0)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)

        return btn
    }()

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(indicator)
        return indicator
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)

        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 12)
        label.textColor = UIColor.brown
        return label
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.5
        return imageView
    }()

    var viewModel: MemberCellViewModel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialView()
        setupConstraint()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialView()
        setupConstraint()
    }
    
    @objc func btnPressed() {
        viewModel?.addBtnPressed?()
    }

    func setupInitialView() {
        actionBtn.setTitle("Add", for: .normal)
        self.selectionStyle = .none
    }

    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? MemberCellViewModel else { return }
        self.viewModel = viewModel
        profileImageView.image = viewModel.avatar.image
        nameLabel.text = viewModel.name

        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }

        viewModel.isAddBtnHidden.addObserver { [weak self] (isHidden) in
            self?.actionBtn.isHidden = isHidden
        }

        viewModel.isAddBtnEnabled.addObserver { [weak self] (isEnabled) in
            self?.actionBtn.isEnabled = isEnabled
        }

        viewModel.addBtnTitle.addObserver { [weak self] (title) in
            self?.actionBtn.setTitle(title, for: .normal)
        }

        viewModel.avatar.completeDownload = { [weak self] image in
            self?.profileImageView.image = image
        }
        viewModel.avatar.startDownload()
 
        setNeedsLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.addBtnTitle.removeObserver()
        viewModel?.isLoading.removeObserver()
        viewModel?.isAddBtnHidden.removeObserver()
        viewModel?.isAddBtnEnabled.removeObserver()
        viewModel?.avatar.completeDownload = nil
    }

    func setupConstraint() {
        profileImageView.accessibilityIdentifier = "profileImageView"
        nameLabel.accessibilityIdentifier = "nameLabel"
        actionBtn.accessibilityIdentifier = "actionButton"
        contentView.accessibilityIdentifier = "profileContentView"

        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 25),
            profileImageView.heightAnchor.constraint(equalToConstant: 25),

            nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0),

            actionBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            actionBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            actionBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            loadingIndicator.centerXAnchor.constraint(equalTo: actionBtn.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: actionBtn.centerYAnchor)
            ])
        
    }

}
