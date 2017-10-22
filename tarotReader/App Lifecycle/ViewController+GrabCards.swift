//
//  ViewController+GrabCards.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/22/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

extension ViewController {
    func generateThreeRandomIndices(deckSize: UInt32) -> [Int] {
        var randomCardIndexes: [Int] = []
        
        while randomCardIndexes.count < deckSize {
            let freshIndex = arc4random_uniform(deckSize)
            
            guard !randomCardIndexes.contains(Int(freshIndex)) else {
                continue
            }
            
            randomCardIndexes.append(Int(freshIndex))
        }
        
        return randomCardIndexes
    }
    
    func grabCards() {
        let indices = generateThreeRandomIndices(deckSize: 3)
        
        for index in 0..<indices.count {
            let cardURL = "\(Endpoint.get)=\(index)"
            
            self.networkManager.getData(endPoint: cardURL) { (data: Data?) in
                if let validData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: validData, options: [])
                        
                        guard let results = json as? [String: Any],
                            let response = results["response"] as? [String: AnyObject] else {
                                throw Serialized.error
                        }
                        
                        if let card = TarotCard(dict: response) {
                            self.cards.append(card)
                            print(card.title)
                            print(self.cards.count)
                        }
                        
                    }
                    catch {
                        print("error making get request")
                    }
                }
            }
        }
    }
}
