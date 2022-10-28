//
//  File.swift
//  
//
//  Created by Radzivon Bartoshyk on 27/10/2022.
//

import Foundation
import ZipArchive

public enum CompressionMethod: Int, CaseIterable {
    case store = 0, deflate, bzip2, lzma, zstd, xz, aes

    public var cValue: UInt16 {
        switch self {
        case .store:
            return UInt16(MZ_COMPRESS_METHOD_STORE)
        case .deflate:
            return UInt16(MZ_COMPRESS_METHOD_DEFLATE)
        case .bzip2:
            return UInt16(MZ_COMPRESS_METHOD_BZIP2)
        case .lzma:
            return UInt16(MZ_COMPRESS_METHOD_LZMA)
        case .zstd:
            return UInt16(MZ_COMPRESS_METHOD_ZSTD)
        case .xz:
            return UInt16(MZ_COMPRESS_METHOD_XZ)
        case .aes:
            return UInt16(MZ_COMPRESS_METHOD_AES)
        }
    }
}
