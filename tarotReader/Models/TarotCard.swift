//
//  TarotCard.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/20/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

class TarotCard {
    let title: String
    let imageAddress: URL
    let description: String
    let arcana: Arcana
    
    static var deck: [TarotCard] = []
    
    init(title: String, image: String, description: String) {
        self.title = title
        self.imageAddress = URL(string: image)!
        self.description = description
        self.arcana = TarotCard.findArcana(for: image)
    }
    
    init?(dict: [String: AnyObject]) {
        guard let jsonDict = dict as? [String: String] else { return nil }
        
        guard let jsonTitle = jsonDict["title"],
            let jsonImage = jsonDict["image"],
            let jsonDescription = jsonDict["description"] else {
                return nil
        }
        
        guard let jsonImageURL = URL(string: jsonImage) else { return nil }
        
        
        self.title = jsonTitle
        self.imageAddress = jsonImageURL
        self.description = jsonDescription
        self.arcana = TarotCard.findArcana(for: jsonImage)
    }
    
    static  func findArcana(for address: String) -> Arcana {
        let components = address.components(separatedBy: CharacterSet.punctuationCharacters)
        let imageName = components[8]
        let scalars = imageName.unicodeScalars
        let thirdIndex = scalars.index(address.startIndex, offsetBy: 2)
        let thirdCharacter = scalars[thirdIndex]
        
        let containsDigit = CharacterSet.decimalDigits.contains(thirdCharacter)
        
        if containsDigit {
            return Arcana.Minor
        } else {
            return Arcana.Major
        }
    }
}
