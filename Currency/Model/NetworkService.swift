//
//  NetworkService.swift
//  Currency
//
//  Created by Mariam Moataz on 07/06/2023.
//

import Foundation
import RxSwift

class NetworkService : NetworkServiceProtocol{
    static var shared = NetworkService()
    private init(){}
    
    func fetchData(url : String?) -> Observable<CurrencyResponse>{
        guard let url = URL(string: url!) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1))
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared.rx.response(request: request).map { (response, data) -> CurrencyResponse in
            let decoder = JSONDecoder()
            let dec = try decoder.decode(CurrencyResponse.self, from: data)
            print(dec)
            return dec
        }
        .catch { error in
            return Observable.error(error)
        }
        return session
    }
}
