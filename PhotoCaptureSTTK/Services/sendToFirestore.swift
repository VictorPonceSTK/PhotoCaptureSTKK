//
//  sendToFirestore.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 22/02/24.
//

import Foundation
import FirebaseFirestore

func uploadURLsToFirestore(faces: [String: URL], brand: String, completion: @escaping (Result<String, Error>) -> Void) {
    let db = Firestore.firestore()
    let collectionRef = db.collection("faces")
    
    var data = faces.mapValues { $0.absoluteString }
    data["brand"] = brand // Include the brand information in the data
    
    // Use addDocument to automatically generate document ID
    collectionRef.addDocument(data: data) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success("Successfully added to Firestore"))
        }
    }
}


