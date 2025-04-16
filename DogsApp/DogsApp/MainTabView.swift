//
//  MainTabView.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import SwiftUI
import CoreData

struct MainTabView: View {
    @State private var selectedTab = 0
    let currentUser: User
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(currentUser: currentUser)
                .tabItem {
                    Image(systemName: "house")
                    Text("Главная")
                }
                .tag(0)
            
            FavoritesView(currentUser: currentUser)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Избранное")
                }
                .tag(1)
        }
        .accentColor(.blue)
    }
}
