/*
 TodayRepository.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import Combine

protocol TodayRepository: AnyObject {
    var todayPublisher: AnyPublisher<Date, Never> { get }
}

final class TodayRepositoryImpl: TodayRepository {
    private var cancellables = Set<AnyCancellable>()

    private let todaySubject: CurrentValueSubject<Date, Never>
    var todayPublisher: AnyPublisher<Date, Never> {
        return todaySubject.eraseToAnyPublisher()
    }

    init(date: Date) {
        todaySubject = .init(date)

        NotificationCenter.default
            .publisher(for: .NSCalendarDayChanged)
            .sink { [weak self] _ in
                self?.todaySubject.send(Date.now)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class TodayRepositoryMock: TodayRepository {
        var todayPublisher: AnyPublisher<Date, Never> {
            Just(Date.now).eraseToAnyPublisher()
        }

        init() {}
    }
}
