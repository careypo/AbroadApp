//
//  Review.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/29/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import Foundation
import MapKit
import Firebase
import CoreLocation

class Review {
    var locationCity: String
    var bestSite: String
    var why: String
    var numberOfReviews: Int
    var createdOn: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["locationCity": locationCity, "bestSite": bestSite, "why": why, "numberOfReviews": numberOfReviews, "createdOn": createdOn, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    
    init(locationCity: String, bestSite: String, why: String, numberOfReviews: Int, createdOn: String, postingUserID: String, documentID: String) {
        self.locationCity = locationCity
        self.bestSite = bestSite
        self.why = why
        self.numberOfReviews = numberOfReviews
        self.createdOn = createdOn
        self.postingUserID = postingUserID
        self.documentID = ""
    }
    
    convenience init() {
        self.init(locationCity: "", bestSite: "", why: "", numberOfReviews: 0, createdOn: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let locationCity = dictionary["locationCity"] as! String? ?? ""
        let bestSite = dictionary["bestSite"] as! String? ?? ""
        let why = dictionary["why"] as! String? ?? ""
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let createdOn = dictionary["createdOn"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        
        self.init(locationCity: locationCity, bestSite: bestSite, why: why, numberOfReviews: numberOfReviews, createdOn: createdOn, postingUserID: postingUserID, documentID: documentID)
    }
    
    // NOTE: If you keep the same programming conventions (e.g. a calculated property .dictionary that converts class properties to String: Any pairs, the name of the document stored in the class as .documentID) then the only thing you'll need to change is the document path (i.e. the lines containing "spots" below.
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("reviews").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    
}
