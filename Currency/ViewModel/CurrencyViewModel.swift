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
        currencies = NetworkService.shared.fetchData(url: "").observe(on: MainScheduler.instance).catchAndReturn(CurrencyResponse())
    }
}
