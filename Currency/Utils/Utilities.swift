//
//  Utilities.swift
//  Currency
//
//  Created by Mariam Moataz on 08/06/2023.
//

import Foundation

class Utilities{
    static let utils = Utilities()
    private init(){}
    
    func convertCurrency(baseCurrency: String, baseCurrencyRate: Double ,targetCurrency : String, targetCurrencyRate : Double, amount : Double) -> String?{
        
        let baseToEUR = 1 / baseCurrencyRate // Exchange rate of baseCurrency/EUR
        let eurToTargetCurrency = targetCurrencyRate // Exchange rate of targetCurrency/EUR
        let baseToTarget = baseToEUR * eurToTargetCurrency
        
        let convertedAmount = amount * baseToTarget
        let roundedConvertedAmount = (convertedAmount * 100).rounded()/100
        return String(roundedConvertedAmount)
    }
}
