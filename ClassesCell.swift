//
//  ClassesCell.swift
//  FitnessClub
//
//  Created by Dev1 on 2/12/16.
//  Copyright © 2016 FXoffice. All rights reserved.
//

import UIKit

class ClassesCell: UITableViewCell {
    
    @IBOutlet weak var classIcon: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classDesc: UILabel!
    
    
    private var _classes: Classes?
    
    var classes: Classes? {
        return _classes
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(classes: Classes) {
        
        self._classes = classes
        
        if let classTitle = classes.title where classTitle != "" {
            self.classTitle.text = classTitle.uppercaseString
        } else {
            self.classTitle.text = nil
        }
        
        if let classDesc = classes.trainers where classDesc != "" {
            self.classDesc.text = classDesc
        } else {
            self.classDesc.text = nil
        }
        

        
    }
    
    
}