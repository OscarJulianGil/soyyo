//
//  DetailController.swift
//  SoyYo
//
//  Created by Oscar Julian on 28/08/21.
//  Copyright © 2021 Oscar Julian Gil Bernal. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    var detailItem : Apod?
    
    @IBOutlet var textDescription: UITextView!
    
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var itemImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textDescription.isEditable = false
        if let itemValido = detailItem{
            textDescription.text = itemValido.explanation
            textDate.text = "Fecha: " + itemValido.date!
            textTitle.text = itemValido.title
            
            if itemValido.media_type! == "video"{
                self.itemImage.image = UIImage(named: "nodisponible")
            }
            else{
                 let url = URL(string: itemValido.url!)
                 self.itemImage.load(url: url!)
            }
           
        }

        // Do any additional setup after loading the view.
    }
    
}



