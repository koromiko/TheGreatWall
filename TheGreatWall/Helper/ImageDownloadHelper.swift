//
//  ImageDownloadHelper.swift
//  TheGreatWall
//
//  Created by Neo on 20/06/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

protocol ImageDownloadHelperProtocol {
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ())
}

class ImageDownloadHelper: ImageDownloadHelperProtocol {
    let urlSession: URLSession = URLSession.shared

    static var shared: ImageDownloadHelper = {
        return ImageDownloadHelper()
    }()

    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(UIImage(data: data), response, error)
            } else {
                completion(nil, response, error)
            }
        }.resume()
    }
}

/// Randomly pickup an image from resource and wait for 1~2 seconds, a mock of network image downloader
class MockImageDownloadHelper: ImageDownloadHelperProtocol {
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        DispatchQueue.global().async {
            usleep(1000000 + (arc4random() % 9)*100000)
            let images = ["sample", "sample2", "sample3", "sample4", "sample5", "profile"]
            let idx = Int(arc4random()) % images.count
            let randName = images[idx]
            let image = UIImage(contentsOfFile: Bundle.main.path(forResource: randName, ofType: "jpg")!)
            completion(image, nil, nil)
        }
    }
}
