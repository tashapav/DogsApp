//
//  HomeView.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var dogItems: [DogFactItemModel] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let currentUser: User
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                            ForEach(dogItems) { item in
                                NavigationLink {
                                    DogDetailView(item: DogFactItemModel(fact: item.fact, imageUrl: item.imageUrl), currentUser: currentUser)
                                } label: {
                                    DogItemView(item: item, currentUser: currentUser)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
                
                Button("Загрузить еще") {
                    loadMoreItems()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom)
            }
            .navigationTitle("Главная")
            .navigationBarItems(leading: logoutButton)
            .alert("Ошибка", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                if dogItems.isEmpty {
                    loadMoreItems()
                }
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            // Возвращаемся к экрану авторизации
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.dismiss(animated: true)
                        }
        }) {
            Text("Выйти")
                .foregroundColor(.red)
        }
    }
    
    private func loadMoreItems() {
        isLoading = true
        APIService.shared.fetchDogItems(count: 10) { items, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            if let items = items {
                dogItems.append(contentsOf: items)
            }
        }
    }
}

struct DogItemView: View {
    let item: DogFactItemModel
    let currentUser: User
    
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 150, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 150, height: 150)
                @unknown default:
                    EmptyView()
                }
            }
            
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .onAppear {
            checkIfFavorite()
        }
    }
    
    private func checkIfFavorite() {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<DogFactItem> = DogFactItem.fetchRequest()
        request.predicate = NSPredicate(format: "imageUrl == %@", item.imageUrl)
        
        if let existingItem = try? context.fetch(request).first {
            //print("aaaaaPomogite")
            //print(currentUser.favoriteItems?.contains(existingItem))
            //print(existingItem.fact)//?.contains(currentUser))
            //isFavorite = existingItem.favoritedBy?.contains(currentUser) ?? false
            isFavorite = currentUser.favoriteItems?.contains(existingItem) ?? false
        } else {
            isFavorite = false
        }
    }
    
    private func toggleFavorite() {
        let context = CoreDataStack.shared.context
        let itemEntity = DogFactItem.createOrFind(fact: item.fact, imageUrl: item.imageUrl, context: context)
        
        if isFavorite {
            currentUser.removeFromFavoriteItems(itemEntity)
        } else {
            currentUser.addToFavoriteItems(itemEntity)
        }
        
        CoreDataStack.shared.saveContext()
        isFavorite.toggle()
    }
}

