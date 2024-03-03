//
//  CEWorkspaceFileService.swift
//  CodeEdit
//
//  Created by Abe Malla on 1/6/24.
//

import Foundation

// TODO: LOOK FOR withContentsOf AND FileManager

enum FileType {
    case unknown
    case file
    case directory
    /**
     * File is a symbolic link.
     * Note: even when the file is a symbolic link, you can test for
     * `FileType.File` and `FileType.Directory` to know the type of
     * the target the link points to.
     */
    case symbolicLink
}

struct FileStat {
    /// Type of file
    let type: FileType
    /// Last modification date
    let mtime: TimeInterval
    /// Creation date
    let ctime: TimeInterval
    /// Size of file in bytes
    let size: Int
    /// Represents a symbolic link
    let isSymbolicLink: Bool
    /// File is a symbolic link with a non existent target
    let isDangling: Bool
    // TODO: INCLUDE FILE PERMISSIONS
}

protocol FileCreateOptions {

}

protocol FileOverwriteOptions {

}

protocol FileAtomicWriteOptions {

}

protocol FileAtomicReadOptions {

}

protocol FileReadOptions {
    var atomic: Bool { get }
}

protocol FileReadStreamOptions: FileReadOptions {
    /// Where to begin reading in the file. If undefined, data will be read from the current file position.
    var position: Int? { get }
    /// Is an integer specifying how many bytes to read from the file. By default, all bytes will be read.
    var length: Int? { get }
    /// If the file size exceeds this size, an error will be thrown.
    var fileLimit: Int? { get }
}

protocol FileOpenOptions {

}

protocol FileAtomicOptions {
    var postfix: String { get }
}

struct FileSystemProviderCapabilities: OptionSet {
    let rawValue: Int32

    static let none                     = FileSystemProviderCapabilities([])
    static let fileReadWrite            = FileSystemProviderCapabilities(rawValue: 1 << 1)
    static let fileOpenReadWriteClose   = FileSystemProviderCapabilities(rawValue: 1 << 2)
    static let fileReadStream           = FileSystemProviderCapabilities(rawValue: 1 << 4)
    static let fileFolderCopy           = FileSystemProviderCapabilities(rawValue: 1 << 3)
    static let pathCaseSensitive        = FileSystemProviderCapabilities(rawValue: 1 << 10)
    static let readonly                 = FileSystemProviderCapabilities(rawValue: 1 << 11)
    static let trash                    = FileSystemProviderCapabilities(rawValue: 1 << 12)
    static let fileWriteUnlock          = FileSystemProviderCapabilities(rawValue: 1 << 13)
    static let fileAtomicRead           = FileSystemProviderCapabilities(rawValue: 1 << 14)
    static let fileAtomicWrite          = FileSystemProviderCapabilities(rawValue: 1 << 15)
    static let fileClone                = FileSystemProviderCapabilities(rawValue: 1 << 16)
}

protocol FileSystemProvider {
    var capabilities: FileSystemProviderCapabilities { get }

    func stat(resource: URL) async throws -> FileStat
    func mkdir(resource: URL) async throws
    func readdir(resource: URL) async throws -> [(String, FileAttributeType)]
    func delete(resource: URL) async throws

    func rename(from: URL, to: URL, overwrite: Bool) async throws
    func copy(from: URL, to: URL, opts: FileOverwriteOptions) async throws

    //    func readFile(resource: URL) async throws -> [UInt8]
    //    func writeFile(resource: URL, content: [UInt8], opts: FileWriteOptions) async throws
//    func readFileStream(resource: URL, opts: FileReadStreamOptions, token: CancellationToken) async throws

    func open(resource: URL, opts: FileOpenOptions) async throws -> FileHandle
    func close(fileHandle: FileHandle) async throws
    /// Returns how many bytes read
    func read(fileHandle: FileHandle, pos: Int, data: Data, offset: Int, length: Int) async throws -> Int
    /// Returns how many bytes written
    func write(fileHandle: FileHandle, pos: Int, data: Data, offset: Int, length: Int) async throws -> Int

