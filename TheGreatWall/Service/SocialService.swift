//
//  SocialService.swift
//  TheGreatWall
//
//  Created by Neo on 19/06/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation

/// This service provides interfaces for communication between client and server 
class SocialService {

    /// Making feed stubs
    private lazy var feeds: [Feed] = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        let feeds: [Feed] = (0...60).map { idx in
            let time = formatter.date(from: String(format: "2049-06-%02d", (idx/6)+1))!
            if idx % 3 == 1 {
                return Member(id: "\(idx)", userID: "\(idx)", time: time, name: String.anyName, isFollowing: false, avatarURL: "https://picsum.photos/45/45/?random")
            } else {
                let desc = String.loremIpsum
                return Photo(id: "\(idx)", time: time, imageURL: "https://picsum.photos/200/300/?random", captial: "Photo \(idx) (from Pexels)", description: desc)
            }
        }
        return feeds
    }()

    /// Fetch feeds from server
    func fetchFeeds(complete: @escaping ([Feed]) -> Void) {
        DispatchQueue.global().async {
            sleep(3) // fake response time
            DispatchQueue.main.async {
                complete(self.feeds)
            }
        }
    }

    /// Follow a sepcific user
    func follow(userID: String, complete: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            sleep(1) // fake response time
            let index = Int(userID)! // Stub id is the same with the array index
            if var member = self.feeds[index] as? Member {
                member.isFollowing = true
                self.feeds.remove(at: index)
                self.feeds.insert(member, at: index)
            }

            DispatchQueue.main.async {
                complete(true)
            }
        }
    }

}
