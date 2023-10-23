/*
 LogRepositoryTests.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/18.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

@testable import StampRecord
import XCTest
import Combine

final class LogRepositoryTests: XCTestCase {
    func xtest_updateLog() {
        XCTContext.runActivity(named: "happy path (add new log)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            do {
                let stamp = Stamp(emoji: "😄", summary: "Smile")
                try sut.updateLog(Log(date: Date.now, stamps: [stamp]))
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "happy path (update log)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = LogRepositoryImpl(context: contextMock, 
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            do {
                let date = Date.now
                let stamp = Stamp(emoji: "😄", summary: "Smile")
                try sut.updateLog(Log(date: date, stamps: [stamp]))
                try sut.updateLog(Log(date: date, stamps: [stamp, stamp]))
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "happy path (delete log)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = LogRepositoryImpl(context: contextMock, 
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            do {
                let date = Date.now
                let stamp = Stamp(emoji: "😄", summary: "Smile")
                try sut.updateLog(Log(date: date, stamps: [stamp]))
                try sut.updateLog(Log(date: date, stamps: []))
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "skip update log") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            do {
                try sut.updateLog(Log(date: Date.now, stamps: []))
            } catch SRError.log(let type) {
                XCTAssertEqual(type, .skipToUpdate)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "save failed") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            contextMock.isSaveFailed = true
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            do {
                let stamp = Stamp(emoji: "😄", summary: "Smile")
                try sut.updateLog(Log(date: Date.now, stamps: [stamp]))
            } catch SRError.database(let type) {
                XCTAssertEqual(type, .failedUpdateDB)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "fetch failed") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            contextMock.isFetchFailed = true
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            do {
                let stamp = Stamp(emoji: "😄", summary: "Smile")
                try sut.updateLog(Log(date: Date.now, stamps: [stamp]))
            } catch SRError.database(let type) {
                XCTAssertEqual(type, .failedFetchData)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }
    }

    func test_getLog() throws {
        XCTContext.runActivity(named: "happy path (nil)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: Just([Stamp]()).eraseToAnyPublisher())
            let log = sut.getLog(of: nil)
            XCTAssertNil(log)
        }

        try XCTContext.runActivity(named: "happy path (not nil)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let stamp = Stamp(emoji: "😄", summary: "Smile")
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: Just([stamp]).eraseToAnyPublisher())
            let date = Date.now
            try sut.updateLog(Log(date: date, stamps: [stamp]))
            let log = try XCTUnwrap(sut.getLog(of: date))
            XCTAssertEqual(log.stamps, [stamp])
        }

        try XCTContext.runActivity(named: "happy path (update stamp)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            var stamp = Stamp(emoji: "😄", summary: "Smile")
            let stampsSubject = CurrentValueSubject<[Stamp], Never>([stamp])
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: stampsSubject.eraseToAnyPublisher())
            let date = Date.now
            try sut.updateLog(Log(date: date, stamps: [stamp]))
            let log1 = try XCTUnwrap(sut.getLog(of: date))
            XCTAssertEqual(log1.stamps, [stamp])
            XCTAssertEqual(log1.stamps.first?.emoji, "😄")
            stamp.emoji = "💪"
            stampsSubject.send([stamp])
            let log2 = try XCTUnwrap(sut.getLog(of: date))
            XCTAssertEqual(log2.stamps, [stamp])
            XCTAssertEqual(log2.stamps.first?.emoji, "💪")
        }

        try XCTContext.runActivity(named: "happy path (delete stamp 1)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let stamp1 = Stamp(emoji: "😄", summary: "Smile")
            let stamp2 = Stamp(emoji: "💪", summary: "Training")
            let stampsSubject = CurrentValueSubject<[Stamp], Never>([stamp1, stamp2])
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: stampsSubject.eraseToAnyPublisher())
            let date = Date.now
            try sut.updateLog(Log(date: date, stamps: [stamp1, stamp2]))
            let log1 = try XCTUnwrap(sut.getLog(of: date))
            XCTAssertEqual(log1.stamps, [stamp1, stamp2])
            stampsSubject.send([stamp2])
            let log2 = try XCTUnwrap(sut.getLog(of: date))
            XCTAssertEqual(log2.stamps, [stamp2])
        }

        try XCTContext.runActivity(named: "happy path (delete stamp 2)") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let stamp = Stamp(emoji: "😄", summary: "Smile")
            let stampsSubject = CurrentValueSubject<[Stamp], Never>([stamp])
            let sut = LogRepositoryImpl(context: contextMock,
                                        stampsPublisher: stampsSubject.eraseToAnyPublisher())
            let date = Date.now
            try sut.updateLog(Log(date: date, stamps: [stamp]))
            let log1 = try XCTUnwrap(sut.getLog(of: date))
            XCTAssertEqual(log1.stamps, [stamp])
            stampsSubject.send([])
            let log2 = sut.getLog(of: date)
            XCTAssertNil(log2)
        }
    }
}