    func cloneFile(from: URL, to: URL) async throws
}


protocol FileService {
    // TODO: EVENTS

    var provider: FileSystemProvider { get }

    func registerProvider(provider: FileSystemProvider)
    func hasCapabilities(capabilities: FileSystemProviderCapabilities) -> Bool
    func stat(resource: URL) async throws -> FileStat
    func exists(resource: URL) async throws -> Bool
    func readFile(resource: URL, options: FileReadStreamOptions) async throws -> Data
    // TODO: STREAMING
    // func readFileStream(resource: URL, options: FileReadStreamOptions) async throws -> Data
    func writeFile(resource: URL, content: Data, options: FileWriteOptions) async throws
    func move(source: URL, target: URL, overwrite: Bool) async throws -> FileStat
    /// Returns true if the move is possible. No changes on disk will be performed.
    func canMove(source: URL, target: URL, overwrite: Bool) async throws -> Bool
    func copy(source: URL, target: URL, overwrite: Bool) async throws -> FileStat
    /// Returns true if the copy is possible. No changes on disk will be performed.
    func canCopy(source: URL, target: URL, overwrite: Bool) async throws -> Bool
    func cloneFile(source: URL, target: URL) async throws
    func createFile(resource: URL, content: Data, overwrite: Bool) async throws -> FileStat
    /// Checks if a file can be created. No changes on disk will be performed.
    func canCreateFile(resource: URL, overwrite: Bool) async throws -> Bool
    func del(resource: URL) async throws
}

protocol FileSystemProviderWithFileReadWriteCapability: FileSystemProvider {
    func readFile(resource: URL) async throws -> Data
    func writeFile(resource: URL, content: Data, opts: FileWriteOptions) async throws
}

protocol FileSystemProviderWithFileFolderCopyCapability: FileSystemProvider {
    func copy(from: URL, to: URL, opts: FileOverwriteOptions) async throws
}

protocol FileSystemProviderWithFileCloneCapability: FileSystemProvider {
    func cloneFile(from: URL, to: URL) async throws
}

protocol FileSystemProviderWithOpenReadWriteCloseCapability: FileSystemProvider {
    func open(resource: URL, opts: FileOpenOptions) async throws -> FileHandle
    func close(fileHandle: FileHandle) async throws
    func read(fileHandle: FileHandle, pos: Int, data: Data, offset: Int, length: Int) async throws -> Int
    func write(fileHandle: FileHandle, pos: Int, data: Data, offset: Int, length: Int) async throws -> Int
}

protocol FileSystemProviderWithFileReadStreamCapability: FileSystemProvider {
//    func readFileStream(resource: URL, opts: FileReadStreamOptions, token: CancellationToken) async throws
}

protocol FileSystemProviderWithFileAtomicReadCapability: FileSystemProvider {
    func readFile(resource: URL, opts: FileAtomicReadOptions) async throws -> Data
    func shouldEnforceAtomicReadFile(resource: URL) async throws -> Bool
}

protocol FileSystemProviderWithFileAtomicWriteCapability: FileSystemProvider {
    func writeFile(resource: URL, contents: Data, opts: FileAtomicWriteOptions) async throws
    func shouldEnforceAtomicWriteFile(resource: URL) async throws -> FileAtomicOptions
}

struct DiskFileSystemProvider: FileSystemProvider {
    private let fileManager = FileManager.default

    var capabilities: FileSystemProviderCapabilities

