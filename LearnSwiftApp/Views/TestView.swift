//
//  TestView.swift
//  LearnSwiftApp
//
//  Created by iMac on 29.10.21..
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    
    // @State var selectedAnswerIndex = -1
    @State var selectedAnswerIndex:Int?
    @State var submitted = false
    @State var numCorrect = 0
    @State var showResults = false
    
    var body: some View {
        
        if model.currentQuestion != nil &&
            showResults == false {
            
            VStack (alignment: .leading) {
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self)   { index in
                          
                            Button {
                                // When the button is tapped, it tracks the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                                ZStack {
                                
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white )
                                            .frame(height: 48)
                                    }
                                    else {
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex &&
                                            index == model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the right answer
                                            // Shows a green background
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                        }
                                        else if index == selectedAnswerIndex &&
                                                    index != model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the wrong answer
                                            // Shows a red background                                   ////////////////////////////////////
                                            RectangleCard(color: Color.red)
                                                .frame(height: 48)
                                        }
                                        else if index == model.currentQuestion!.correctIndex {

                                            // This button is the correct answer
                                            // Shows a green background
                                           RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                       }
                                        else {
                                            RectangleCard(color: Color.white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                                
                                
                            }
                            .disabled(submitted)
                            
                        }
                    }
                    
                    
                    
                    .accentColor(.black)
                    .padding()
                }
                
                // Submit Button
                Button {
                    
                    // Checks if answer has been submitted
                    if submitted ==  true {
                        
                        // Check if it's the last question
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            
                            // Shows the results
                            showResults = true
                        }
                        else {
                            // Answer shas already been submitted, move to next question
                            model.nextQuestion()
                            
                            // Reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                    }
                    else {
                        // Submits the answer

                        // Changes submitted state to true
                        submitted = true
                        
                        // Checks the answer and increment the counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                   
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text(buttonText)
                            .bold()
                            .foregroundColor(Color.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            
        }
        else if showResults == true{
            // if current question is nil, we show the result view
            TestResultView(numCorrect: numCorrect)
        }        
        else {
            // If test hasn't loaded because of IoS 14.5 and higher
            ProgressView() // it will gonna trigger onAppears in HomeView in Test Card, file HomeView
        }
    }
    
    var buttonText: String {
        
        // Checks if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // This is the last quesition
                return "Finish"
            }
            else {
                // there is a next question
                return "Next"                
            }
        }
        else {
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

