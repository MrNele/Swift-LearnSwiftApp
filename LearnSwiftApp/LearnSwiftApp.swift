//
//  LearnSwiftAppApp.swift
//  LearnSwiftApp
//
//  Created by iMac on 20.10.21..
//

import SwiftUI
import FirebaseCore

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}


