//
//  SaveToCore.swift
//  Currency
//
//  Created by Mariam Moataz on 09/06/2023.
//

import Foundation

protocol SaveToCore{
    func saveToHistory(appDelegate : AppDelegate, info : ExchangeInfo)
}
