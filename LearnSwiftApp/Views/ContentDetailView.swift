//
//  ContentDetailView.swift
//  LearnSwiftApp
//
//  Created by iMac on 27.10.21..
//

import SwiftUI
import AVKit  // contains a video player

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            // Only to show a video if we get a valid URL
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
        }
        // TDescription
        CodeTextView()
            
        // Next lesson button
        
        // Show next lesson button, only if there is a next lesson
        if model.hasNextLesson() {
            
            Button(action: {
            
            // Advance the lesson
            model.hasNextLesson()
                
            }, label: {
                ZStack {
            
            Rectangle()
                .frame(height: 48)
                .foregroundColor(Color.green)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Text("Next lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                    }
                })
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
