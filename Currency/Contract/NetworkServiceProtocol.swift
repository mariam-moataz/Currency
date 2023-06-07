//
//  NetworkServiceProtocol.swift
//  Currency
//
//  Created by Mariam Moataz on 07/06/2023.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol{
    func fetchData(url : String?) -> Observable<CurrencyResponse>
}
