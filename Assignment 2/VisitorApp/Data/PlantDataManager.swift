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
    
    func createPlant(family: String, country: String, species: String, recnum: String, isFav: Bool, isExists: @escaping (Bool) -> Void) -> PlantEntity? {
        
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
                plant?.isFav = isFav
                saveContext()
                isExists(false)
                return plant
            }
        } catch {
            print("Failed to fetch plants: \(error)")
            return nil
        }
    }
    
    func getPlant(withRecnum recnum: String) -> PlantEntity? {
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recnum == %@", recnum)
        
        do {
            let matchingPlants = try managedContext.fetch(fetchRequest)
            return matchingPlants.first
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
    
    func updateFavoriteStatus(for recnum: String, isFavorite: Bool) {
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recnum == %@", recnum)
        
        do {
            let matchingPlants = try managedContext.fetch(fetchRequest)
            if let plant = matchingPlants.first {
                plant.isFav = isFavorite
                saveContext()
            }
        } catch {
            print("Failed to fetch plants: \(error)")
        }
    }
    
    func deletePlant(_ plant: PlantEntity) {
        managedContext.delete(plant)
        saveContext()
    }
    
    func deletePlant(withRecnum recnum: String) {
        let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recnum == %@", recnum)
        
        do {
            let matchingPlants = try managedContext.fetch(fetchRequest)
            if let plantToDelete = matchingPlants.first {
                managedContext.delete(plantToDelete)
                saveContext()
            } else {
                print("No plant found with recnum: \(recnum)")
            }
        } catch {
            print("Failed to fetch plants: \(error)")
        }
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
