//
//  EventsTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 11/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class EventsTableCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var descLbl: UILabel!
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
