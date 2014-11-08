//
//  DouBanHomeCell.swift
//  DouBan
//
//  Created by Mave on 14/10/22.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import UIKit

class DouBanHomeCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var artist: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
