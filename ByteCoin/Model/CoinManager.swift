//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func updateCoinValue(coin: Coin)
    
    func didFailWithError(error: Error)
    
}
struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "506CE471-FA42-4369-8190-2AC2730519D4"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    

    func getCoinPrice(for coin: String) {
        let url = baseURL + "/\(coin)" + "?apikey=\(apiKey)"
        print(url)
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let coin = self.parseJSON(data: safeData){
                        self.delegate?.updateCoinValue(coin: coin)
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data) -> Coin?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(Coin.self, from: data)
            let name = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            
            let coin = Coin(asset_id_quote: name, rate: rate)
            
            return coin
            
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
