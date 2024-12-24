// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct QuestionView: View {
    let question: Question
    let isComplete: () -> Bool
    let correctAnswerAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: design.verticalSpacing) {
            Text("Check your understanding")
                .font(design.titleFont)
            Text(LocalizedStringKey(question.prompt))
                .font(design.promptFont)
                .padding(design.promptPadding)
            Picker(selection: $selectedChoice, label: Text("")) {
                ForEach(question.choices) { choice in
                    Text(LocalizedStringKey(choice.possibleAnswer))
                        .tag(Optional(choice))
                        .font(design.choiceFont)
                }
            }
            .disabled(isComplete())
            .pickerStyle(.radioGroup)
            .onAppear {
                if isComplete() {
                    selectedChoice = question.choices.first(where: { $0.isCorrect })
                }
            }
            if let justification {
                Text(justification)
                    .font(design.justificationFont)
                    .padding(design.promptPadding)
            }
            Text(instruction)
                .padding(design.promptPadding)
            if !isComplete() {
                Button("Submit") {
                    assessResponse()
                }
            }
        }
    }
    
    @State private var selectedChoice: Question.Choice?
    @State private var justification: String?

    private var instruction: String {
        isComplete() ? "You've completed this article." : "Choose the best answer from the list above."
    }

    private func assessResponse() {
        justification = selectedChoice?.justification
        if selectedChoice?.isCorrect == true {
            correctAnswerAction()
        }
    }
}

#Preview {
    QuestionView(question: .sample, isComplete: { false }, correctAnswerAction: { })
        .padding()
}

fileprivate typealias design = Design.Article.Question
