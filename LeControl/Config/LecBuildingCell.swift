//
//  LecBuildingCell.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class LecBuildingCell: UITableViewCell {

    var building: LecBuilding? {
        didSet {
            self.configureView()
        }
    }
    
    private func configureView() {
        // Update the user interface for the detail item.
        if let building = self.building {
            if let label = self.textLabel {
                label.text = building.buildingName
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
