//
//  APIRequestManager.swift
//  swiftEngineAdventure
//
//  Created by Marty Hernandez Avedon on 10/19/17.
//  Copyright © 2017 Marty's . All rights reserved.
//

import Foundation

class APIRequestManager {
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let validURL = URL(string: endPoint) else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: validURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(String(describing: error))")
            }
            guard let validData = data else { return }
           
            callback(validData)
            
            }.resume()
    }
    
    func storeData(endpoint: String, post: [String: String]) {
        guard let validURL = URL(string: endpoint) else { return }

        var request = URLRequest(url: validURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: post, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let error {
            print("Error converting data to json: \(error.localizedDescription)")
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode < 200, httpStatus.statusCode > 299 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            print(response ?? "no response")
        }.resume()
    }
    
}
