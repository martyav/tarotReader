//
//  CardPopOver.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/23/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

func showDescription(for card: TarotCard) -> UIAlertController {
    let alert = UIAlertController(title: card.title, message: card.description, preferredStyle: UIAlertControllerStyle.alert)
    
    let dismissButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) {
        (result : UIAlertAction) -> Void in
        print("OK")
    }
    
    alert.addAction(dismissButton)
    
    alert.view.tintColor = UIColor.darkGray
    
    return alert
}
