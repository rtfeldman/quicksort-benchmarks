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
        
        var unsortedNumbers = try numbers(from: unsortedPath)
        
        let formattedCount = NumberFormatter.localizedString(
            from: NSNumber(value: unsortedNumbers.count),
            number: .decimal)
        
        let startTime = DispatchTime.now().uptimeNanoseconds
        quicksort(&unsortedNumbers)
        let elapsed  = Double(DispatchTime.now().uptimeNanoseconds - startTime) / 1e+6
        
        let sortedNumbers = try numbers(from: sortedPath)
        guard sortedNumbers == unsortedNumbers else {
            throw Error.incorrectOutput
        }
        
        print("Finished quicksorting \(formattedCount) numbers in \(elapsed)ms")
    }
    
    private func numbers(from file: URL) throws -> [Int] {
        try String(contentsOf: file)
            .split(separator: ",")
            .map { (input: String.SubSequence) throws -> Int in
                guard let num = Int(input) else { throw Error.malformedValue(String(input)) }
                return num
            }
    }
    
    // MARK: - Errors
    
    enum Error: Swift.Error, LocalizedError {
        case inputFileMissing(file: String)
        case malformedValue(_: String)
        case incorrectOutput
        
        var errorDescription: String? {
            switch self {
            case .inputFileMissing(let fileName):
                return "File missing for: \(fileName)"
            case .malformedValue(let value):
                return "Non integer value found: \(value)"
            case .incorrectOutput:
                return "Quicksort did not produce the expected sorted numbers!"
            }
        }
    }
}

// MARK: - Run

Quicksort.main()

// MARK: - Quicksort Functions

public func quicksort<T: Comparable>(_ input: inout [T]) {
    quicksortHelper(&input, low: input.startIndex, high: input.count - 1)
}

private func quicksortHelper<T: Comparable>(_ input: inout [T], low: Int, high: Int) {
    guard low < high else { return }
    
    let partitionIndex = partition(&input, pivot: high, low: low, high: high)
    quicksortHelper(&input, low: low, high: partitionIndex - 1)
    quicksortHelper(&input, low: partitionIndex + 1, high: high)
}

private func partition<T: Comparable>(_ input: inout [T], pivot: Int, low: Int, high: Int) -> Int {
    var partitionIndex = low
    
    for iter in low..<high {
        guard input[iter] < input[pivot] else { continue }
        input.swapAt(iter, partitionIndex)
        partitionIndex += 1
    }
    
    input.swapAt(high, partitionIndex)
    return partitionIndex
}
