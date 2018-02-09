//
//  ResourceContactTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 07/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class ResourceContactTableCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var initialLbl: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var contactAvailableImageView: UIImageView!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
