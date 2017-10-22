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
        
        self.grabCards()
        
        self.cardDisplayer.makeCardBacks([self.card1, self.card2, self.card3])
        self.cardDisplayer.shade(views: [self.card1, self.card2, self.card3])
    }
    
    func grabCards() {
        let indices = cardDisplayer.generateThreeRandomIndices()
        
        for index in 0..<indices.count {
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
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        let cardViews = [card1!, card2!, card3!]
        let faceUpCards = cardViews.filter { cardDisplayer.checkFaceUp($0) }
        
        switch faceUpCards.count {
        case 0:
            cardDisplayer.moveAllCardsRight(cardViews)
        case 1:
            switch faceUpCards.first! {
            case card1:
                cardDisplayer.moveTwoCards(first: self.card2, second: self.card3)
            case card2:
                cardDisplayer.moveTwoCards(first: self.card1, second: self.card3)
            case card3:
                cardDisplayer.moveTwoCards(first: self.card1, second: self.card2)
            default:
                return
            }
        default:
            return
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        let cardViews = [card1!, card2!, card3!]
        let faceUpCards = cardViews.filter { cardDisplayer.checkFaceUp($0) }
        
        if faceUpCards.count > 1 { return }
        
        switch faceUpCards.count {
            
        case 0:
            cardDisplayer.moveAllCardsLeft(cardViews)
        case 1:
            switch faceUpCards.first! {
            case card1:
               cardDisplayer.moveTwoCards(first: self.card3, second: self.card2)
            case card2:
                cardDisplayer.moveTwoCards(first: self.card3, second: self.card1)
            case card3:
               cardDisplayer.moveTwoCards(first: self.card2, second: self.card1)
            default:
                return
            }
        default:
            return
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
        
        if card.image?.imageAsset! == #imageLiteral(resourceName: "Back").imageAsset! {
            guard let lastCard = self.cards.popLast() else { return }
            
            DispatchQueue.main.async {
                if let cardFace = self.cardDisplayer.makeCardFace(from: lastCard.imageAddress) {
                    card.image = cardFace
                }
            }
            
        }
        
    }
    
    @IBAction func refreshWasTapped(_ sender: UIButton) {
        self.cards = []
        self.grabCards()
        
        DispatchQueue.main.async {
            self.cardDisplayer.makeCardBacks([self.card1, self.card2, self.card3])
        }
    }
    
}
