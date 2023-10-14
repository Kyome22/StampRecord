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

    func addStamp(_ emoji: String, _ summary: String) -> Bool
    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool
    func deleteStamp(_ stamp: Stamp)
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
        managedStamps = try context.fetch(ManagedStamp.fetchRequest())
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

    func addStamp(_ emoji: String, _ summary: String) -> Bool {
        if managedStamps.contains(where: { $0.emoji == emoji }) {
            return false
        }
        let newStamp = ManagedStamp(context: context)
        newStamp.id = UUID()
        newStamp.emoji = emoji
        newStamp.summary = summary
        newStamp.createdDate = Date.now
        do {
            try context.save()
            try fetchManagedStamps()
            return true
        } catch {
            logput(error.localizedDescription)
            return false
        }
    }

    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool {
        if managedStamps.contains(where: { $0.emoji == emoji }) {
            return false
        }
        guard let index = managedStamps.firstIndex(where: { $0.id == stamp.id }) else {
            return false
        }
        managedStamps[index].emoji = emoji
        managedStamps[index].summary = summary
        do {
            try context.save()
            try fetchManagedStamps()
            return true
        } catch {
            logput(error.localizedDescription)
            return false
        }
    }

    func deleteStamp(_ stamp: Stamp) {
        guard let index = managedStamps.firstIndex(where: { $0.id == stamp.id }) else {
            return
        }
        context.delete(managedStamps[index])
        do {
            try context.save()
            try fetchManagedStamps()
        } catch {
            logput(error.localizedDescription)
        }
    }

    //  private func cleanManagedStamps() {
    //      var flag: Bool = false
    //      managedStamps.forEach { managedStamp in
    //          if managedStamp.emoji == nil || managedStamp.summary == nil || managedStamp.createdDate == nil {
    //              flag = true
    //              context.delete(managedStamp)
    //          }
    //      }
    //      if flag {
    //          do {
    //              try context.save()
    //              try fetchManagedStamps()
    //          } catch {
    //              logput(error.localizedDescription)
    //          }
    //      }
    //  }
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

        func addStamp(_ emoji: String, _ summary: String) -> Bool { return true }
        func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool { return true }
        func deleteStamp(_ stamp: Stamp) {}
    }
}
