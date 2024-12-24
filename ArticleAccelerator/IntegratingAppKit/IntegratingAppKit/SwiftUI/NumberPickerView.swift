/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct NumberPickerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Label("NumberPickerView", systemImage: "testtube.2")
                .font(.title3)
            ZStack {
                GradientViewWrapper(colors: gradientColors)
                CardViewWrapper(chosenNumbers: $chosenNumbers, skippedNumbers: $skippedNumbers, color: fillColor)
                    .padding()
            }
            .frame(minHeight: 120)
            Text("Instructions: Click to choose a number. Option click to skip a number.")
                .font(.headline)
                .padding(.bottom, 4)
            HStack {
                Text("You chose:")
                if chosenNumbers.count > 0 {
                    ForEach(chosenNumbers.sorted()) { number in
                        Text(number.description)
                    }
                }
            }
            HStack {
                Text("You skipped:")
                if skippedNumbers.count > 0 {
                    ForEach(skippedNumbers.sorted()) { number in
                        Text(number.description)
                    }
                }
            }
        }
        .padding()
    }
    
    @State private var chosenNumbers: Set<Int> = []
    @State private var fillColor: Color = .bigSolid
    @State private var gradientColors: [Color] = [.gradientBegin, .gradientEnd]
    @State private var skippedNumbers: Set<Int> = []
    @State private var textTest: String = ""    
}

#Preview {
    NumberPickerView()
}

extension Int: Identifiable {
    public var id: Self { self }
}
