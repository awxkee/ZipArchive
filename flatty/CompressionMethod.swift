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

    public var cValue: Int32 {
        switch self {
        case .store:
            return MZ_COMPRESS_METHOD_STORE
        case .deflate:
            return MZ_COMPRESS_METHOD_DEFLATE
        case .bzip2:
            return MZ_COMPRESS_METHOD_BZIP2
        case .lzma:
            return MZ_COMPRESS_METHOD_LZMA
        case .zstd:
            return MZ_COMPRESS_METHOD_ZSTD
        case .xz:
            return MZ_COMPRESS_METHOD_XZ
        case .aes:
            return MZ_COMPRESS_METHOD_AES
        }
    }
}
