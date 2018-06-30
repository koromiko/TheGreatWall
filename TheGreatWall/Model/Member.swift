//
//  Member.swift
//  TheGreatWall
//
//  Created by Neo on 20/06/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation

struct Member: Feed {
    var id: String
    var userID: String
    var time: Date
    var name: String
    var isFollowing: Bool
    var avatarURL: String
}
