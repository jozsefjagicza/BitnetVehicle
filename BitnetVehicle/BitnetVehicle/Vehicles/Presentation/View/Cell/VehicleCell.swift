//
//  VehicleCell.swift
//  BitnetVehicle
//
//  Created by József Jagicza on 2021. 04. 08..
//

import UIKit

class VehicleCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
