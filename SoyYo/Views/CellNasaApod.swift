//
//  CellNasaApod.swift
//  SoyYo
//
//  Created by Oscar Julian on 28/08/21.
//  Copyright © 2021 Oscar Julian Gil Bernal. All rights reserved.
//

import UIKit

class CellNasaApod: UITableViewCell {

    @IBOutlet var ItemImage: UIImageView!
    @IBOutlet var textTitle: UILabel!    
    @IBOutlet var textDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UILabel {
    func setSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: self.font.fontName, size: sizeFont)!
        self.sizeToFit()
    }
}
