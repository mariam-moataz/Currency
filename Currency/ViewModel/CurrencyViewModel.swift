//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Mariam Moataz on 07/06/2023.
//

import Foundation
import RxSwift

class CurrencyViewModel{
    
    let currencies: Observable<CurrencyResponse>?
        
    init(url : String) {
        currencies = NetworkService.shared.fetchData(url: url)?.observe(on: MainScheduler.instance).catchAndReturn(CurrencyResponse())
    }
    
    init(){
        currencies = nil
    }
    
    func save(appDel : AppDelegate, baseCur : String, targetCur : String, amount : String, amountConverted : String){
        CoreDataManager.shared.saveToHistory(appDelegate: appDel, info: ExchangeInfo(baseCurrency: baseCur, targetCurrency: targetCur, amount: amount, convertedAmount: amountConverted))
    }
    
    func fetch(appDel : AppDelegate) -> [Int : [ExchangeInfo]]?{
        
        guard let info = CoreDataManager.shared.fetchHistory(appDelegate: appDel) else{ return nil}
        
        var historyArray : [Int : [ExchangeInfo]] = [0:[], 1:[], 2:[], 3:[]]
        let calendar = Calendar.current
        
        let today = Date.now
        let todayComp = calendar.dateComponents([.year, .month, .day], from: today)

        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        let threeDaysComp = calendar.dateComponents([.year, .month, .day], from: threeDaysAgo)
        
        for i in 0...(info.count)-1{
            let infoComp = calendar.dateComponents([.year, .month, .day], from: info[i].date)
            
            guard (infoComp.year == threeDaysComp.year) && (infoComp.month == threeDaysComp.month) && (infoComp.day! >= threeDaysComp.day!) else{ // 3 days ago
                continue
            }
            
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
            let twoDaysComp = calendar.dateComponents([.year, .month, .day], from: twoDaysAgo)
            guard (infoComp.day! >= twoDaysComp.day!) else { //2 days ago
                print(infoComp.day!)
                print(threeDaysComp.day!)
                historyArray[3]?.append(info[i]) //append in key 3
                continue
            }
            
            let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: today)!
            let oneDayComp = calendar.dateComponents([.year, .month, .day], from: oneDayAgo)
            guard (infoComp.day! >= oneDayComp.day!) else{ //1 day ago
                historyArray[2]?.append(info[i]) //append in key 2
                print(infoComp.day!)
                print(twoDaysComp.day!)
                continue
            }
            
            guard (infoComp.day! == todayComp.day!) else{ //1 day ago
                historyArray[1]?.append(info[i]) //append in key 1
                print(infoComp.day!)
                print(oneDayComp.day!)
                continue
            }
            
            print(infoComp.day!)
            print(todayComp.day!)
            historyArray[0]?.append(info[i]) //append in key 0 means today
        }
        return historyArray
    }
    
    let popularCurrencies = PopularCurrencies()
    
    func getCurrencies(rates : [String : Double]?, base : String?, amount : String?) -> [ExchangeInfo]?{
        let popularCurr = popularCurrencies.getCurrencies()
        var currencies : [ExchangeInfo] = []
        
        guard let base = base else {return nil}
        guard let rates = rates else {return nil}
        guard let amount = amount else {return nil}
        guard let doubleValue = Double(amount) else {return nil}
        
        for curr in popularCurr {
            guard let convertedVal = doCurrencyOperation(baseCurrency: base , baseCurrencyRate: rates[base] ?? 1.0, targetCurrency: curr, targetCurrencyRate: rates[curr] ?? 1.0, amount: doubleValue) else {return []}
            let info = ExchangeInfo(baseCurrency: base, targetCurrency: curr, amount: amount, convertedAmount: convertedVal)
            currencies.append(info)
        }
        return currencies
    }
    
    
    func doCurrencyOperation(baseCurrency: String, baseCurrencyRate: Double ,targetCurrency : String, targetCurrencyRate : Double, amount : Double) -> String?{
        Utilities.utils.convertCurrency(baseCurrency: baseCurrency, baseCurrencyRate: baseCurrencyRate, targetCurrency: targetCurrency, targetCurrencyRate: targetCurrencyRate, amount: amount)
    }
}
