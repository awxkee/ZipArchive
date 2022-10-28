//
//  CompressionLevel.swift
//  
//
//  Created by Radzivon Bartoshyk on 27/10/2022.
//

import Foundation
import ZipArchive

public enum CompressionLevel: Int {
    case `default` = 0, fast, normal, best

    public var cValue: Int32 {
        switch self {
        case .`default`:
            return MZ_COMPRESS_LEVEL_DEFAULT
        case .fast:
            return MZ_COMPRESS_LEVEL_FAST
        case .normal:
            return MZ_COMPRESS_LEVEL_NORMAL
        case .best:
            return MZ_COMPRESS_LEVEL_BEST
        }
    }
}
