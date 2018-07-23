//
//  FeedListController.swift
//  TheGreatWall
//
//  Created by Neo on 30/06/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation

class FeedListController {
    let socialService: SocialService
    let viewModel: FeedListViewModel

    init(viewModel: FeedListViewModel = FeedListViewModel(), socialService: SocialService = SocialService()) {
        self.viewModel = viewModel
        self.socialService = socialService
    }

    func start() {
        self.viewModel.isLoading.value = true
        self.viewModel.isTableViewHidden.value = true
        self.viewModel.title.value = "Loading..."
        socialService.fetchFeeds { [weak self] (feeds) in
            self?.viewModel.title.value = "Your Feeds"
            self?.viewModel.isLoading.value = false
            self?.viewModel.isTableViewHidden.value = false
            self?.buildViewModels(feeds: feeds)
        }
    }

    // MARK: - Data source

    /// Arrange the sections/row view model and caregorize by date
    func buildViewModels(feeds: [Feed]) {
        var rowViewModels = [RowViewModel]()
        for feed in feeds {
            if let memberFeed = feed as? Member {
                let avatarImage = AsyncImage(url: memberFeed.avatarURL, placeholderImage: #imageLiteral(resourceName: "avatarPlaceholder"))
                let profileVM: MemberCellViewModel = MemberCellViewModel(name: memberFeed.name,
                                                                         avatar: avatarImage)
                profileVM.addBtnPressed = handleAddContact(memberFeed.userID, viewModel: profileVM)

                rowViewModels.append(profileVM)
            } else if let photoFeed = feed as? Photo {
                let photoCellViewModel = PhotoCellViewModel(title: photoFeed.captial,
                                                            desc: photoFeed.description,
                                                            image: AsyncImage(url: photoFeed.imageURL))
                photoCellViewModel.cellPressed = {
                    print("Open a photo viewer!")
                }

                rowViewModels.append(photoCellViewModel)
            }
        }

        self.viewModel.rowViewModels.value = rowViewModels
    }

    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is PhotoCellViewModel:
            return PhotoCell.cellIdentifier()
        case is MemberCellViewModel:
            return MemberCell.cellIdentifier()
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }

    // MARK: - User interaction
    func handleAddContact(_ userID: String, viewModel : MemberCellViewModel) -> (() -> Void) {
        return { [weak self, weak viewModel] in
            viewModel?.isLoading.value = true
            viewModel?.isAddBtnHidden.value = true
            self?.socialService.follow(userID: userID) { (success) in
                if success {
                    viewModel?.isAddBtnEnabled.value = false
                    viewModel?.addBtnTitle.value = String.fontAwesomeIcon("check")!
                }
                viewModel?.isAddBtnHidden.value = false
                viewModel?.isLoading.value = false
            }

        }
    }

}
