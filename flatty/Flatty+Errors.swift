//
//  Flatty+Errors.swift
//  
//
//  Created by Radzivon Bartoshyk on 27/10/2022.
//

import Foundation

public struct FlattyInvalidURLError: LocalizedError {
    let url: URL
    public var errorDescription: String? {
        "Flatty may open only file scheme url, can't open: \(url.absoluteString)"
    }
}

public struct FlattyCompressURLError: LocalizedError {
    let url: URL
    let code: Int
    public var errorDescription: String? {
        "Can't compress url to archive: \(url.absoluteString), with code: \(code)"
    }
}

public struct FlattyCompressionLevelUpdateError: LocalizedError {
    public var errorDescription: String? {
        "Cannot set compression level in reading mode"
    }
}

public struct FlattyCompressionMethodUpdateError: LocalizedError {
    public var errorDescription: String? {
        "Cannot set compression method in reading mode"
    }
}

public struct FlattyInvalidFilenameEntryError: LocalizedError {
    public var errorDescription: String? {
        "Invalid filename in entry"
    }
}

public struct FlattyCreateStreamError: LocalizedError {
    public var errorDescription: String? {
        "Flatty can't create stream"
    }
}

public struct FlattyReadEntryError: LocalizedError {
    public var errorDescription: String? {
        "Flatty cannot read entry"
    }
}

public struct FlattyCannotOpenError: LocalizedError {
    public var errorDescription: String? {
        "Cannot open zip error"
    }
}

public struct FlattyExtractError: LocalizedError {
    let code: Int32
    public var errorDescription: String? {
        "File extraction finished with error: \(code)"
    }
}

public struct FlattyCannotSeekToFirstEntry: LocalizedError {
    public var errorDescription: String? {
        "Cannot open the first entry"
    }
}

public struct FlattyExtractFileError: LocalizedError {
    let filename: String
    let destination: URL

    public var errorDescription: String? {
        "Can't extract \(filename) to \(destination.absoluteString)"
    }
}
