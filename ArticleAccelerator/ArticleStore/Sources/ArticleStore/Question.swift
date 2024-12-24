// See LICENSE folder for this sample’s licensing information.

import Foundation

/// A knowledge check question.
public struct Question: Codable, Hashable {
    /// A prompt for the learner.
    public let prompt: String
    /// Choices from which the learner can choose.
    public let choices: [Choice]
    
    /// A potential answer for a question.
    public struct Choice: Codable, Hashable {
        /// A unique identifier describing this choice.
        public let id: String
        /// A flag indicating if this choice correctly answers the question.
        public let isCorrect: Bool
        /// The text of this choice.
        public let possibleAnswer: String
        /// Remediation to show the learner once they've picked this choice.
        public let justification: String
    }
}
