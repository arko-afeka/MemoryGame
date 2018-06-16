//
//  HighScoreData.swift
//  MemoryGame
//
//  Created by arkokat on 11/06/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation
import CoreData

@objc(HighScore)
class HighScore: NSManagedObject {
    @NSManaged var name: String!
    @NSManaged var time: NSNumber!
    
    convenience init(insertInto context: NSManagedObjectContext?) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "HighScore", in: context!)!, insertInto: context)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    func save() -> Bool {
        var isSaved = false
        
        do {
            try self.managedObjectContext?.save()
            isSaved = true
        } catch {
            print("Failed to save high score (\(self)) in Core Data \(error)")
        }
        
        return isSaved
    }
    
    static func fetchedScoresAscending(context: NSManagedObjectContext) -> [HighScore]? {
        var fetchedScores: [HighScore]?
        let scoresFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: HighScore.className)
        
        scoresFetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "time", ascending: true))
        do {
            fetchedScores = try context.fetch(scoresFetchRequest) as? [HighScore]
        } catch {
            print("Error fetching from Core Data: \(error)")
        }
        
        return fetchedScores
    }
}

