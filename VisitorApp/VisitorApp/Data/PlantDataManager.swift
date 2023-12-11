//
//  PersistanceManager.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 5/12/2023.
//

import Foundation
import CoreData

class PlantDataManager {
    static let shared = PlantDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VisitorApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - CRUD Operations
    
    func createPlant(family: String, country: String, species: String, recnum: String, isExists: @escaping (Bool) -> Void) -> PlantEntity? {
        
        // check if already plant exists
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "family == %@ AND country == %@ AND species == %@ AND recnum == %@", family, country, species, recnum)
        
        do {
            let matchingPlants = try managedContext.fetch(fetchRequest)
            if let existingPlant = matchingPlants.first {
                isExists(true)
                return existingPlant
            } else { // no matching plant, proceed for saving
                let plant = NSEntityDescription.insertNewObject(forEntityName: "PlantEntity", into: managedContext) as? PlantEntity
                plant?.family = family
                plant?.country = country
                plant?.species = species
                plant?.recnum = recnum
                saveContext()
                isExists(false)
                return plant
            }
        } catch {
            print("Failed to fetch plants: \(error)")
            return nil
        }
    }
    
    func getAllPlants() -> [PlantEntity] {
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        do {
            let plants = try managedContext.fetch(fetchRequest)
            return plants
        } catch {
            print("Failed to fetch plants: \(error)")
            return []
        }
    }
    
    func updatePlant(_ plant: PlantEntity, family: String, country: String, species: String, recnum: String) {
        plant.family = family
        plant.country = country
        plant.species = species
        plant.recnum = recnum
        saveContext()
    }
    
    func deletePlant(_ plant: PlantEntity) {
        managedContext.delete(plant)
        saveContext()
    }
    
    // MARK: - Core Data Saving Support
    
    private func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                
                print("success:")
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
