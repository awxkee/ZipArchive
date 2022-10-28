//
//  Flatty.swift
//  
//
//  Created by Radzivon Bartoshyk on 27/10/2022.
//

import Foundation
import ZipArchive

public class Flatty {

    public static func extractFiles(url: URL, baseURL: URL, files: [String], password: String?) throws {
        if !url.isFileURL {
            throw FlattyInvalidURLError(url: url)
        }
        if !baseURL.isFileURL {
            throw FlattyInvalidURLError(url: baseURL)
        }
        guard !files.isEmpty else { return }
        let archiveHandle: UnsafeMutablePointer<UnsafeMutableRawPointer?> = .allocate(capacity: 1)
        mz_zip_reader_create(archiveHandle)

        defer {
            if mz_zip_reader_is_open(archiveHandle) == MZ_OK {
                mz_zip_reader_close(archiveHandle)
            }
            mz_zip_reader_delete(archiveHandle)
        }

        if let password {
            mz_zip_reader_set_password(archiveHandle, password)
        }

        var result = MZ_OK
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path), let fileSize = attrs[.size] as? UInt64 {
            if fileSize < 20 * 1024 * 1024 {
                result = mz_zip_reader_open_file_in_memory(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            } else {
                result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            }
        } else {
            result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
        }
        if result != MZ_OK {
            throw FlattyCreateStreamError()
        }

        var err = mz_zip_reader_goto_first_entry(archiveHandle)
        if err != MZ_OK {
            throw FlattyCannotSeekToFirstEntry()
        }
        let fileInfo = UnsafeMutablePointer<UnsafeMutablePointer<mz_zip_file>?>.allocate(capacity: 1)
        defer { fileInfo.deallocate() }
        while err == MZ_OK {
            err = mz_zip_reader_entry_get_info(archiveHandle, fileInfo)
            if err != MZ_OK {
                throw FlattyReadEntryError()
            }
            guard let info = fileInfo.pointee?.pointee else {
                throw FlattyReadEntryError()
            }

            err = mz_zip_reader_goto_next_entry(archiveHandle)
            if err != MZ_OK && err != MZ_END_OF_LIST {
                break
            }

            guard let cFilename = info.filename, let filename = String(utf8String: cFilename) else {
                throw FlattyInvalidFilenameEntryError()
            }

            if files.contains(filename) {
                let fileURL = baseURL.appendingPathComponent(filename)
                if mz_zip_reader_entry_save_file(archiveHandle, (fileURL.path as NSString).fileSystemRepresentation) != MZ_OK {
                    throw FlattyExtractFileError(filename: filename, destination: fileURL)
                }
            }

        }
    }

    public static func extractAll(url: URL, destination: URL, password: String?) throws {
        if !url.isFileURL {
            throw FlattyInvalidURLError(url: url)
        }
        if !destination.isFileURL {
            throw FlattyInvalidURLError(url: destination)
        }
        let archiveHandle: UnsafeMutablePointer<UnsafeMutableRawPointer?> = .allocate(capacity: 1)
        mz_zip_reader_create(archiveHandle)
        defer {
            if mz_zip_reader_close(archiveHandle) == MZ_OK {
                mz_zip_reader_delete(archiveHandle)
            }
        }

        if let password {
            mz_zip_reader_set_password(archiveHandle, password)
        }

        var result = MZ_OK
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path), let fileSize = attrs[.size] as? UInt64 {
            if fileSize < 20 * 1024 * 1024 {
                result = mz_zip_reader_open_file_in_memory(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            } else {
                result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            }
        } else {
            result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
        }
        if result != MZ_OK {
            throw FlattyCreateStreamError()
        }

        if mz_zip_reader_save_all(archiveHandle, (url.path as NSString).fileSystemRepresentation) != MZ_OK {
            throw FlattyExtractError()
        }
    }

