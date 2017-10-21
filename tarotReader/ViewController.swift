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
    var card: TarotCard!
    var cards: [TarotCard]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = APIRequestManager()
        self.card = TarotCard(title: "", image: "http://martyav.site.swiftengine.net/tarot/rwworld.jpg", description: "")
        self.cards = []
        
        let indices = generateThreeRandomIndices()
        
        grabCard(at: indices[0])
        grabCard(at: indices[1])
        grabCard(at: indices[2])
    }
    
    func generateThreeRandomIndices() -> [Int] {
        let deckSize: UInt32 = 3
        var randomCardIndexes: [Int] = []
        
        while randomCardIndexes.count < 3 {
            let freshIndex = arc4random_uniform(deckSize - 1)
            randomCardIndexes.append(Int(freshIndex))
        }
        
        return randomCardIndexes
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
                    }
                    
                }
                catch {
                    print("error making get request")
                }
            }
        }
    }
    
    func makeImageFrom(url: URL) -> UIImage? {
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
    
    func randomlyGenerateColor() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(100))
        let randomGreen = CGFloat(arc4random_uniform(100))
        let randomBlue = CGFloat(arc4random_uniform(100))
        
        let randomColor = UIColor(red: randomRed/100, green: randomGreen/100, blue: randomBlue/100, alpha: 1.0)
        
        return randomColor
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.main.async {
            let firstCardColor = self.card1.backgroundColor
            let secondCardColor = self.card2.backgroundColor
            let thirdCardColor = self.card3.backgroundColor
            
            self.card1.backgroundColor = thirdCardColor
            self.card2.backgroundColor = firstCardColor
            self.card3.backgroundColor = secondCardColor
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.main.async {
            let firstCardColor = self.card1.backgroundColor
            let secondCardColor = self.card2.backgroundColor
            let thirdCardColor = self.card3.backgroundColor
            
            self.card1.backgroundColor = secondCardColor
            self.card2.backgroundColor = thirdCardColor
            self.card3.backgroundColor = firstCardColor
        }
    }

    @IBAction func card1WasTapped(_ sender: UITapGestureRecognizer) {
       // let color = randomlyGenerateColor()
        
        guard cards.count > 0 else { return }
        
        DispatchQueue.main.async {
           // self.card1.backgroundColor = color
            let cardFace = self.makeImageFrom(url: self.cards[0].imageAddress)
            self.card1.image = cardFace
        }
    }
    
    @IBAction func card2WasTapped(_ sender: UITapGestureRecognizer) {
       // let color = randomlyGenerateColor()

        guard cards.count > 1 else { return }
        
        DispatchQueue.main.async {
            //self.card2.backgroundColor = color
            let cardFace = self.makeImageFrom(url: self.cards[1].imageAddress)
            self.card2.image = cardFace
        }
    }
    
    @IBAction func card3WasTapped(_ sender: UITapGestureRecognizer) {
        //let color = randomlyGenerateColor()

        guard cards.count > 2 else { return }
        
        DispatchQueue.main.async {
           // self.card3.backgroundColor = color
            let cardFace = self.makeImageFrom(url: self.cards[2].imageAddress)
            self.card3.image = cardFace
        }
    }
    
    
}

