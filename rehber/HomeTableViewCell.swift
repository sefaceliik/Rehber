//
//  HomeTableViewCell.swift
//  rehber
//
//  Created by Sefa MacBook Pro on 2.05.2021.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seperatorLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var noteField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        cellView.layer.cornerRadius = cellView.frame.height / 15
        cellView.layer.shadowOpacity = 0.6
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        noteField.layer.cornerRadius = noteField.frame.height / 12
        noteField.layer.borderWidth = 1
        noteField.layer.borderColor = UIColor.lightGray.cgColor
    }
}
