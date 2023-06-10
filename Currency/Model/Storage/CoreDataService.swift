//
//  CoreDataService.swift
//  Currency
//
//  Created by Mariam Moataz on 09/06/2023.
//

import Foundation
import CoreData

class CoreDataService{
    static var shared = CoreDataService()
        private init(){}
        
    func saveHistory(appDelegate : AppDelegate, info : ExchangeInfo){
            
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: managedContext)
        let currencyDetails = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        print(Date.now)
        let calendar = Calendar.current
        let today = Date.now
        
        //let threeDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        currencyDetails.setValue(Date.now, forKey: "date")
        currencyDetails.setValue(info.baseCurrency, forKey: "baseCur")
        currencyDetails.setValue(info.targetCurrency, forKey: "targetCur")
        currencyDetails.setValue(info.amount, forKey: "baseRate")
        currencyDetails.setValue(info.convertedAmount, forKey: "targetRate")
        
        print(info.baseCurrency)
        print(info.targetCurrency)
        print(info.amount)
        print(info.convertedAmount)
        
        do{
           try managedContext.save()
       }catch let error as NSError{
           print("Error in Saving: ",error)
       }
        
    }
    
    func fetchHistory(appDelegate : AppDelegate) -> [ExchangeInfo]?{
        
        var fetchNSManagedObject : [NSManagedObject] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
                        
        do{
            fetchNSManagedObject = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Error in fetching \(error)")
        }
        
        return InfoFormatter.shared.formateToExchangeInfo(managedObjects : fetchNSManagedObject)
    }
    
}
