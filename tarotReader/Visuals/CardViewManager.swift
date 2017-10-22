//
//  CardCreation.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/21/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

struct CardViewManager {
    init() {}
    
    func moveAllCards(_ cards: [UIImageView]) {
        guard cards.count == 3 else { return }
        
        let firstCardColor = cards[0].backgroundColor
        let firstCardImage = cards[0].image
        let secondCardColor = cards[1].backgroundColor
        let secondCardImage = cards[1].image
        let thirdCardColor = cards[2].backgroundColor
        let thirdCardImage = cards[2].image
        
        DispatchQueue.main.async {
            cards[0].backgroundColor = secondCardColor
            cards[1].backgroundColor = thirdCardColor
            cards[2].backgroundColor = firstCardColor
            cards[0].image = secondCardImage
            cards[1].image = thirdCardImage
            cards[2].image = firstCardImage
        }
    }
    
    func moveTwoCards(first: UIImageView, second: UIImageView) {
        let firstCardColor = first.backgroundColor
        let firstCardImage = first.image
        let secondCardColor = second.backgroundColor
        let secondCardImage = second.image
        
        DispatchQueue.main.async {
            first.backgroundColor = secondCardColor
            second.backgroundColor = firstCardColor
            first.image = secondCardImage
            second.image = firstCardImage
        }
    }
}
