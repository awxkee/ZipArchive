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

    public var cValue: Int16 {
        switch self {
        case .`default`:
            return Int16(MZ_COMPRESS_LEVEL_DEFAULT)
        case .fast:
            return Int16(MZ_COMPRESS_LEVEL_FAST)
        case .normal:
            return Int16(MZ_COMPRESS_LEVEL_NORMAL)
        case .best:
            return Int16(MZ_COMPRESS_LEVEL_BEST)
        }
    }
}
