/*
 ManagedObjectContext.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import CoreData

protocol ManagedObjectContext: AnyObject {
    init(context: NSManagedObjectContext)

    func makeObject<T: NSManagedObject>() -> T
    func save() throws
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T]
    func delete(_ object: NSManagedObject)
}

class ManagedObjectContextImpl: ManagedObjectContext {
    private let context: NSManagedObjectContext

    required init(context: NSManagedObjectContext) {
        self.context = context
    }
   
    func makeObject<T: NSManagedObject>() -> T {
        return T.init(context: context)
    }

    func save() throws {
        try context.save()
    }
    
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        return try context.fetch(request)
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ManagedObjectContextMock: ManagedObjectContext {
        init(context: NSManagedObjectContext) {}

        func makeObject<T: NSManagedObject>() -> T { T.init() }
        func save() throws {}
        func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] { return [] }
        func delete(_ object: NSManagedObject) {}
    }
}
