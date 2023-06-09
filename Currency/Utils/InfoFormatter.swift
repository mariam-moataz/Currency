//
//  InfoFormatter.swift
//  Currency
//
//  Created by Mariam Moataz on 09/06/2023.
//

import Foundation
import CoreData

class InfoFormatter{
    static var shared = InfoFormatter()
    private init(){}
    
    func formateToExchangeInfo(managedObjects : [NSManagedObject]) -> [ExchangeInfo]?{
        
        guard !managedObjects.isEmpty else {return nil}
        var infoArray : [ExchangeInfo] = []
        
        for managedObj in managedObjects{
            var info = ExchangeInfo()
            info.baseCurrency = managedObj.value(forKey: "baseCur") as? String ?? ""
            info.targetCurrency = managedObj.value(forKey: "targetCur") as? String ?? ""
            info.amount = managedObj.value(forKey: "baseRate") as? String ?? ""
            info.convertedAmount = managedObj.value(forKey: "targetRate") as? String ?? ""
            info.date = managedObj.value(forKey: "date") as? Date ?? Date()
            infoArray.append(info)
        }
        
        return infoArray
    }
}
