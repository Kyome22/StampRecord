/*
 LogRepository.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import Combine
import CoreData

protocol LogRepository: AnyObject {
    var logsPublisher: AnyPublisher<Void, Never> { get }

    init(context: ManagedObjectContext,
         stampsPublisher: AnyPublisher<[Stamp], Never>)

    func getLog(of date: Date?) -> Log?
    func updateLog(_ log: Log) throws
}

final class LogRepositoryImpl: LogRepository {
    private let context: ManagedObjectContext
    private let calendar = Calendar.current
    private var managedLogs = [ManagedLog]()
    private var stamps = [Stamp]()
    private var cancellables = Set<AnyCancellable>()

    private let logsSubject = PassthroughSubject<Void, Never>()
    var logsPublisher: AnyPublisher<Void, Never> {
        logsSubject.eraseToAnyPublisher()
    }

    init(
        context: ManagedObjectContext,
        stampsPublisher: AnyPublisher<[Stamp], Never>
    ) {
        self.context = context
        stampsPublisher
            .sink { [weak self] stamps in
                self?.updateStamps(stamps)
            }
            .store(in: &cancellables)
        do {
            try fetchManagedLogs()
        } catch {
            logput(error.localizedDescription)
        }
    }

    private func fetchManagedLogs() throws {
        do {
            managedLogs = try context.fetch(ManagedLog.fetchRequest())
        } catch {
            logput(error.localizedDescription)
            throw SRError.database(.failedFetchData)
        }
        logsSubject.send()
    }

    private func save() throws {
        do {
            try context.save()
        } catch {
            logput(error.localizedDescription)
            throw SRError.database(.failedUpdateDB)
        }
    }

    private func clearDeletedStamps() {
        managedLogs.forEach { managedLog in
            if var _stamps = managedLog.stamps {
                _stamps = _stamps.filter { id in stamps.contains(where: { $0.id == id }) }
                if _stamps.isEmpty {
                    context.delete(managedLog)
                } else {
                    managedLog.stamps = _stamps
                }
            }
        }
        do {
            try save()
            try fetchManagedLogs()
        } catch {
            logput(error.localizedDescription)
        }
    }

    private func updateStamps(_ stamps: [Stamp]) {
        let isDeleted: Bool = stamps.count < self.stamps.count
        self.stamps = stamps
        if isDeleted {
            clearDeletedStamps()
        }
    }

    func getLog(of date: Date?) -> Log? {
        guard let managedLog = managedLogs.first(where: { calendar.isEqual(a: date, b: $0.date) }),
              let _date = managedLog.date,
              let ids = managedLog.stamps else {
            return nil
        }
        let _stamps = ids.compactMap { id in stamps.first(where: { $0.id == id }) }
        return Log(date: _date, stamps: _stamps)
    }

    func updateLog(_ log: Log) throws {
        let index = managedLogs.firstIndex { managedLog in
            calendar.isEqual(a: log.date, b: managedLog.date)
        }
        if let index {
            if log.stamps.isEmpty {
                context.delete(managedLogs[index])
            } else {
                managedLogs[index].stamps = log.stamps.map { $0.id }
            }
        } else {
            if log.stamps.isEmpty {
                throw SRError.log(.skipToUpdate)
            } else {
                let newLog: ManagedLog = context.makeObject()
                newLog.date = log.date
                newLog.stamps = log.stamps.map { $0.id }
            }
        }
        try save()
        try fetchManagedLogs()
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class LogRepositoryMock: LogRepository {
        var logsPublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }

        init(context: ManagedObjectContext,
             stampsPublisher: AnyPublisher<[Stamp], Never>) {}
        init() {}

        func getLog(of date: Date?) -> Log? { return nil }
        func updateLog(_ log: Log) throws {}
    }
}
