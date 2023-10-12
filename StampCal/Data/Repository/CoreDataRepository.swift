/*
 CoreDataRepository.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/19.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import CoreData

struct CoreDataRepository {
    let container: NSPersistentCloudKitContainer

    static let shared = CoreDataRepository()

    static var preview: CoreDataRepository = {
        let result = Self(inMemory: true)
        let context = result.container.viewContext

        Stamp.dummy.forEach { stamp in
            let managedStamp = ManagedStamp(context: context)
            managedStamp.id = stamp.id
            managedStamp.emoji = stamp.emoji
            managedStamp.summary = stamp.summary
            managedStamp.createdDate = stamp.createdDate
        }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "StampCal")
        if inMemory {
            guard let desctiption = container.persistentStoreDescriptions.first else {
                fatalError("Failed to retrive a persistent store description.")
            }
            desctiption.url = URL(fileURLWithPath: "/dev/null")
            desctiption.setOption(NSNumber(booleanLiteral: true),
                                  forKey: NSPersistentHistoryTrackingKey)
            desctiption.setOption(NSNumber(booleanLiteral: true),
                                  forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            assertionFailure("Failed to pin viewContext to the current generation:\(error)")
        }
    }
}
