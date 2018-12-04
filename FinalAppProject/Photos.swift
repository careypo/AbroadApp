//
//  Photos.swift
//  FinalAppProject
//
//  Created by Paige Carey on 12/3/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(review: Review, completed: @escaping () -> ()) {
        guard review.documentID != "" else {
            return
        }
        let storage = Storage.storage()
        db.collection("reviews").document(review.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener")
                return completed()
            }
            self.photoArray = []
            var loadAttempts = 0
            let storageRef = storage.reference().child(review.documentID)

            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentUUID = document.documentID
                self.photoArray.append(photo)
                
                // loading in firebase storage images
                let photoRef = storageRef.child(photo.documentUUID)
                photoRef.getData(maxSize: 25 * 1025 * 1025)  { data, error in
                    if let error = error {
                        print("*** ERROR: error occurred while reading data from file ref \(photoRef) \(error.localizedDescription)")
                        loadAttempts += 1
                        if loadAttempts >= (querySnapshot!.count) {
                            return completed()
                        }
                    } else {
                        let image = UIImage(data: data!)
                        photo.image = image!
                        loadAttempts += 1
                        if loadAttempts >= (querySnapshot!.count) {
                            return completed()
                        }
                    }
                    
                }
                
                
            }
        }
    }
}

