//
//  TestView.swift
//  LearnSwiftApp
//
//  Created by iMac on 29.10.21..
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model: ContentModel
    var body: some View {
         
        if model.currentQuestion != nil {
            
            VStack {
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                // Question
                CodeTextView()
                // Answers
                
                // Button
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // If test hasn't loaded because of IoS 14.5 and higher
            ProgressView() // it will gonna trigger onAppears in HomeView in Test Card, file HomeView
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
