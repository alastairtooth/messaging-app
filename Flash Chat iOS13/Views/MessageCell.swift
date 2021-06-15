//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Alastair Tooth on 18/8/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
// direct radiology fairfield

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //same as viewDidLoad, but for whenever the .xib is called
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 4
        //this makes the bubbles corner radies change dependant on the amount of text.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
