//
//  APIService.swift
//  DogsApp
//
//  Created by pavlovanv on 14.04.2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchDogFacts(count: Int, completion: @escaping ([String]?, Error?) -> Void) {
        let urlString = "https://dog-facts-api.herokuapp.com/api/v1/resources/dogs?number=\(count)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
        
            do {
                //let facts = try JSONDecoder().decode([DogFact].self, from: data)
                //let factTexts = facts.compactMap { $0.fact }
                var factTexts = [String]()
                    for _ in 0..<count {
                        factTexts.append("amazing fact")
                    }

                completion(factTexts, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchDogImages(count: Int, completion: @escaping ([String]?, Error?) -> Void) {
        var images = [String]()
        let group = DispatchGroup()
        
        for _ in 0..<count {
            group.enter()
            let urlString = "https://dog.ceo/api/breeds/image/random"
            guard let url = URL(string: urlString) else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                defer { group.leave() }
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(DogImageResponse.self, from: data)
                    images.append(response.message)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion(images, nil)
        }
    }
    
    func fetchDogItems(count: Int, completion: @escaping ([DogFactItemModel]?, Error?) -> Void) {
        
        fetchDogFacts(count: count) { facts, factsError in
            if let factsError = factsError {
                completion(nil, factsError)
                return
            }
            
            self.fetchDogImages(count: count) { images, imagesError in
                if let imagesError = imagesError {
                    completion(nil, imagesError)
                    return
                }
                
                print("1")
                guard let facts = facts, let images = images else {
                    completion(nil, NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No facts or images"]))
                    return
                }
                print("2")
                let minCount = min(facts.count, images.count)
                var items = [DogFactItemModel]()
                
                for i in 0..<minCount {
                    items.append(DogFactItemModel(fact: facts[i], imageUrl: images[i]))
                    print(facts[i], images[i])
                }
                
                completion(items, nil)
            }
        }
    }
}

struct DogFact: Codable {
    let fact: String
}

struct DogImageResponse: Codable {
    let message: String
    let status: String
}

struct DogFactItemModel: Identifiable, Hashable {
    let id = UUID()
    let fact: String
    let imageUrl: String
}
