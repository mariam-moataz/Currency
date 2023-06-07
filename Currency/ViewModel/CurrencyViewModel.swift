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
        
    init() {
        currencies = NetworkService.shared.fetchData(url: "http://data.fixer.io/api/latest?access_key=48077b55b55d82ccb7c21382a249b725").observe(on: MainScheduler.instance).catchAndReturn(CurrencyResponse())
    }
}
