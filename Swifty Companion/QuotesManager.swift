//
//  QuotesManager.swift
//  Swifty Companion
//
//  Created by Vasu Rabaib on 11/28/19.
//  Copyright © 2019 Vasu Rabaib. All rights reserved.
//

import Foundation

protocol QuotesManagerDelegate {
    func displayQuote(quote: QuotesData)
    func displayAuthor(quote: QuotesData)
}

struct QuotesManager {
    
    let quotesURL = "https://programming-quotes-api.herokuapp.com/quotes/random"
    
    var delegate: QuotesManagerDelegate?
    
    func fetchRandomQuote() {
        performRequest(urlString: quotesURL)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            if let quote = self.parseJSON(quoteData: safeData) {
                self.delegate?.displayQuote(quote: quote)
                self.delegate?.displayAuthor(quote: quote)
            }
        }
    }
    
    func parseJSON(quoteData: Data) -> QuotesData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(QuotesData.self, from: quoteData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
}

