/*
 StampRepository.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import CoreData

protocol StampRepository: AnyObject {
    var stamps: [Stamp] { get }

    init(context: NSManagedObjectContext)

    func addStamp(_ emoji: String, _ summary: String) -> Bool
    func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool
    func deleteStamp(_ stamp: Stamp)
}

final class StampRepositoryImpl: StampRepository {
    private let context: NSManagedObjectContext
    private var managedStamps = [ManagedStamp]()

    init(context: NSManagedObjectContext) {
        self.context = context
        do {
            try fetchManagedStamps()
        } catch {
            logput(error.localizedDescription)
        }
    }

    var stamps: [Stamp] {
        return managedStamps.compactMap { managedStamp in
            guard let emoji = managedStamp.emoji,
                  let summary = managedStamp.summary,
                  let createdDate = managedStamp.createdDate else {
                return nil
            }
            return Stamp(emoji: emoji, summary: summary, createdDate: createdDate)
        }
    }

    private func fetchManagedStamps() throws {
        managedStamps = try context.fetch(ManagedStamp.fetchRequest())
    }

    func addStamp(_ emoji: String, _ summary: String) -> Bool {
        if stamps.contains(where: { $0.emoji == emoji }) {
            return false
        }
        let newStamp = ManagedStamp(context: context)
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
        guard let index = managedStamps.firstIndex(where: { $0.emoji == stamp.emoji }) else {
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
        guard let index = managedStamps.firstIndex(where: { $0.emoji == stamp.emoji }) else {
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
        let stamps: [Stamp] = []

        init(context: NSManagedObjectContext) {}
        init() {}

        func addStamp(_ emoji: String, _ summary: String) -> Bool { return true }
        func updateStamp(_ stamp: Stamp, _ emoji: String, _ summary: String) -> Bool { return true }
        func deleteStamp(_ stamp: Stamp) {}
    }
}
