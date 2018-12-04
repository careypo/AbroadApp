//
//  Photo.swift
//  FinalAppProject
//
//  Created by Paige Carey on 12/3/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String // Universal Unique Identifier
    var dictionary: [String: Any] {
        return ["description" : description, "postedBy" : postedBy, "date" : date]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy  = dictionary["postedBy"] as! String? ?? ""
        let date = dictionary["date"] as! Date? ?? Date()
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, documentUUID: "")
        
    }
    
    
    func saveData(review: Review, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        //convert photo.image to data type so it can be saved by Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("***ERROR could not convert image to data format")
            return completion(false)
        }
        
        let uploadMetaData  = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        
        documentUUID = UUID().uuidString //generate unique ID to use for the photo image's name
        // create a ref to upload storage to review.documentID's folder (bucket), with the name we created.
        let storageRef = storage.reference().child(review.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) {metadata, error in
            guard error == nil else {
                print("*** ERROR during .putData storage upload for reference \(storageRef). Error: \(error!.localizedDescription)")
                return
            }
            print("upload worked! Metadata is \(metadata!)")
            
        }
        
        uploadTask.observe(.success) { (snapshot) in
            //create a dictionary representing data we want saved
            let dataToSave = self.dictionary
            //this will either create a new doc at DocumentUUID or update the existing doc with that name
            let ref = db.collection("reviews").document(review.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR updating document \(self.documentUUID) in review \(review.documentID) \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
                
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("*** ERROR : upload task for file \(self.documentUUID) failed in spot \(review.documentID)")
            }
            return completion(false)
        }
        
        
    }
}
