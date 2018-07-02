//
//  PhotoCellViewModel.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation
import UIKit

class PhotoCellViewModel: RowViewModel, ViewModelPressible {

    let title: String
    let desc: String
    var image: AsyncImage

    var cellPressed: (() -> Void)?

    init(title: String, desc: String, image: AsyncImage) {
        self.title = title
        self.desc = desc
        self.image = image
    }
}
