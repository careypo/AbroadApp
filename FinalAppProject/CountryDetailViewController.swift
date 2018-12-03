//
//  ShowCountryDetailViewController.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/27/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import SDWebImage

class CountryDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var capitalNameLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var tableView2: UITableView!
    
    var flagDetails = FlagDetails()
    
    var name: String!
    var capitalName: String!
    var currencySymbol: String!
    var region: String!
    var flagPic: String!
    var population: String!
    
    var reviews: Reviews!
    
    var country = Countries()
    var regionDistance: CLLocationDistance = 500000
    
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviews = Reviews()
        reviews.country = name
        
        tableView2.delegate = self
        tableView2.dataSource = self
        
        let newRegion = MKCoordinateRegion(center: country.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(newRegion, animated: true)
        updateMap()
        
        
        
        nameLabel.text = name
        capitalNameLabel.text = capitalName
        //currencySymbolLabel.text = currencySymbol
        regionLabel.text = region
        populationLabel.text = population
        
        guard let imageURL = URL(string: flagDetails.flagURL) else { return }
        do {
            let data = try Data(contentsOf: imageURL)
            flagImage.image = UIImage(data: data)
        } catch {
            print("**** ERROR: error thrown trying to get data from URL \(imageURL)")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        reviews.loadData {
            self.tableView2.reloadData()
            for review in self.reviews.reviewArray {
                print(review.why)
            }
        }
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(country)
        mapView.setCenter(country.coordinate, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReview" {
            let destination = segue.destination as! ReviewViewController
            let selectedIndexPath = tableView2.indexPathForSelectedRow!
            destination.review = reviews.reviewArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView2.indexPathForSelectedRow {
                tableView2.deselectRow(at: selectedIndexPath, animated: true)
            }
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! ReviewViewController
            target.country = name
        }
    }
}


extension CountryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView2.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        
        // here is what you need to edit to make this work
        cell.textLabel?.text = reviews.reviewArray[indexPath.row].bestSite
        return cell
    }
    
    
}
