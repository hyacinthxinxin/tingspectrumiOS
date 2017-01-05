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
    
    var area: LecArea? {
        didSet {
            if let area = self.area {
                if let areaNameLabel = self.areaNameLabel {
                    areaNameLabel.text = area.name
                }
                if let areaImageView = self.areaImageView {
                    if let img = UIImage(named: area.imageName+"_room") {
                        areaImageView.image = img
                    } else {
                        areaImageView.image = UIImage(named: "other_room")
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let v = UIView()
        v.backgroundColor = LecConstants.AppColor.CamTintColor
        selectedBackgroundView = v
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        areaNameLabel.textColor = selected ? LecConstants.AppColor.ThemeBGColor : UIColor.white
    }

}
