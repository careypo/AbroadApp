//
//  Reviews.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/29/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray = [Review]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        
        db.collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error: adding the snapshot listener")
                return completed()
            }
            self.reviewArray = []
            //there are querysnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}
