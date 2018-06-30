//
//  Extensions.swift
//  TheGreatWall
//
//  Created by Neo on 28/05/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

public extension String {
    /// Ramdomly generated text
    public static var loremIpsum: String {
        let baseStr = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas blandit aliquet orci, tincidunt pellentesque eros condimentum quis. Morbi efficitur, metus at tristique gravida, nisi nisi accumsan dolor, a porttitor libero libero eu nunc. Aenean augue mi, facilisis in vulputate at, luctus eget nibh. Nulla condimentum metus sit amet nunc commodo, at tempor velit hendrerit. Vivamus vitae pharetra quam, a fermentum diam. Aliquam dapibus justo ut turpis mattis, in feugiat purus fringilla. In hac habitasse platea dictumst."
        let strLst = baseStr.components(separatedBy: " ")
        let offset = Int(arc4random_uniform(UInt32(strLst.count)))
        let substringLst = strLst[offset..<strLst.count]
        return substringLst.joined(separator: " ")
    }

    private static var nameList = ["Emily", "Michael", "Hannah", "Jacob", "Alex", "Ashley", "Tyler", "Taylor", "Andrew", "Jessica", "Daniel", "Katie", "John", "Emma", "Matthew", "Lauren", "Ryan", "samantha", "Austin", "Rachel", "David", "olivia", "Chris", "Kayla", "Nick", "Anna", "Brandon", "Megan", "Nathan", "Alyssa", "Anthony", "Alexis", "Grace", "Justin", "Madison", "Joshua", "elizabeth", "Jordan", "Nicole", "Jake", "Jack", "Abby", "Dylan", "Victoria", "james", "Brianna", "kyle", "Morgan", "Kevin", "Amber", "Ben", "Sydney", "Noah", "Brittany", "Eric", "Haley", "Sam", "Natalie", "Christian", "Julia", "Josh", "Savannah", "Zach", "Danielle", "Joseph", "Courtney", "Logan", "Rebecca", "Jonathan", "Paige", "Adam", "Jasmine", "Aaron", "Sara", "Jason", "Stephanie", "Christopher"]
    /// Ramdomly generated name
    public static var anyName: String {
        let randIdx = Int(arc4random_uniform(UInt32(nameList.count)))
        return nameList[randIdx]
    }
}

extension NSLayoutConstraint {
    /// Chainging a layout constraint with priority
    func withPriority(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

public extension UIView {
    /// Generating constraints to superview's edge
    public func edgeConstraints(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: self.superview!.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor, constant: -right),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: -bottom)
        ]
    }
}


