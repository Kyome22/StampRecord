/*
 DayCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol DayCalendarViewModel: ObservableObject {
    var title: String { get set }
    var dayList: [Day] { get set }
    var shortWeekdays: [String] { get }

    init()

    func paging(with pageDirection: PageDirection)
}

final class DayCalendarViewModelImpl: DayCalendarViewModel {
    @Published var title: String = ""
    @Published var dayList: [Day] = []

    let shortWeekdays: [String]
    private let calendar = Calendar.current

    init() {
        shortWeekdays = calendar.shortWeekdaySymbols
        let now = Date.now
        let day = Day(date: now,
                      isToday: true,
                      text: calendar.dayText(of: now),
                      weekday: calendar.weekday(of: now))
        dayList.append(day)
        dayList.insert(getYesterday(of: now), at: 0)
        dayList.append(getTommorow(of: now))
        title = now.title
    }

    private func getYesterday(of date: Date) -> Day {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: date)
        return Day(date: yesterday,
                   isToday: calendar.isEqual(a: yesterday, b: Date.now),
                   text: calendar.dayText(of: yesterday),
                   weekday: calendar.weekday(of: yesterday))
    }

    private func getTommorow(of date: Date) -> Day {
        let tommorow = calendar.date(byAdding: .day, value: 1, to: date)
        return Day(date: tommorow,
                   isToday: calendar.isEqual(a: tommorow, b: Date.now),
                   text: calendar.dayText(of: tommorow),
                   weekday: calendar.weekday(of: tommorow))
    }

    func paging(with pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            if let baseDate = dayList[pageDirection.baseIndex].date {
                dayList.insert(getYesterday(of: baseDate), at: 0)
                dayList.removeLast()
            }
        case .forward:
            if let baseDate = dayList[pageDirection.baseIndex].date {
                dayList.append(getTommorow(of: baseDate))
                dayList.removeFirst()
            }
        }
        title = dayList[1].date?.title ?? "?"
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class DayCalendarViewModelMock: DayCalendarViewModel {
        @Published var title: String = ""
        @Published var dayList: [Day] = []
        let shortWeekdays: [String]

        init() {
            let calendar = Calendar.current
            shortWeekdays = calendar.shortWeekdaySymbols
            let now = Date.now
            let day = Day(date: now,
                          isToday: true,
                          text: calendar.dayText(of: now),
                          weekday: calendar.weekday(of: now))
            dayList.append(day)
            title = now.title
        }

        func paging(with pageDirection: PageDirection) {}
    }
}
