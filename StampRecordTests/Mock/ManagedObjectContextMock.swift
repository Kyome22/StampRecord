/*
 ManagedObjectContextMock.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/18.
*/

@testable import StampRecord
import CoreData

enum ContextError: LocalizedError {
    case saveFailed
    case fetchFailed

    var errorDescription: String? {
        return String(describing: self)
    }
}

final class ManagedObjectContextMock: ManagedObjectContextImpl {
    var isSaveFailed: Bool = false
    var isFetchFailed: Bool = false

    override func save() throws {
        if isSaveFailed {
            throw ContextError.saveFailed
        }
        try super.save()
    }

    override func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        if isFetchFailed {
            throw ContextError.fetchFailed
        }
        return try super.fetch(request)
    }
}
