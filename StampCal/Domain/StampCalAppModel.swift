/*
 StampCalAppModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/20.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol StampCalAppModel: ObservableObject {
    associatedtype SR: StampRepository

    var stampRepository: SR { get }
}

final class StampCalAppModelImpl: StampCalAppModel {
    typealias SR = StampRepositoryImpl

    let stampRepository: SR

    init() {
        stampRepository = SR()
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class StampCalAppModelMock: StampCalAppModel {
        typealias SR = StampRepositoryMock

        let stampRepository = SR()
    }
}
