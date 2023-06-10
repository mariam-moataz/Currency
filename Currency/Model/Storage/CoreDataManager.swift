//
//  CoreDataManager.swift
//  Currency
//
//  Created by Mariam Moataz on 09/06/2023.
//

import Foundation
import CoreData

class CoreDataManager : SaveToCore, FetchFromCore{
    
    static var shared = CoreDataManager()
    private init(){}
    
    func saveToHistory(appDelegate : AppDelegate, info : ExchangeInfo){
        CoreDataService.shared.saveHistory(appDelegate: appDelegate, info: info)
    }
    
    func fetchHistory(appDelegate : AppDelegate) -> [ExchangeInfo]?{
        CoreDataService.shared.fetchHistory(appDelegate: appDelegate)
    }
}
