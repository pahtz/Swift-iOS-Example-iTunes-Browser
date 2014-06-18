//
//  Track.swift
//  Swift iTunes Browser
//
//  Created by Paul Yu on 14/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import Foundation

class Track {
    
    var title: String?
    var price: String?
    var previewUrl: String?
    
    init(dict: NSDictionary!) {
        self.title = dict["trackName"] as? String
        self.price = dict["trackPrice"] as? String
        self.previewUrl = dict["previewUrl"] as? String
    }
}