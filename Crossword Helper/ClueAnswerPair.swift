import Foundation

public class ClueAnswerPair {

    var answer: String
    var clue: String
    var answerLength: Int
    
    init(answer: String, clue: String, answerLength: Int) {
        self.answer = answer
        self.clue = clue
        self.answerLength = answerLength
    }
}
