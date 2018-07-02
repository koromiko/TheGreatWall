//
//  PhotoCell.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import UIKit
class PhotoCell: UITableViewCell, CellConfiguraable {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)

        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "AmericanTypewriter", size: 14)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)

        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()

    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialView()
        setupConstraints()
    }

    var viewModel: PhotoCellViewModel?

    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? PhotoCellViewModel else { return }
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.desc
        self.coverImageView.image = viewModel.image.image

        viewModel.image.startDownload()
        viewModel.image.completeDownload = { [weak self] image in
            self?.coverImageView.image = image
        }

        setNeedsLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.image.completeDownload = nil
        viewModel?.cellPressed = nil
    }

    private func setupInitialView() {
        self.selectionStyle = .none
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            coverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).withPriority(priority: .defaultLow),
            coverImageView.widthAnchor.constraint(equalToConstant: 120),
            coverImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)

            ])

        titleLabel.accessibilityIdentifier = "titeLabel"
        coverImageView.accessibilityIdentifier = "coverImageView"
        descriptionLabel.accessibilityIdentifier = "descriptionLabel"
        contentView.accessibilityIdentifier = "galleryContentView"
        
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    }

}
