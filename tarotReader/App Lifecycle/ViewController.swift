//
//  ViewController.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/20/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var card1: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    
    var manager: APIRequestManager!
    var cardDisplayer: CardDisplayer!
    var card: TarotCard!
    var cards: [TarotCard]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = APIRequestManager()
        self.cardDisplayer = CardDisplayer()
        self.cards = []
        
        let indices = cardDisplayer.generateThreeRandomIndices()
        
        grabCard(at: indices[0])
        grabCard(at: indices[1])
        grabCard(at: indices[2])
        
        cardDisplayer.shade(views: [self.card1, self.card2, self.card3])
    }
    
    func grabCard(at index: Int) {
        let cardURL = "\(Endpoint.get)=\(index)"
        
        self.manager.getData(endPoint: cardURL) { (data: Data?) in
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
                    }
                    
                }
                catch {
                    print("error making get request")
                }
            }
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        let cardsFaceUp = [self.card1, self.card2, self.card3].filter{ $0?.image != nil }
        
        guard cardsFaceUp.isEmpty else {
            _ = cardsFaceUp.map { $0?.image = nil }
            return
        }
        
        let firstCardColor = self.card1.backgroundColor
        let secondCardColor = self.card2.backgroundColor
        let thirdCardColor = self.card3.backgroundColor
        
        self.card1.backgroundColor = thirdCardColor
        self.card2.backgroundColor = firstCardColor
        self.card3.backgroundColor = secondCardColor
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.main.async {
            let cardsFaceUp = [self.card1, self.card2, self.card3].filter{ $0?.image != nil }
            
            guard cardsFaceUp.isEmpty else {
                _ = cardsFaceUp.map { $0?.image = nil }
                return
            }
            
            let firstCardColor = self.card1.backgroundColor
            let secondCardColor = self.card2.backgroundColor
            let thirdCardColor = self.card3.backgroundColor
            
            self.card1.backgroundColor = secondCardColor
            self.card2.backgroundColor = thirdCardColor
            self.card3.backgroundColor = firstCardColor
        }
    }
    
    @IBAction func cardWasTapped(_ sender: UITapGestureRecognizer) {
        
        guard let tag = sender.view?.tag else { return }
        var card: UIImageView
        
        switch tag {
        case 0:
            card = self.card1
        case 1:
            card = self.card2
        case 2:
            card = self.card3
        default:
            return
        }
        
        guard card.image == nil else { return }
        
        guard self.cards.count > tag else { return }
        
        DispatchQueue.main.async {
            if let cardFace = self.cardDisplayer.makeCardFace(from: self.cards[tag].imageAddress) {
                card.image = cardFace
            }
        }
    }
    
}

