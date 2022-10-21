//
//  Header.h
//  
//
//  Created by Radzivon Bartoshyk on 21/10/2022.
//

#ifndef _SSZIPENTRY_H
#define _SSZIPENTRY_H

#import <Foundation/Foundation.h>

typedef enum ZipEntryType : NSUInteger {
    ZipEntryTypeFile,
    ZipEntryTypeDir,
    ZipEntryTypeSymlink
} ZipEntryType;

@interface ZipEntry : NSObject

@property (nonatomic, strong) NSString * _Nonnull filename;
@property BOOL isEncrypted;
@property uint32_t compressedSize;
@property uint32_t uncompressedSize;
@property ZipEntryType entryType;

-(_Nonnull instancetype)init NS_UNAVAILABLE;

-(_Nonnull instancetype)initWith:(char* _Nonnull)filename
                     isEncrypted:(BOOL)isEncrypted
                     compressedSize:(uint32_t)compressedSize
                     uncompressedSize:(uint32_t)uncompressedSize
                     entryType:(ZipEntryType)entryType NS_DESIGNATED_INITIALIZER;

@end


#endif /* _SSZIPENTRY_H */
