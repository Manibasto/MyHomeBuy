//
//  TaskSuggestionListTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 23/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class TaskSuggestionListTableCell: UITableViewCell {
    @IBOutlet weak var taskCompleteBtn: UIButton!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var mileStoneStatusBtn: UIButton!
    
    @IBOutlet weak var suggestionCheckListButton: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet var btnArray: [UIButton]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
