//
//  DatabaseManager.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 25/12/24.
//

import CoreData
import UIKit

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Persistent container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AkshayShedgeTask")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Save Data
    func saveUserHoldings(_ userHoldings: [UserHolding],
                          completion: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.context.perform {
                // Delete existing data
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserHoldingEntity.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    // Execute the batch delete
                    try self.context.execute(deleteRequest)
                    try self.context.save() // Save after deletion
                    
                    // Insert new data
                    userHoldings.forEach { holding in
                        let entity = UserHoldingEntity(context: self.context)
                        entity.symbol = holding.symbol
                        entity.quantity = Int16(holding.quantity ?? 0)
                        entity.ltp = holding.ltp ?? 0.0
                        entity.avgPrice = holding.avgPrice ?? 0.0
                        entity.close = holding.close ?? 0.0
                    }
                    
                    //Save the context with the new data
                    try self.context.save()
                    
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } catch {
                    
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
    }

    
    // Fetch Data
    func fetchUserHoldings(completion: @escaping ([UserHolding]?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.context.perform {
                let fetchRequest: NSFetchRequest<UserHoldingEntity> = UserHoldingEntity.fetchRequest()
                do {
                    let results = try self.context.fetch(fetchRequest)
                    let userHoldings = results.map { entity in
                        UserHolding(
                            symbol: entity.symbol,
                            quantity: Int(entity.quantity),
                            ltp: entity.ltp,
                            avgPrice: entity.avgPrice,
                            close: entity.close
                        )
                    }
                    
                    DispatchQueue.main.async {
                        completion(userHoldings, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
    }
}
