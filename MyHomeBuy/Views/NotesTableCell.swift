//
//  NotesTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 09/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class NotesTableCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
