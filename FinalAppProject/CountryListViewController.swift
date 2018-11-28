//
//  CountryListViewController.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/27/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var countries = Countries()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        countries.getCountries {
            self.tableView.reloadData()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCountryDetail" {
            let destination = segue.destination as! CountryDetailViewController
            if let selectedIndex = tableView.indexPathForSelectedRow {
                destination.name = countries.countryArray[selectedIndex.row].name
                destination.currencyName = countries.countryArray[selectedIndex.row].currencyName
                destination.currencySymbol = countries.countryArray[selectedIndex.row].currencySymbol
                destination.region = countries.countryArray[selectedIndex.row].region
                destination.flagDetails.flagURL = countries.countryArray[selectedIndex.row].flagURL
            }
        }
    }
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = countries.countryArray[indexPath.row].name
        return cell
    }
    
    
}