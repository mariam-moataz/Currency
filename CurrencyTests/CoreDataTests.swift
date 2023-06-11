//
//  CoreDataTests.swift
//  CurrencyTests
//
//  Created by Mariam Moataz on 11/06/2023.
//

import XCTest
import CoreData
@testable import Currency

final class CoreDataTests: XCTestCase {

    var inMemoryPersistentContainer: NSPersistentContainer!
    
    override func setUp(){
        let mergedModel = NSManagedObjectModel.mergedModel(from: nil)
                
        // Create an in-memory persistent store coordinator
        inMemoryPersistentContainer = NSPersistentContainer(name: "Currency", managedObjectModel : mergedModel!)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        inMemoryPersistentContainer.persistentStoreDescriptions = [description]
        
        // Load the persistent store
        inMemoryPersistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            XCTAssertNil(error, "Failed to load persistent store")
        })
    }

    override func tearDown(){
        inMemoryPersistentContainer = nil
    }

    func testCoreData() {
        let context = inMemoryPersistentContainer.newBackgroundContext()
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(Date.now, forKey: "date")
        object.setValue("EUR", forKey: "baseCur")
        object.setValue("USD", forKey: "targetCur")
        object.setValue("1.0", forKey: "baseRate")
        object.setValue("1.076537", forKey: "targetRate")
        // When
        try? context.save()
        
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        let results = try? inMemoryPersistentContainer.viewContext.fetch(fetchRequest)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.baseCur, "EUR")
        XCTAssertEqual(results?.first?.targetCur, "USD")
        XCTAssertEqual(results?.first?.baseRate, "1.0")
        XCTAssertEqual(results?.first?.targetRate, "1.076537")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
