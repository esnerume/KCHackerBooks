//
//  BookTableViewCell.swift
//  KCHackerBooks
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var theImage: UIImageView!
    
    static var cellId: String {
        get {
            return "BookTableCell"
        }
    }
    
    static var cellHeight: CGFloat {
        get {
            // Establecemos el mismo valor que le hemos dado en el Interface Buider
            return 120
        }
    }
    
    var imageData: AsyncData? = nil
}


//MARK: - AsyncDataDelegate

extension BookTableViewCell: AsyncDataDelegate {
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        UIView.transition(with: theImage,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.theImage.image = UIImage(data: sender.data)
                            
        }, completion: nil)
    }
    
    //MARK: Utils
    
    func setImageView(with data: AsyncData) {
        imageData = data
        imageData!.delegate = self
        theImage.image = UIImage(data: imageData!.data)
    }
    
}

