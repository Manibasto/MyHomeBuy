//
//  GetPropertyTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 13/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class GetPropertyTableCell: UITableViewCell {
   @IBOutlet weak var bedRoomBtn: UIButton!
    
    @IBOutlet weak var bathRoomBtn: UIButton!
    @IBOutlet weak var garageBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var propertyImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
