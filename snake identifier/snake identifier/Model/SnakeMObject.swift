//
//  SnakeMObject.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//

import Foundation
import CoreData
import UtilityKit
import IdentifierScanner


class SnakeMObject: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
   
    @NSManaged var snakeCommonName: String
    @NSManaged var scientificName: String
    @NSManaged var confidence: Double
    @NSManaged var venomous: Bool
    @NSManaged var habitat: String
    @NSManaged var diet: String
    @NSManaged var behavior: String
    @NSManaged var region: String
    @NSManaged var dangerLevel: String
    @NSManaged var toxicity: String
    @NSManaged var notes: String
    @NSManaged var source: String
    @NSManaged var attribution: String
    
    @NSManaged  var isInMyCollection: Bool
    @NSManaged var lastUpdatedDate: Date
    @NSManaged var imageData: Data?
    
    @NSManaged var lengthCM: EntitySizeMObject
    @NSManaged var colors: Set<EntityColorMObject>
    
    @discardableResult
    func extract(from model: SnakeModel,
                 context: NSManagedObjectContext) -> SnakeMObject {
        id = model.id
        
        snakeCommonName = model.snakeCommonName
        scientificName = model.scientificName
        confidence = model.confidence
        venomous = model.venomous
        habitat = model.habitat
        diet = model.diet
        behavior = model.behavior
        region = model.region
        
        dangerLevel = model.dangerLevel
        toxicity = model.toxicity
        notes = model.notes
        source = model.source
        attribution = model.attribution
        isInMyCollection = model.isInMyCollection
        lastUpdatedDate = model.lastUpdatedDate
        imageData = model.imageData
        
        lengthCM = EntitySizeMObject(context: context).extract(from: model.lengthCM,
                                                               id: model.id,
                                                             context: context)
        colors = Set(model.colors.map {
            EntityColorMObject(context: context).extract(
                from: $0,
                id: model.id,
                context: context)
        })
        
        return self
    }
    
    
    var model: SnakeModel {
        let model = SnakeModel()
        model.id = id
        model.snakeCommonName = snakeCommonName
        model.scientificName = scientificName
        model.confidence = confidence
        model.venomous = venomous
        model.habitat = habitat
        model.diet = diet
        model.behavior = behavior
        model.region = region
        model.dangerLevel = dangerLevel
        model.toxicity = toxicity
        model.notes = notes
        model.source = source
        model.attribution = attribution
        
        model.isInMyCollection = isInMyCollection
        model.lastUpdatedDate = lastUpdatedDate
        model.imageData = imageData
        
        model.lengthCM = lengthCM.model
        model.colors = colors.map{$0.model}
        return model
    }
    
    static func delete(withId id: UUID, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<SnakeMObject> = NSFetchRequest(entityName: "Snake")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            if let object = try context.fetch(fetchRequest).first {
                context.delete(object)
                try ChatMessageMObject.deleteMessages(for: id, context: context)
                try context.save()
                print("Snake deleted successfully.")
            } else {
                print("Snake not found.")
            }
        } catch {
            print("Failed to delete Snake: \(error)")
        }
    }

    static func toggleCollectionStatus(withId id: UUID, isInMyCollection: Bool, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<SnakeMObject> = NSFetchRequest(entityName: "Snake")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            if let object = try context.fetch(fetchRequest).first {
                object.isInMyCollection = isInMyCollection
                try context.save()
                print("Collection status toggled successfully.")
            } else {
                print("Snake not found.")
            }
        } catch {
            print("Failed to toggle collection status: \(error)")
        }
    }
}

class EntityColorMObject: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var hex: String
    
    @discardableResult
    func extract(
        from model: EntityColorModel,
        id: UUID,
        context: NSManagedObjectContext) -> EntityColorMObject {
            self.id = id
            name = model.name
            hex = model.hex
        
        return self
    }
    
    var model: EntityColorModel {
        var model = EntityColorModel()
        model.name = name
        model.hex = hex
        return model
    }
}

class EntitySizeMObject: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var min: Double
    @NSManaged var max: Double
    
    @discardableResult
    func extract(
        from model: EntitySizeRangeModel,
        id: UUID,
        context: NSManagedObjectContext) -> EntitySizeMObject {
            self.id = id
            min = model.min
            max = model.max
        
        return self
    }
    
    var model: EntitySizeRangeModel {
        var model = EntitySizeRangeModel()
        model.min = min
        model.max = max
        return model
    }
}
