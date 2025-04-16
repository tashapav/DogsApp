//
//  DogDetailView.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import SwiftUI
import CoreData

struct DogDetailView: View {
    let item: DogFactItemModel
    let currentUser: User
    
    @State private var isFavorite: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding()
            
            Text(item.fact)
                .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: backButton,
            trailing: favoriteButton
        )
        .onAppear {
            checkIfFavorite()
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Назад")
            }
        }
    }
    
    private var favoriteButton: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
        }
    }
    
    private func checkIfFavorite() {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<DogFactItem> = DogFactItem.fetchRequest()
        request.predicate = NSPredicate(format: "imageUrl == %@", item.imageUrl)
        
        if let existingItem = try? context.fetch(request).first {
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
