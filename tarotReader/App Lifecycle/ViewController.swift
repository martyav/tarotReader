//
//  ViewController.swift
//  tarotReader
//
//  Created by Marty Hernandez Avedon on 10/20/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var card1: CardView!
    @IBOutlet weak var card2: CardView!
    @IBOutlet weak var card3: CardView!
    
    var networkManager: APIRequestManager!
    var cardViewManager: CardViewManager!
    var cards: [TarotCard]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManager = APIRequestManager()
        self.cardViewManager = CardViewManager()
        self.cards = []
        
        self.grabCards()
    }
    
    // MARK: - Button Actions
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        let cardViews = [card1!, card2!, card3!]
        let faceUpCards = cardViews.filter { $0.isFaceUp() }
        
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
        let faceUpCards = cardViews.filter {$0.isFaceUp() }
        
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
        var card: CardView
        
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
        
        if  card.isFaceDown() {
            guard let lastCard = self.cards.popLast() else { return }
            
            card.associatedCard = lastCard
            
            DispatchQueue.main.async {
                if let cardFace = card.makeCardFace() {
                    card.image = cardFace
                }
            }
            
        } else {
            let title = self.cards[tag].title
            let message = self.cards[tag].description
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func refreshWasTapped(_ sender: UIButton) {
        self.cards = []
        self.grabCards()
        
        DispatchQueue.main.async {
            _ = [self.card1, self.card2, self.card3].map { $0?.associatedCard = nil; $0?.makeCardBack() }
        }
    }
    
}
