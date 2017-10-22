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
    
    var networkManager: APIRequestManager!
    var cardViewManager: CardViewManager!
    var cards: [TarotCard]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManager = APIRequestManager()
        self.cardViewManager = CardViewManager()
        self.cards = []
        
        self.grabCards()
        
        self.cardViewManager.makeCardBacks([self.card1, self.card2, self.card3])
        self.cardViewManager.shade(views: [self.card1, self.card2, self.card3])
    }
    
    // MARK: - Button Actions
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        let cardViews = [card1!, card2!, card3!]
        let faceUpCards = cardViews.filter { cardViewManager.checkFaceUp($0) }
        
        switch faceUpCards.count {
        case 0:
            cardViewManager.moveAllCards(cardViews.reversed())
        case 1:
            switch faceUpCards.first! {
            case card1:
                cardViewManager.moveTwoCards(first: self.card2, second: self.card3)
            case card2:
                cardViewManager.moveTwoCards(first: self.card1, second: self.card3)
            case card3:
                cardViewManager.moveTwoCards(first: self.card1, second: self.card2)
            default:
                return
            }
        default:
            return
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        let cardViews = [card1!, card2!, card3!]
        let faceUpCards = cardViews.filter { cardViewManager.checkFaceUp($0) }
        
        if faceUpCards.count > 1 { return }
        
        switch faceUpCards.count {
            
        case 0:
            cardViewManager.moveAllCards(cardViews)
        case 1:
            switch faceUpCards.first! {
            case card1:
               cardViewManager.moveTwoCards(first: self.card3, second: self.card2)
            case card2:
                cardViewManager.moveTwoCards(first: self.card3, second: self.card1)
            case card3:
               cardViewManager.moveTwoCards(first: self.card2, second: self.card1)
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
        
        if cardViewManager.checkFaceUp(card) == false {
            guard let lastCard = self.cards.popLast() else { return }
            
            DispatchQueue.main.async {
                if let cardFace = self.cardViewManager.makeCardFace(from: lastCard.imageAddress) {
                    card.image = cardFace
                }
            }
            
        }
        
    }
    
    @IBAction func refreshWasTapped(_ sender: UIButton) {
        self.cards = []
        self.grabCards()
        
        DispatchQueue.main.async {
            self.cardViewManager.makeCardBacks([self.card1, self.card2, self.card3])
        }
    }
    
}
