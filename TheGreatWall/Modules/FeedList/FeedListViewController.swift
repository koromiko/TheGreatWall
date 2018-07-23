//
//  FeedListViewController.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController {

    var viewModel: FeedListViewModel {
        return controller.viewModel
    }

    lazy var controller: FeedListController = {
        return FeedListController()
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension

        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.edgeConstraints(top: 80, left: 0, bottom: 0, right: 0))

        tableView.register(MemberCell.self, forCellReuseIdentifier: MemberCell.cellIdentifier())
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.cellIdentifier())
        return tableView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ])
        label.textColor = UIColor.black
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 24)
        return label
    }()

    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        controller.start()
    }

    func initView() {
        view.backgroundColor = .white
    }

    func initBinding() {
        viewModel.rowViewModels.valueChanged = { [weak self] (_) in
            self?.tableView.reloadData()
        }

        self.titleLabel.text = viewModel.title.value
        viewModel.title.valueChanged = { [weak self] (title) in
            self?.titleLabel.text = title
        }

        self.tableView.isHidden = viewModel.isTableViewHidden.value
        viewModel.isTableViewHidden.valueChanged = { [weak self] (isHidden) in
            self?.tableView.isHidden = isHidden
        }

        setLoading(isLoading: viewModel.isLoading.value)
        viewModel.isLoading.valueChanged = { [weak self] (isLoading) in
            self?.setLoading(isLoading: isLoading)
        }
    }

    private func setLoading(isLoading: Bool) {
        if isLoading {
            self.loadingIdicator.startAnimating()
        } else {
            self.loadingIdicator.stopAnimating()
        }
    }

}

extension FeedListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let rowViewModel = viewModel.rowViewModels.value[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: controller.cellIdentifier(for: rowViewModel), for: indexPath)

        if let cell = cell as? CellConfiguraable {
            cell.setup(viewModel: rowViewModel)
        }

        cell.layoutIfNeeded()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let rowViewModel = viewModel.rowViewModels.value[indexPath.row] as? ViewModelPressible {
            rowViewModel.cellPressed?()
        }
    }
}
