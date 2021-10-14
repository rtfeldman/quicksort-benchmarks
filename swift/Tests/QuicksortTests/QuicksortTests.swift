import XCTest

import Quicksort

final class QuicksortTests: XCTestCase {
    func testSpeed() {
        var unsorted = [3,86,827,4,11,5565,6827,1783,885,3,35,2]
        let sorted = unsorted.sorted()
        quicksort(&unsorted)
        XCTAssertEqual(unsorted, sorted)
    }
}
