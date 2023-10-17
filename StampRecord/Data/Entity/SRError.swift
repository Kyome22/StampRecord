/*
 SRError.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/15.
 
*/

import SwiftUI

enum SRError: Error {
    enum DatabaseError: Error {
        case failedFetchData
        case failedUpdateDB

        var title: LocalizedStringKey {
            switch self {
            case .failedFetchData:
                return "failedFetchDataErrorTitle"
            case .failedUpdateDB:
                return "failedUpdateDBErrorTitle"
            }
        }

        var message: LocalizedStringKey {
            return "failedDBErrorMessage"
        }
    }

    enum StampError: Error {
        case notFoundDataID
        case emojiOverrapping
        case summaryExceeds

        var message: LocalizedStringKey {
            switch self {
            case .notFoundDataID:
                return "notFoundDataIDErrorMessage"
            case .emojiOverrapping:
                return "emojiOverlappingErrorMessage"
            case .summaryExceeds:
                return "summaryExceedsErrorMessage"
            }
        }
    }

    enum StampContext {
        case add
        case edit
        case delete

        var title: LocalizedStringKey {
            switch self {
            case .add:
                return "unableAddStamp"
            case .edit:
                return "unableSaveStamp"
            case .delete:
                return "unableDeleteStamp"
            }
        }
    }

    enum LogError: Error {
        case skipToUpdate

        var title: LocalizedStringKey {
            switch self {
            case .skipToUpdate:
                return "skipToUpdate"
            }
        }

        var message: LocalizedStringKey {
            switch self {
            case .skipToUpdate:
                return "skipToUpdateErrorMessage"
            }
        }
    }

    case database(_ databaseError: DatabaseError)
    case stamp(_ stampError: StampError, _ context: StampContext)
    case log(_ logError: LogError)

    var title: LocalizedStringKey {
        switch self {
        case .database(let error):
            return error.title
        case .stamp(_, let context):
            return context.title
        case .log(let error):
            return error.title
        }
    }

    var message: LocalizedStringKey {
        switch self {
        case .database(let error):
            return error.message
        case .stamp(let error, _):
            return error.message
        case .log(let error):
            return error.message
        }
    }
}
