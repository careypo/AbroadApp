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
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    
    var review: Review!
    var country: String!
    var photos: Photos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
         whyField.addBorder(width: 0.5, radius: 5.0, color: .black)
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        if review == nil {
            review = Review()
            review.country = country
            
           
            
        } else {
            // shouldn't need this but just in case
            country = review.country
            whyField.isEditable = false
            bestSiteField.isEnabled = false
            locationCityField.isEnabled = false
            whyField.backgroundColor = UIColor.lightGray
            saveBarButton.title = ""
            cancelBarButton.title = "Back"
            locationCityField.backgroundColor = UIColor.lightGray
            bestSiteField.backgroundColor = UIColor.lightGray
        }
        print(review.country)
//        photos = Photos()
        updateUserInterface()

    }
    
//    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
//        saveBarButton.isEnabled = !(bestSiteField.text == "")
//    }
    
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        review.bestSite = bestSiteField.text!
        review.locationCity = locationCityField.text!
        review.why = whyField.text!
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
    
//    func cameraOrLibraryAlert() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction(title: "Camera", style: .default) {_ in
//            self.accessCamera()
//        }
//        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {_ in
//            self.accessLibrary()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cameraAction)
//        alertController.addAction(photoLibraryAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//
//    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateDataFromInterface()
        
        print(review.dictionary)
        
        review.saveData { success in
            if success {
                print(self.review.dictionary)
                self.review.saveData(completion: { result in
                    if success {
                        self.leaveViewController()
                    }
                })
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        review.deleteData(review: review) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("^^^ Delete unsuccessful!!")
            }
        }
    }
    
    @IBAction func lookUpSitePressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
//    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
//        cameraOrLibraryAlert()
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("Yay, it worked!")
//            //self.present(imagePicker, animated: true, completion: nil)
//            //self.present(alert, animated: true, completion: nil)
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("imagePickerController executed")
//        if let pickedImage = info[.originalImage] as? UIImage {
//            imageView1.contentMode = .scaleAspectFit
//            imageView1.image = pickedImage
//        }
//        self.dismiss(animated: true, completion: { () -> Void in})
//    }
    
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


extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ReviewPhotosCollectionViewCell
        cell.photo = photos.photoArray[indexPath.row]
        return cell
    }
}

//extension ReviewViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        let photo = Photo()
////        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
////        dismiss(animated: true) {
////            photo.saveData(review: self.review) { (success) in
////            }
////        }
////
////    }
////
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func accessLibrary() {
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//
//    }
//
//    func accessCamera() {
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//            present(imagePicker, animated: true, completion: nil)
//        } else {
//            showAlert(title: "Camera Not Available", message: "There is no camera available on this device")
//        }
//    }
//}
//
