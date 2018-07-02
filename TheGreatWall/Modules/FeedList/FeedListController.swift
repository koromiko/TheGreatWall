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
        var sectionTable = [String: [RowViewModel]]()
        var vm: RowViewModel?
        for feed in feeds {
            let groupingKey = sectionGroupingKey(feed)
            if let memberFeed = feed as? Member {
                let avatarImage = AsyncImage(url: memberFeed.avatarURL, placeholderImage: #imageLiteral(resourceName: "avatarPlaceholder"))
                let profileVM: MemberCellViewModel = MemberCellViewModel(name: memberFeed.name,
                                                                         avatar: avatarImage)
                profileVM.addBtnPressed = handleAddContact(memberFeed.userID, viewModel: profileVM)

                vm = profileVM
            } else if let photoFeed = feed as? Photo {
                let photoCellViewModel = PhotoCellViewModel(title: photoFeed.captial,
                                                            desc: photoFeed.description,
                                                            image: AsyncImage(url: photoFeed.imageURL))
                photoCellViewModel.cellPressed = {
                    print("Open a photo viewer!")
                }
                vm = photoCellViewModel
            }

            if let vm = vm {
                if var rows = sectionTable[groupingKey] {
                    rows.append(vm)
                    sectionTable[groupingKey] = rows
                } else {
                    sectionTable[groupingKey] = [vm]
                }
            }
        }

        self.viewModel.sectionViewModels.value = converToSectionViewModel(sectionTable)
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

    /// Convert the date-hashed row viewmodels into array-based section viewmodels
    private func converToSectionViewModel(_ sectionTable: [String: [RowViewModel]]) -> [SectionViewModel] {
        // Sort the array base on the date
        let sortedGroupingKey = sectionTable.keys.sorted(by: dateStringDescComparator())

        return sortedGroupingKey.map {
            let rowViewModels = sectionTable[$0]!
            return SectionViewModel(rowViewModels: rowViewModels, headerTitle: $0)
        }
    }

    /// Use the date string for grouping feeds, e.x grouping same-date feeds
    private func sectionGroupingKey(_ feed: Feed) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter.string(from: feed.time)
    }

    private func dateStringDescComparator() -> ((String, String) -> Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return { (d1Str, d2Str) -> Bool in
            if let d1 = formatter.date(from: d1Str), let d2 = formatter.date(from: d2Str) {
                return d1 > d2
            } else {
                return false
            }
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
