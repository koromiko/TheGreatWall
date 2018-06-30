//
//  MemberCellViewModel.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import UIKit
import SwiftIconFont

class MemberCellViewModel: RowViewModel {
    let name: String
    let avatar: AsyncImage
    let isLoading: Observable<Bool>
    let isAddBtnHidden: Observable<Bool>
    let isAddBtnEnabled: Observable<Bool>
    let addBtnTitle: Observable<String>
    var addBtnPressed: (() -> Void)?

    init(name: String,
         avatar: AsyncImage,
         isLoading: Observable<Bool> = Observable<Bool>(value: false),
         isAddBtnHidden: Observable<Bool> = Observable<Bool>(value: false),
         isAddBtnEnabled: Observable<Bool> = Observable<Bool>(value: true),
         addBtnTitle: Observable<String> = Observable<String>(value: String.fontAwesomeIcon("plus")!),
         addBtnPressed: (() -> Void)? = nil) {
        self.name = name
        self.avatar = avatar
        self.isLoading = isLoading
        self.isAddBtnHidden = isAddBtnHidden
        self.addBtnPressed = addBtnPressed
        self.isAddBtnEnabled = isAddBtnEnabled
        self.addBtnTitle = addBtnTitle
    }
}
