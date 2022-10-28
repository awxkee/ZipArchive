//
//  File.swift
//  
//
//  Created by Radzivon Bartoshyk on 27/10/2022.
//

import Foundation

public struct FlattyEntry {
    let filename: String
    let ratio: Float
    let compressedSize: Int64
    let uncompressedSize: Int64
    let compressionMethod: CompressionMethod
    let crc: UInt32
    let internalAttributes: UInt16
    let externalAttributes: UInt32
    let encrypted: Bool
    let modifiedDate: Date
    let createdData: Date
    let comment: String?
    let type: EntryType
}