    func stat(resource: URL) async throws -> FileStat {
        let resourceValues = try resource.resourceValues(
            forKeys: [.isSymbolicLinkKey, .fileSizeKey, .contentModificationDateKey, .creationDateKey]
        )

        // Check if it's a symbolic link
        if let isSymbolicLink = resourceValues.isSymbolicLink, isSymbolicLink {
            // Resolve symbolic link
            let resolvedPath = try fileManager.destinationOfSymbolicLink(atPath: resource.path)
            let resolvedURL = URL(fileURLWithPath: resolvedPath)

            do {
                // Stat the resolved path
                let resolvedResourceValues = try resolvedURL.resourceValues(
                    forKeys: [.fileSizeKey, .contentModificationDateKey, .creationDateKey]
                )
                return FileStat(
                    // TODO: SHOULD RETURN THE SPECIFIC FILE TYPE, NOT SYMLINK
                    type: .symbolicLink,
                    mtime: resolvedResourceValues.contentModificationDate?.timeIntervalSince1970 ?? 0,
                    ctime: resolvedResourceValues.creationDate?.timeIntervalSince1970 ?? 0,
                    size: resolvedResourceValues.fileSize ?? 0,
                    isSymbolicLink: true,
                    isDangling: false
                )
            } catch {
                // Symbolic link target doesn't exist
                let nsError = error as NSError
                if nsError.domain == NSCocoaErrorDomain && nsError.code == NSFileReadNoSuchFileError {
                    return FileStat(type: .unknown, mtime: 0, ctime: 0, size: 0, isSymbolicLink: true, isDangling: true)
                }
                throw error
            }
        } else {
            // Stat the file directly
            return FileStat(
                // TODO: SET PROPER TYPE
                type: .file,
                mtime: resourceValues.contentModificationDate?.timeIntervalSince1970 ?? 0,
                ctime: resourceValues.creationDate?.timeIntervalSince1970 ?? 0,
                size: resourceValues.fileSize ?? 0,
                isSymbolicLink: false,
                isDangling: false
            )
        }
    }

