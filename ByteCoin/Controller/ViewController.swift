//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
}

// MARK:  UIPicker Data Source Functions

extension ViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// MARK:  UIPicker Delegate Functions

extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK:  Coin Manager Delegate Functions

extension ViewController: CoinManagerDelegate{
    
    func updateCoinValue(coin: Coin) {
        DispatchQueue.main.async{
            self.currencyLabel.text = coin.asset_id_quote
            self.bitcoinLabel.text = String(format: "%.2f", coin.rate)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

