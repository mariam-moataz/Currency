//
//  PopularCurrencies.swift
//  Currency
//
//  Created by Mariam Moataz on 11/06/2023.
//

import Foundation

struct PopularCurrencies{
    //USD,JPY,CNY,GBP,AUD,CAD,CHF,NZD,HKD,SGD
    
    func getCurrencies() -> [String]{
        let currenciesArray = ["USD","JPY","CNY","GBP","AUD","CAD","CHF","NZD","HKD","SGD"]
        return currenciesArray
    }
}
