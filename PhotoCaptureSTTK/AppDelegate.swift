//
//  Delegate.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 22/02/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseCore

let db = Firestore.firestore()
let storage = Storage.storage()

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Your other didFinishLaunchingWithOptions code here
        
        return true
    }
}
