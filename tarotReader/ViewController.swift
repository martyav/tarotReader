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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = APIRequestManager()
        self.card = TarotCard(title: "", image: "http://martyav.site.swiftengine.net/tarot/rwworld.jpg", description: "")
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
        
        DispatchQueue.main.async {
           // self.card1.backgroundColor = color
            let cardFace = #imageLiteral(resourceName: "Fool")
            self.card1.image = cardFace
        }
    }
    
    @IBAction func card2WasTapped(_ sender: UITapGestureRecognizer) {
        let color = randomlyGenerateColor()

        DispatchQueue.main.async {
            self.card2.backgroundColor = color
            // self.card2.image = UIImage()
        }
    }
    
    @IBAction func card3WasTapped(_ sender: UITapGestureRecognizer) {
        let color = randomlyGenerateColor()

        DispatchQueue.main.async {
            self.card3.backgroundColor = color
            // self.card3.image = UIImage()
        }
    }
    
    
}

