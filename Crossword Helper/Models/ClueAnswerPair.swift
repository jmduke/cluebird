import Foundation
import SQLite

public class ClueAnswerPair {

    var answer: String
    var clue: String
    var answerLength: Int
    
    init(answer: String, clue: String, answerLength: Int) {
        self.answer = answer
        self.clue = clue
        self.answerLength = answerLength
    }
    
    static let table = Table("clues")
    
    struct Columns {
        let clue = Expression<String>("clue")
        let answer = Expression<String>("answer")
        let answerLength = Expression<Int>("answerLength")
    }
    static let columns = Columns()
    
    convenience init(row: Row) {
        self.init(
            answer: row[ClueAnswerPair.columns.answer],
            clue: row[ClueAnswerPair.columns.clue],
            answerLength: row[ClueAnswerPair.columns.answerLength]
        )
    }
}
