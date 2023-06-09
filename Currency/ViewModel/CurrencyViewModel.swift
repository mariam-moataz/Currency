//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Mariam Moataz on 07/06/2023.
//

import Foundation
import RxSwift

class CurrencyViewModel{
    let currencies: Observable<CurrencyResponse>
        
    init(url : String) {
        currencies = NetworkService.shared.fetchData(url: url).observe(on: MainScheduler.instance).catchAndReturn(CurrencyResponse())
    }
    
    func save(appDel : AppDelegate, baseCur : String, targetCur : String, amount : String, amountConverted : String){
        CoreDataManager.shared.saveToHistory(appDelegate: appDel, info: ExchangeInfo(baseCurrency: baseCur, targetCurrency: targetCur, amount: amount, convertedAmount: amountConverted))
    }
    
    func doCurrencyOperation(baseCurrency: String, baseCurrencyRate: Double ,targetCurrency : String, targetCurrencyRate : Double, amount : Double) -> String?{
        Utilities.utils.convertCurrency(baseCurrency: baseCurrency, baseCurrencyRate: baseCurrencyRate, targetCurrency: targetCurrency, targetCurrencyRate: targetCurrencyRate, amount: amount)
    }
}
