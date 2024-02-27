//
//  sendToStorage.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 22/02/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
func sendToStorage(PhotoBundle: PhotoBundle, completion: @escaping (Result<String, Error>) -> Void) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentDate = Date()
    let dateString = dateFormatter.string(from: currentDate)
    
    // Create a root reference - make sure 'storage' is initialized properly
    let storageRef = Storage.storage().reference()

    var downloadURLs: [String:URL] = [:]

    let group = DispatchGroup()

    for imageData in PhotoBundle.images {
        let photoRef = storageRef.child("\(dateString)/\(imageData.face())-Color.jpg")
        let depthRef = storageRef.child("\(dateString)/\(imageData.face())-Depth.jpg")
        send(image: imageData.image!, photoRef: photoRef,name:"\(imageData.face())-Color")
        send(image: imageData.depthImage!, photoRef: depthRef,name:"\(imageData.face())-Depth")
       
    }

    group.notify(queue: .main) {
        if downloadURLs.isEmpty {
            completion(.failure(NSError(domain: "DownloadURL Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve download URLs"])))
        } else {
            uploadURLsToFirestore(faces: downloadURLs,brand:PhotoBundle.brand){ resp in
                completion(resp)
            }
        }
    }
    
    func send(image: UIImage, photoRef:StorageReference,name:String){
        group.enter()
        let uploadTask = photoRef.putData((image.jpegData(compressionQuality: 0.8))!, metadata: nil) { (metadata, error) in
            defer {
                group.leave()
            }
            
            if let error = error {
                completion(.failure(error))
            } else {
                // Retrieve download URL
                photoRef.downloadURL { (url, error) in
                    if let url = url {
                        downloadURLs[name] = url
                    }
                }
            }
        }
    }
    
}



