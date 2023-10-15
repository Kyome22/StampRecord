/*
 StampRepository.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import Combine
import CoreData

protocol StampRepository: AnyObject {
    var stampsPublisher: AnyPublisher<[Stamp], Never> { get }
    var isEmpty: Bool { get }

    init(context: NSManagedObjectContext)

    func addStamp(_ emoji: String, _ summary: String) throws
    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) throws
    func deleteStamp(_ stamp: Stamp) throws
}

final class StampRepositoryImpl: StampRepository {
    private let context: NSManagedObjectContext
    private var managedStamps = [ManagedStamp]()

    private let stampsSubject = CurrentValueSubject<[Stamp], Never>([])
    var stampsPublisher: AnyPublisher<[Stamp], Never> {
        stampsSubject.eraseToAnyPublisher()
    }

    var isEmpty: Bool {
        return stampsSubject.value.isEmpty
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        do {
            try fetchManagedStamps()
        } catch {
            logput(error.localizedDescription)
        }
    }

    private func fetchManagedStamps() throws {
        do {
            managedStamps = try context.fetch(ManagedStamp.fetchRequest())
        } catch {
            logput(error.localizedDescription)
            throw SRError.database(.failedFetchData)
        }
        stampsSubject.value = managedStamps.compactMap { managedStamp in
            guard let id = managedStamp.id,
                  let emoji = managedStamp.emoji,
                  let summary = managedStamp.summary,
                  let createdDate = managedStamp.createdDate else {
                return nil
            }
            return Stamp(id: id, emoji: emoji, summary: summary, createdDate: createdDate)
        }
    }

    private func save() throws {
        do {
            try context.save()
        } catch {
            logput(error.localizedDescription)
            throw SRError.database(.failedUpdateDB)
        }
    }

    func addStamp(_ emoji: String, _ summary: String) throws {
        if managedStamps.contains(where: { $0.emoji == emoji }) {
            throw SRError.stamp(.emojiOverrapping, .add)
        }
        guard summary.count <= 20 else {
            throw SRError.stamp(.summaryExceeds, .add)
        }
        let newStamp = ManagedStamp(context: context)
        newStamp.id = UUID()
        newStamp.emoji = emoji
        newStamp.summary = summary
        newStamp.createdDate = Date.now
        try save()
        try fetchManagedStamps()
    }

    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) throws {
        guard let index = managedStamps.firstIndex(where: { $0.id == stamp.id }) else {
            throw SRError.stamp(.notFoundDataID, .edit)
        }
        if managedStamps[index].emoji != emoji,
           managedStamps.contains(where: { $0.emoji == emoji }) {
            throw SRError.stamp(.emojiOverrapping, .edit)
        }
        guard summary.count <= 20 else {
            throw SRError.stamp(.summaryExceeds, .edit)
        }
        managedStamps[index].emoji = emoji
        managedStamps[index].summary = summary
        try save()
        try fetchManagedStamps()
    }

    func deleteStamp(_ stamp: Stamp) throws {
        guard let index = managedStamps.firstIndex(where: { $0.id == stamp.id }) else {
            throw SRError.stamp(.notFoundDataID, .delete)
        }
        context.delete(managedStamps[index])
        try save()
        try fetchManagedStamps()
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampRepositoryMock: StampRepository {
        var stampsPublisher: AnyPublisher<[Stamp], Never> {
            Just([]).eraseToAnyPublisher()
        }
        var isEmpty: Bool { true }

        init(context: NSManagedObjectContext) {}
        init() {}

        func addStamp(_ emoji: String, _ summary: String) throws {}
        func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) throws {}
        func deleteStamp(_ stamp: Stamp) throws {}
    }
}
