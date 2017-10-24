//
//  CardView.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/22/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

class CardView: UIImageView {
    var associatedCard: TarotCard?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.makeCardBack()
        self.shade()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.makeCardBack()
        self.shade()
    }
    
    func shade() {
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowRadius = 3
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = false
    }

    func makeCardBack() {
        self.image = UIImage(named: "Back")
    }
    
    func makeCardFace() -> UIImage? {
        var image: UIImage
        
        guard let url = self.associatedCard?.imageAddress else { return nil }
        
        do {
            let data: Data? = try Data(contentsOf: url)
            
            if let validImage =  UIImage(data: data!) {
                image = validImage
                return image
            }
        }
        catch {
            print("error creating image from \(url)")
        }
        
        return nil
    }
    
    func isFaceDown() -> Bool {
        return self.image?.imageAsset! == #imageLiteral(resourceName: "Back").imageAsset!
    }
   
    func isFaceUp() -> Bool {
        return self.image?.imageAsset! != #imageLiteral(resourceName: "Back").imageAsset!
    }
}
