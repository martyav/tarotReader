//
//  APIRequestManager.swift
//  swiftEngineAdventure
//
//  Created by Marty Hernandez Avedon on 10/19/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import Foundation

fileprivate let cardAPIQueue = DispatchQueue(
    label: "ssp.tarot-deck.swiftengine.net.martyav.site",
    attributes: .concurrent)

class APIRequestManager {
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let validURL = URL(string: endPoint) else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: validURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(String(describing: error))")
            }
            guard let validData = data else { return }
           
            cardAPIQueue.async(flags: .barrier) {
                callback(validData)
            }
            
            }.resume()
    }
}
