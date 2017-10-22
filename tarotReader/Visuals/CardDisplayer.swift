//
//  CardCreation.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/21/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

struct CardDisplayer {
    init() {}
    
    func generateThreeRandomIndices() -> [Int] {
        let deckSize: UInt32 = 3
        var randomCardIndexes: [Int] = []
        
        while randomCardIndexes.count < 3 {
            let freshIndex = arc4random_uniform(deckSize)
            
            guard !randomCardIndexes.contains(Int(freshIndex)) else {
                continue
            }
            
            randomCardIndexes.append(Int(freshIndex))
        }
        
        return randomCardIndexes
    }
    
    func shade(views: [UIView]) {
        for view in views {
            view.layer.shadowColor = UIColor.darkGray.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowOffset = CGSize(width: 0, height: 1)
            view.layer.shadowRadius = 3
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
            view.layer.shouldRasterize = false
        }
    }
    
    func makeCardFace(from url: URL) -> UIImage? {
        var image: UIImage
        
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
    
    func makeCardBacks(_ cards: [UIImageView]) {
        _ = cards.map { $0.image = UIImage(named: "Back") }
    }
}
