//
//  TrackCell.swift
//  Swift iTunes Browser
//
//  Created by Paul Yu on 14/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet var playIcon : UILabel
    @IBOutlet var titleLabel : UILabel
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
