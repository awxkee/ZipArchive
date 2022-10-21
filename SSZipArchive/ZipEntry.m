//
//  ZipEntry.m
//  
//
//  Created by Radzivon Bartoshyk on 21/10/2022.
//

#import <Foundation/Foundation.h>
#import "ZipEntry.h"

@implementation ZipEntry

-(_Nonnull instancetype)initWith:(char* _Nonnull)filename
                     isEncrypted:(BOOL)isEncrypted
                     compressedSize:(uint32_t)compressedSize
                     uncompressedSize:(uint32_t)uncompressedSize
                     entryType:(ZipEntryType)entryType {
    self = [super init];
    self.filename = [[NSString alloc] initWithUTF8String:filename];
    self.isEncrypted = isEncrypted;
    self.compressedSize = compressedSize;
    self.uncompressedSize = uncompressedSize;
    self.entryType = entryType;
    return self;
}

@end