    public static func validatePassword(url: URL, password: String?) throws -> Bool {
        if !url.isFileURL {
            throw FlattyInvalidURLError(url: url)
        }
        let archiveHandle: UnsafeMutablePointer<UnsafeMutableRawPointer?> = .allocate(capacity: 1)
        mz_zip_reader_create(archiveHandle)
        defer {
            if mz_zip_reader_is_open(archiveHandle) == MZ_OK {
                mz_zip_reader_close(archiveHandle)
            }
            mz_zip_reader_delete(archiveHandle)
        }

        if let password {
            mz_zip_reader_set_password(archiveHandle, password)
        }

        var result = MZ_OK
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path), let fileSize = attrs[.size] as? UInt64 {
            if fileSize < 20 * 1024 * 1024 {
                result = mz_zip_reader_open_file_in_memory(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            } else {
                result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            }
        } else {
            result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
        }
        if result != MZ_OK {
            throw FlattyCreateStreamError()
        }

        var err = mz_zip_reader_goto_first_entry(archiveHandle)
        if err != MZ_OK {
            throw FlattyCannotSeekToFirstEntry()
        }
        let fileInfo = UnsafeMutablePointer<UnsafeMutablePointer<mz_zip_file>?>.allocate(capacity: 1)
        defer { fileInfo.deallocate() }
        while err == MZ_OK {
            err = mz_zip_reader_entry_get_info(archiveHandle, fileInfo)
            if err != MZ_OK {
                throw FlattyReadEntryError()
            }
            guard let info = fileInfo.pointee?.pointee else {
                throw FlattyReadEntryError()
            }
            let encrypted = ((Int32(info.flag) & MZ_ZIP_FLAG_ENCRYPTED) != 0) ? true : false

            if encrypted {

                if mz_zip_reader_entry_open(archiveHandle) != MZ_OK {
                    return false
                }

                if mz_zip_reader_entry_close(archiveHandle) != MZ_OK {
                    return false
                }

                return true
            }

            err = mz_zip_reader_goto_next_entry(archiveHandle)
            if err != MZ_OK && err != MZ_END_OF_LIST {
                break
            }
        }

        return false
    }

    public static func isPasswordProtected(url: URL) throws -> Bool {
        if !url.isFileURL {
            throw FlattyInvalidURLError(url: url)
        }
        let archiveHandle: UnsafeMutablePointer<UnsafeMutableRawPointer?> = .allocate(capacity: 1)
        mz_zip_reader_create(archiveHandle)
        defer {
            if mz_zip_reader_is_open(archiveHandle) == MZ_OK {
                mz_zip_reader_close(archiveHandle)
            }
            mz_zip_reader_delete(archiveHandle)
        }

        var result = MZ_OK
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path), let fileSize = attrs[.size] as? UInt64 {
            if fileSize < 20 * 1024 * 1024 {
                result = mz_zip_reader_open_file_in_memory(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            } else {
                result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
            }
        } else {
            result = mz_zip_reader_open_file(archiveHandle, (url.path as NSString).fileSystemRepresentation)
        }
        if result != MZ_OK {
            throw FlattyCreateStreamError()
        }

        var err = mz_zip_reader_goto_first_entry(archiveHandle)
        if err != MZ_OK {
            throw FlattyCannotSeekToFirstEntry()
        }
        let fileInfo = UnsafeMutablePointer<UnsafeMutablePointer<mz_zip_file>?>.allocate(capacity: 1)
        defer { fileInfo.deallocate() }
        while err == MZ_OK {
            err = mz_zip_reader_entry_get_info(archiveHandle, fileInfo)
            if err != MZ_OK {
                throw FlattyReadEntryError()
            }
            guard let info = fileInfo.pointee?.pointee else {
                throw FlattyReadEntryError()
            }
            let encrypted = ((Int32(info.flag) & MZ_ZIP_FLAG_ENCRYPTED) != 0) ? true : false

            if encrypted {
                return true
            }

            err = mz_zip_reader_goto_next_entry(archiveHandle)
            if err != MZ_OK && err != MZ_END_OF_LIST {
                break
            }
        }

        return false
    }

    public static func getEntries(data: Data, password: String?) throws -> [FlattyEntry] {
        return try getEntries(password: password) { handle in
            let mem = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
            data.copyBytes(to: mem, count: data.count)
            let result = mz_zip_reader_open_buffer(handle, mem, Int32(data.count), 1)
            mem.deallocate()
            return result
        }
    }

