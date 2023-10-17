/*
 StampRepositoryTests.swift
 StampRecordTests

 Created by Takuto Nakamura on 2023/10/18.
*/

@testable import StampRecord
import XCTest
import Combine

final class StampRepositoryTests: XCTestCase {
    func test_addStamp() {
        XCTContext.runActivity(named: "happy path") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                let exp = expectation(description: "stampsPublisher")
                var stamp: Stamp?
                let cancellable = sut.stampsPublisher.sink { stamps in
                    stamp = stamps.first
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 3.0)
                cancellable.cancel()
                let actual = try XCTUnwrap(stamp)
                XCTAssertEqual(actual.emoji, "😄")
                XCTAssertEqual(actual.summary, "Smile")
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "save failed") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            contextMock.isSaveFailed = true
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                XCTFail()
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
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                XCTFail()
            } catch SRError.database(let type) {
                XCTAssertEqual(type, .failedFetchData)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "emoji overrapping") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                try sut.addStamp("😄", "Smile")
                XCTFail()
            } catch SRError.stamp(let type, let context) {
                XCTAssertEqual(type, .emojiOverrapping)
                XCTAssertEqual(context, .add)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "summary exceeds") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "SmileSmileSmileSmileSmile")
                XCTFail()
            } catch SRError.stamp(let type, let context) {
                XCTAssertEqual(type, .summaryExceeds)
                XCTAssertEqual(context, .add)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }
    }

    func test_updateStamp() {
        XCTContext.runActivity(named: "happy path") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                let exp = expectation(description: "stampsPublisher")
                var stamp: Stamp?
                let cancellable = sut.stampsPublisher.sink { stamps in
                    stamp = stamps.first
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 3.0)
                cancellable.cancel()
                let original = try XCTUnwrap(stamp)
                try sut.updateStamp(original, "💪", "Training")
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "not found id") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.updateStamp(Stamp(emoji: "", summary: ""), "💪", "Training")
            } catch SRError.stamp(let type, let context) {
                XCTAssertEqual(type, .notFoundDataID)
                XCTAssertEqual(context, .edit)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "emoji overrapping") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                try sut.addStamp("💪", "Training")
                let exp = expectation(description: "stampsPublisher")
                var stamp: Stamp?
                let cancellable = sut.stampsPublisher.sink { stamps in
                    stamp = stamps.first(where: { $0.summary == "Training" })
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 3.0)
                cancellable.cancel()
                let original = try XCTUnwrap(stamp)
                try sut.updateStamp(original, "😄", "Training")
                XCTFail()
            } catch SRError.stamp(let type, let context) {
                XCTAssertEqual(type, .emojiOverrapping)
                XCTAssertEqual(context, .edit)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "summary exceeds") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                let exp = expectation(description: "stampsPublisher")
                var stamp: Stamp?
                let cancellable = sut.stampsPublisher.sink { stamps in
                    stamp = stamps.first
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 3.0)
                cancellable.cancel()
                let original = try XCTUnwrap(stamp)
                try sut.updateStamp(original, "😄", "TrainingTrainingTraining")
                XCTFail()
            } catch SRError.stamp(let type, let context) {
                XCTAssertEqual(type, .summaryExceeds)
                XCTAssertEqual(context, .edit)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }
    }

    func test_deleteStamp() {
        XCTContext.runActivity(named: "happy path") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                try sut.addStamp("😄", "Smile")
                let exp = expectation(description: "stampsPublisher")
                var stamp: Stamp?
                let cancellable = sut.stampsPublisher.sink { stamps in
                    stamp = stamps.first
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 3.0)
                cancellable.cancel()
                let original = try XCTUnwrap(stamp)
                try sut.deleteStamp(original)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }

        XCTContext.runActivity(named: "not found id") { _ in
            let repo = CoreDataRepository(inMemory: true)
            let contextMock = ManagedObjectContextMock(context: repo.container.viewContext)
            let sut = StampRepositoryImpl(context: contextMock)
            do {
                let stamp = Stamp(emoji: "😄", summary: "Smile")
                try sut.deleteStamp(stamp)
            } catch SRError.stamp(let type, let context) {
                XCTAssertEqual(type, .notFoundDataID)
                XCTAssertEqual(context, .delete)
            } catch {
                XCTFail("catch error: \(error.localizedDescription)")
            }
        }
    }
}
