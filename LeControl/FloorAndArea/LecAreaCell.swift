//
//  LecAreaCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/23.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecAreaCell: UITableViewCell {
    @IBOutlet weak var areaImageView: UIImageView!
    @IBOutlet weak var areaNameLabel: UILabel!
    var areaId: String?
    var area: LecArea? {
        didSet {
            if let area = self.area {
                if let areaNameLabel = self.areaNameLabel {
                    areaNameLabel.text = area.areaName
                }
                if let areaImageView = self.areaImageView {
                    areaImageView.image = UIImage(named: area.areaImageName)
                }
            }
        }
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
