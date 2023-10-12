/*
 LogRepository.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import Combine
import CoreData

protocol LogRepository: AnyObject {
    var logsPublisher: AnyPublisher<Void, Never> { get }

    init(context: NSManagedObjectContext,
         stampsPublisher: AnyPublisher<[Stamp], Never>)

    func getLog(of date: Date?) -> Log?
    func updateLog(_ log: Log)
}

final class LogRepositoryImpl: LogRepository {
    private let context: NSManagedObjectContext
    private let calendar = Calendar.current
    private var managedLogs = [ManagedLog]()
    private var stamps = [Stamp]()
    private var cancellables = Set<AnyCancellable>()

    private let logsSubject = PassthroughSubject<Void, Never>()
    var logsPublisher: AnyPublisher<Void, Never> {
        logsSubject.eraseToAnyPublisher()
    }

    init(
        context: NSManagedObjectContext,
        stampsPublisher: AnyPublisher<[Stamp], Never>
    ) {
        self.context = context
        stampsPublisher
            .sink { [weak self] stamps in
                self?.stamps = stamps
            }
            .store(in: &cancellables)
        do {
            try fetchManagedLogs()
        } catch {
            logput(error.localizedDescription)
        }
    }

    private func fetchManagedLogs() throws {
        managedLogs = try context.fetch(ManagedLog.fetchRequest())
        logsSubject.send()
    }

    func getLog(of date: Date?) -> Log? {
        guard let managedLog = managedLogs.first(where: { calendar.isEqual(a: date, b: $0.date) }),
              let date = managedLog.date,
              let ids = managedLog.stamps else {
            return nil
        }
        return Log(date: date, stamps: stamps.filter { ids.contains($0.id) })
    }

    func updateLog(_ log: Log) {
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
            if !log.stamps.isEmpty {
                let newLog = ManagedLog(context: context)
                newLog.date = log.date
                newLog.stamps = log.stamps.map { $0.id }
            }
        }
        do {
            try context.save()
            try fetchManagedLogs()
        } catch {
            logput(error.localizedDescription)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class LogRepositoryMock: LogRepository {
        var logsPublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }

        init(context: NSManagedObjectContext,
             stampsPublisher: AnyPublisher<[Stamp], Never>) {}
        init() {}

        func getLog(of date: Date?) -> Log? { return nil }
        func updateLog(_ log: Log) {}
    }
}
