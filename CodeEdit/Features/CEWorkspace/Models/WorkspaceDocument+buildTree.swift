//
//  WorkspaceDocument+buildTree.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 20/06/2023.
//

import Foundation

extension WorkspaceDocument {
    @MainActor
    func buildFileTree(root: URL) {
        buildFileTreeTask?.cancel()
        buildFileTreeTask = Task.detached { [weak self] in
            guard let self else { return }
            let tree = try await buildingFileTree(root: root, ignoring: ignoredResources)
            await MainActor.run { [weak self] in
                self?.fileTree = tree
                self?.onRefresh?()
            }
        }
    }

    nonisolated func buildingFileTree(root: URL, ignoring: Set<Ignored>) async throws -> any Resource {
        let fileProperties: Set<URLResourceKey> = [.isRegularFileKey, .isDirectoryKey, .isSymbolicLinkKey, .nameKey, .fileResourceIdentifierKey]
        let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: Array(fileProperties))

        guard let enumerator else { throw FileManagerError.rootFileEnumeration }

        let rootFolder = try Folder(url: root)

        var folderStack = [rootFolder]
        var currentLevel = 1
        var possibleNewFolder: Folder?

        for case let url as URL in enumerator {
            guard !Task.isCancelled else { throw CancellationError() }
            let properties = try url.resourceValues(forKeys: fileProperties)

            let name = properties.name!
            let isFile = properties.isRegularFile!
            let isFolder = properties.isDirectory!
            let isSymLink = properties.isSymbolicLink!

            let level = enumerator.level

            if level < currentLevel {
                folderStack.removeLast(currentLevel - level)
                currentLevel = level
            } else if level > currentLevel, let newCurrent = possibleNewFolder {
                folderStack.append(newCurrent)
                possibleNewFolder = nil
                currentLevel += 1
            }

            guard !ignoring.contains(.file(name: name)) && !ignoring.contains(.url(url)) else {
                continue
            }

            guard !ignoring.contains(.folder(name: name)) else {
                enumerator.skipDescendants()
                continue
            }

            let resource: any Resource
            let currentFolder = folderStack.last!

            if isFile {
                resource = try File(url: url, name: name)
            } else if isFolder {
                let newFolder = try Folder(url: url)
                resource = newFolder
                possibleNewFolder = newFolder
            } else if isSymLink {
                resource = SymLink(url: url, name: name)
            } else {
                continue
            }

            resource.parentFolder = currentFolder
            currentFolder.children.append(resource)
        }

        guard !Task.isCancelled else { throw CancellationError() }
        return rootFolder
    }
}