    func mkdir(resource: URL) async throws {
        // Ensure the URL is a file URL
        guard resource.isFileURL else {
            throw NSError(
                domain: NSCocoaErrorDomain,
                code: NSFileWriteUnsupportedSchemeError,
                userInfo: [NSLocalizedDescriptionKey: "The provided URL is not a file URL."]
            )
        }

        try await withCheckedThrowingContinuation { continuation in
            do {
                // Create the directory
                try fileManager.createDirectory(at: resource, withIntermediateDirectories: true, attributes: nil)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func readdir(resource: URL) async throws -> [(String, FileAttributeType)] {
        guard resource.isFileURL else {
            throw NSError(
                domain: NSCocoaErrorDomain,
                code: NSFileReadUnsupportedSchemeError,
                userInfo: [NSLocalizedDescriptionKey: "The provided URL is not a file URL."]
            )
        }

        let directoryPath = resource.path
        // TODO: RUN IN PARALLEL? PROCESS EACH FILE IN PARALLEL, VERIFY BETTER PERFORMANCE
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let fileNames = try fileManager.contentsOfDirectory(atPath: directoryPath)
                var result: [(String, FileAttributeType)] = []
                result.reserveCapacity(fileNames.count)

                for fileName in fileNames {
                    let filePath = (directoryPath as NSString).appendingPathComponent(fileName)
                    do {
                        let attributes = try fileManager.attributesOfItem(atPath: filePath)

                        if let fileType = attributes[.type] as? FileAttributeType {
                            // Check for symbolic link and resolve it
                            if fileType == .typeSymbolicLink {
                                let resolvedPath = try fileManager.destinationOfSymbolicLink(atPath: filePath)
                                let resolvedAttributes = try fileManager.attributesOfItem(atPath: resolvedPath)
                                if let resolvedFileType = resolvedAttributes[.type] as? FileAttributeType {
                                    result.append((fileName, resolvedFileType))
                                }
                            } else {
                                result.append((fileName, fileType))
                            }
                        }
                    } catch {
                        // TODO: LOG ERROR
                        continue
                    }
                }

                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func delete(resource: URL) async throws {
        try fileManager.removeItem(at: resource)
    }

    func rename(from: URL, to: URL, overwrite: Bool = false) async throws {
        // 1. Check if paths are the same
        // 2. Rename the file

//        fileManager.moveItem(at: <#T##URL#>, to: <#T##URL#>)

        // validateMoveCopy function
        // 1. If we have the PathCaseSensitive capability, make sure the resource isnt the same with a different case
    }

    func copy(from: URL, to: URL, opts: FileOverwriteOptions) async throws {
        // TODO:
    }

    func open(resource: URL, opts: FileOpenOptions) async throws -> FileHandle {
        return try FileHandle(forReadingFrom: resource)
    }

    func close(fileHandle: FileHandle) async throws {
        try fileHandle.close()
    }

    func read(fileHandle: FileHandle, pos: Int, data: Data, offset: Int, length: Int) async throws -> Int {
        // TODO: https://developer.apple.com/documentation/foundation/filehandle/asyncbytes
        let chunk = fileHandle.readData(ofLength: length)
        if dataChunk.isEmpty {
            break
        } else {
            data.append(chunk)
        }
    }

    func write(fileHandle: FileHandle, pos: Int, data: Data, offset: Int, length: Int) async throws -> Int {
        return 0
    }

    func cloneFile(from: URL, to: URL) async throws {

    }
}

protocol CancellationToken {
    var isCancellationRequested: Bool { get }
    // TODO: ADD EVENT
}

struct CodeEditFileService: FileService {
    var provider: FileSystemProvider

    func registerProvider(provider: FileSystemProvider) {
        self.provider = provider
    }

    func hasCapabilities(capabilities: FileSystemProviderCapabilities) -> Bool {
        return provider.capabilities.contains(capabilities)
    }

    func stat(resource: URL) async throws -> FileStat {
        return try await self.provider.stat(resource: resource)
    }

    func exists(resource: URL) async throws -> Bool {
        return try await self.provider.stat(resource: resource) != FileStat(type: .unknown, mtime: 0, ctime: 0, size: 0, isSymbolicLink: false, isDangling: false)
    }

    func readFile(resource: URL, options: FileReadStreamOptions) async throws -> Data {
        // TODO: SETUP CANCELLATION TOKEN
        if options.atomic {
            return try await self.readFileAtomic(resource: resource)
        }

        let chunkSize = 4096
        let fileHandle = await provider.open(resource: resource, opts: FileOpenOptions())
        defer {
            try? provider.close(fileHandle: fileHandle)
        }

        let data = Data()
        do {
            let bytesRead = 0
            while true {
                let chunksRead = try await provider.read(fileHandle: fileHandle, pos: options.position, data: data, offset: 0, length: chunkSize)
                bytesRead += chunksRead
                if chunksRead == 0 {
                    break
                }

                if bytesRead >= options.length ?? Int.max {
                    // TODO: PROPER ERROR HANDLING
                    break
                }
            }
        } catch {
            // TODO: LOGGING
            throw error
        }
        // return try await self.provider.readFile(resource: resource)
        return data
    }

    private func readFileAtomic(resource: URL, options: FileAtomicReadOptions) async throws -> Data {
        let data = try Data(contentsOf: fileURL, options: .alwaysMapped)
        return data
    }

    func writeFile(resource: URL, content: Data, options: FileWriteOptions) async throws {
        // try await self.provider.writeFile(resource: resource, content: content, opts: options)
    }

    func move(source: URL, target: URL, overwrite: Bool) async throws -> FileStat {
        try await self.provider.rename(from: source, to: target, overwrite: overwrite)
        return try await self.provider.stat(resource: target)
    }

    func canMove(source: URL, target: URL, overwrite: Bool) async throws -> Bool {
        return true
    }

    func copy(source: URL, target: URL, overwrite: Bool) async throws -> FileStat {
        try await self.provider.copy(from: source, to: target, opts: FileOverwriteOptions())
        return try await self.provider.stat(resource: target)
    }

    func canCopy(source: URL, target: URL, overwrite: Bool) async throws -> Bool {
        return true
    }

    func cloneFile(source: URL, target: URL) async throws {
        try await self.provider.cloneFile(from: source, to: target)
    }

    func createFile(resource: URL, content: Data, overwrite: Bool) async throws -> FileStat {
        try await self.provider.writeFile(resource: resource, content: content, opts: FileWriteOptions())
        return try await self.provider.stat(resource: resource)
    }
}
