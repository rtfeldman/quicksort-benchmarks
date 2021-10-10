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
        
        var unsortedNumbers = try String(contentsOf: unsortedPath)
            .split(separator: ",")
            .map { (input: String.SubSequence) throws -> Int in
                guard let num = Int(input) else { throw Error.malformedValue(String(input)) }
                return num
            }
        
        let formattedCount = NumberFormatter.localizedString(
            from: NSNumber(value: unsortedNumbers.count),
            number: .decimal)
        
        let startTime = CFAbsoluteTimeGetCurrent()
        quickSort(input: &unsortedNumbers)
        let elapsed  = (CFAbsoluteTimeGetCurrent() - startTime) * 1000

        print("Finished quicksorting \(formattedCount) numbers in \(elapsed)ms")
    }
    
    enum Error: Swift.Error, LocalizedError {
        case inputFileMissing(file: String)
        case malformedValue(_: String)
        
        var errorDescription: String? {
            switch self {
            case .inputFileMissing(let fileName):
                return "File missing for: \(fileName)"
            case .malformedValue(let value):
                return "Non integer value found: \(value)"
            }
        }
    }
}

func quickSort<T: Comparable>(input: inout [T]) {
    input.sort()
}

Quicksort.main()
