//
//  Post.swift
//  AC3.2-Final
//
//  Created by Eric Chang on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let key: String
    let comment: String
    let userId: String
    let image: UIImage?
    
    init(key: String, comment: String, userId: String, image: UIImage? = nil) {
        self.key = key
        self.comment = comment
        self.userId = userId
        self.image = image
    }
    
    var asDictionary: [String: String] {
        return ["comment": comment,
                "userId": userId]
    }
}
