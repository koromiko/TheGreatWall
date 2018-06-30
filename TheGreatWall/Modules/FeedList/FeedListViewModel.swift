//
//  FeedListViewModel.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation
import UIKit
import SwiftIconFont

class FeedListViewModel {
    let title = Observable<String>(value: "Loading")
    let isLoading = Observable<Bool>(value: false)
    let isTableViewHidden = Observable<Bool>(value: false)
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
}
