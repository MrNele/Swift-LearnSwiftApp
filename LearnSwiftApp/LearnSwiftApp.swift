//
//  LearnSwiftAppApp.swift
//  LearnSwiftApp
//
//  Created by iMac on 20.10.21..
//

import SwiftUI

@main
struct LearnSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