    public static func getEntries(url: URL, password: String?) throws -> [FlattyEntry] {
        if !url.isFileURL {
            throw FlattyInvalidURLError(url: url)
        }
        return try getEntries(password: password) { handle in
            if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path), let fileSize = attrs[.size] as? UInt64 {
                if fileSize < 20 * 1024 * 1024 {
                    return mz_zip_reader_open_file_in_memory(handle, (url.path as NSString).fileSystemRepresentation)
                }
            }
            return mz_zip_reader_open_file(handle, (url.path as NSString).fileSystemRepresentation)
        }
    }

    private static func getEntries(password: String?, openFc: (UnsafeMutablePointer<UnsafeMutableRawPointer?>) -> Int32) throws -> [FlattyEntry] {
        let archiveHandle: UnsafeMutablePointer<UnsafeMutableRawPointer?> = .allocate(capacity: 1)
        mz_zip_reader_create(archiveHandle)
        defer {
            if mz_zip_reader_is_open(archiveHandle) == MZ_OK {
                mz_zip_reader_close(archiveHandle)
            }
            mz_zip_reader_delete(archiveHandle)
        }

        if openFc(archiveHandle) != MZ_OK {
            throw FlattyCreateStreamError()
        }

        var entries = [FlattyEntry]()

        if let password {
            mz_zip_reader_set_password(archiveHandle, password.cString(using: .utf8))
        }

        var err = mz_zip_reader_goto_first_entry(archiveHandle)
        if err != MZ_OK {
            throw FlattyCannotSeekToFirstEntry()
        }
        let fileInfo = UnsafeMutablePointer<UnsafeMutablePointer<mz_zip_file>?>.allocate(capacity: 1)
        defer { fileInfo.deallocate() }
        while err == MZ_OK {
            err = mz_zip_reader_entry_get_info(archiveHandle, fileInfo)
            if err != MZ_OK {
                throw FlattyReadEntryError()
            }
            guard let info = fileInfo.pointee?.pointee else {
                throw FlattyReadEntryError()
            }
            let ratio = info.uncompressed_size > 0 ? Float(info.compressed_size) * 100.0 / Float(info.uncompressed_size) : 0.0
            let encrypted = ((Int32(info.flag) & MZ_ZIP_FLAG_ENCRYPTED) != 0) ? true : false
            let modifiedDate = Date(timeIntervalSince1970: TimeInterval(info.modified_date))
            let createdDate = Date(timeIntervalSince1970: TimeInterval(info.creation_date))
            let externalFa = info.external_fa
            let internalFa = info.internal_fa
            let comment = info.comment != nil ? String(utf8String: info.comment) : nil
            let crc = info.crc
            let compressedSize = info.compressed_size
            let uncompressedSize = info.uncompressed_size
            guard let cFilename = info.filename, let filename = String(utf8String: cFilename) else {
                throw FlattyInvalidFilenameEntryError()
            }
            let compressionMethod = CompressionMethod.allCases.first(where: { $0.cValue == info.compression_method }) ?? .store
            var entryType: EntryType = .file
            if mz_zip_reader_entry_is_dir(archiveHandle) == MZ_OK {
                entryType = .dir
            } else if info.linkname != nil, let link = String(utf8String: info.linkname), !link.isEmpty {
                entryType = .symlink
            }
            let newEntry = FlattyEntry(filename: filename,
                                       ratio: ratio,
                                       compressedSize: compressedSize,
                                       uncompressedSize: uncompressedSize,
                                       compressionMethod: compressionMethod,
                                       crc: crc,
                                       internalAttributes: internalFa,
                                       externalAttributes: externalFa,
                                       encrypted: encrypted,
                                       modifiedDate: modifiedDate,
                                       createdData: createdDate,
                                       comment: comment,
                                       type: entryType)
            entries.append(newEntry)

            err = mz_zip_reader_goto_next_entry(archiveHandle)
            if err != MZ_OK && err != MZ_END_OF_LIST {
                break
            }
        }

        return entries
    }
}
