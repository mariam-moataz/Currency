//
//  FetchFromCore.swift
//  Currency
//
//  Created by Mariam Moataz on 09/06/2023.
//

import Foundation

protocol FetchFromCore{
    func fetchHistory(appDelegate : AppDelegate) -> [ExchangeInfo]?
}
