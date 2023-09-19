/*
 LogRepository.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/17.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol LogRepository: AnyObject {
    func getLog(of date: Date?) -> Log?
    func updateLog(_ log: Log)
}

final class LogRepositoryImpl: LogRepository {
    private let calendar = Calendar.current
    private var logs = [Log]()

    init() {}

    func getLog(of date: Date?) -> Log? {
        guard let date else { return nil }
        return logs.first { calendar.isEqual(a: $0.date, b: date) }
    }

    func updateLog(_ log: Log) {
        let index = logs.firstIndex { calendar.isEqual(a: $0.date, b: log.date) }
        if let index {
            if log.stamps.isEmpty {
                logs.remove(at: index)
            } else {
                logs[index] = log
            }
        } else {
            if !log.stamps.isEmpty {
                logs.append(log)
            }
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class LogRepositoryMock: LogRepository {
        func getLog(of date: Date?) -> Log? { return nil }
        func updateLog(_ log: Log) {}
    }
}
