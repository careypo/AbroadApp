//
//  ReviewViewController.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/29/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class ReviewViewController: UIViewController {

    @IBOutlet weak var locationCityField: UITextField!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var bestSiteField: UITextField!
    @IBOutlet weak var whyField: UITextView!
    
    var review: Review!
    var country: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if review == nil {
            review = Review()
            review.country = country
        } else {
            // shouldn't need this but just in case
            country = review.country
        }
        print(review.country)
        updateUserInterface()

    }
    
    func updateUserInterface() {
        locationCityField.text = review.locationCity
        bestSiteField.text = review.bestSite
        whyField.text = review.why
    }
    
    func updateDataFromInterface() {
        review.bestSite = bestSiteField.text!
        review.locationCity = locationCityField.text!
        review.why = whyField.text!
//        countries.reviewArray.append(review.locationCity)
        
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateDataFromInterface()
        
        print(review.dictionary)
        
        review.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    
    @IBAction func lookUpSitePressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
}


extension ReviewViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        review.locationCity = place.formattedAddress!
        review.bestSite = place.name
        locationCityField.text = review.locationCity
        bestSiteField.text = review.bestSite
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
