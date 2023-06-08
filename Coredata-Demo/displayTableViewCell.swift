//
//  displayTableViewCell.swift
//  Coredata-Demo
//
//  Created by Deepak Tanwar on 03/06/23.
//

import UIKit

class displayTableViewCell: UITableViewCell {

    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = imgView.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
