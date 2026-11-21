import Foundation

// String splitting reference:
// https://developer.apple.com/documentation/foundation/nsstring

// Constants for array indices
let linesIndex = 0
let wordsIndex = 1
let charsIndex = 2
let longestIndex = 3
let statsSize = 4

/// Analyzes an array of lines and returns file statistics in an array.
/// - Parameter lines: An array of strings representing lines in the file.
/// - Returns: An integer array [lines, words, characters, longestWordLength].
func analyzeFile(lines: [String]) -> [Int] {
    var stats = Array(repeating: 0, count: statsSize)
    stats[linesIndex] = lines.count

    var totalWords = 0
    var totalChars = 0
    var longestWord = 0

    for line in lines {
        totalChars += line.count
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            let words = trimmed.components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }
            totalWords += words.count
            for word in words where word.count > longestWord {
                longestWord = word.count
            }
        }
    }

    stats[wordsIndex] = totalWords
    stats[charsIndex] = totalChars
    stats[longestIndex] = longestWord
    return stats
}

/// Formats the statistics array and writes the report to an output file.
/// - Parameters:
///   - outputPath: The destination file path.
///   - stats: The array containing computed file statistics.
func writeResults(outputPath: String, stats: [Int]) throws {
    let reportLines = [
        "File Statistics Report (Swift)",
        "------------------------------",
        "Total Lines: \(stats[linesIndex])",
        "Total Words: \(stats[wordsIndex])",
        "Total Characters: \(stats[charsIndex])",
        "Longest Word Length: \(stats[longestIndex])"
    ]
    let reportText = reportLines.joined(separator: "\n") + "\n"
    let outputURL = URL(fileURLWithPath: outputPath)
    try reportText.write(to: outputURL, atomically: true, encoding: .utf8)
}

/// Main execution block
func main() {
    let args = CommandLine.arguments
    let inputPath = args.count > 1 ? args[1] : "input.txt"
    let outputPath = "output.txt"

    do {
        let inputURL = URL(fileURLWithPath: inputPath)
        let content = try String(contentsOf: inputURL, encoding: .utf8)
        let normalized = content.replacingOccurrences(of: "\r\n", with: "\n")

        var lines: [String] = []
        if !normalized.isEmpty {
            lines = normalized.components(separatedBy: "\n")
            if lines.last == "" {
                lines.removeLast()
            }
        }

        let stats = analyzeFile(lines: lines)

        print("Language: Swift")
        print("File Analyzed: \(inputPath)")
        print("Total Lines: \(stats[linesIndex])")
        print("Total Words: \(stats[wordsIndex])")
        print("Total Characters: \(stats[charsIndex])")
        print("Longest Word Length: \(stats[longestIndex])")

        try writeResults(outputPath: outputPath, stats: stats)
        print("Results saved to \(outputPath)")
    } catch {
        print("Error processing file: \(error.localizedDescription)")
    }
}

main()