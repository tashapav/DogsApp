//
//  FavoritesView.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @State private var favoriteItems: [DogFactItem] = []
    @State private var isLoading = false
    
    let currentUser: User
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if favoriteItems.isEmpty {
                    Text("Нет избранных элементов")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                            ForEach(favoriteItems, id: \.self) { item in
                                
                                NavigationLink {
                                    DogDetailView(item: DogFactItemModel(fact: item.fact, imageUrl: item.imageUrl), currentUser: currentUser)
                                } label: {
                                    DogItemView(item: DogFactItemModel(fact: item.fact, imageUrl: item.imageUrl), currentUser: currentUser)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Избранное")
            .navigationBarItems(leading: logoutButton)
            .onAppear {
                loadFavorites()
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.dismiss(animated: true)
                        }
        }) {
            Text("Выйти")
                .foregroundColor(.red)
        }
    }
    
    private func loadFavorites() {
        print("fav")
        isLoading = true
        _ = CoreDataStack.shared.context
        
        if let favorites = currentUser.favoriteItems {
            print("eeeeeeee")
            favoriteItems = Array(favorites)
        } else {
            favoriteItems = []
        }
        
        isLoading = false
        print(favoriteItems)
    }
}

