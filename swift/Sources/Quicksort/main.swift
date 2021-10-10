import Foundation
import ArgumentParser

struct Quicksort: ParsableCommand {
    @Argument() var unsortedFilename: String
    @Argument() var sortedFilename: String
    
    private var fm: FileManager { return FileManager.default }
    private var pwd: URL {
        return URL(fileURLWithPath: fm.currentDirectoryPath)
    }
    
    func run() throws {
        let unsortedPath = URL(fileURLWithPath: unsortedFilename, relativeTo: pwd)
        let sortedPath = URL(fileURLWithPath: sortedFilename, relativeTo: pwd)
        guard fm.fileExists(atPath: unsortedPath.path) else {
            throw Error.inputFileMissing(file: unsortedFilename)
        }
        guard fm.fileExists(atPath: sortedPath.path) else {
            throw Error.inputFileMissing(file: sortedFilename)
        }
    }
    
    enum Error: Swift.Error, LocalizedError {
        case inputFileMissing(file: String)
        
        var errorDescription: String? {
            switch self {
            case .inputFileMissing(let fileName):
                return "File missing for: \(fileName)"
            }
        }
    }
}

Quicksort.main()
