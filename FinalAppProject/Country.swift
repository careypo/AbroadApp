//
//  Country.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/27/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import Foundation
import GooglePlaces
import MapKit
import SwiftyJSON
import Alamofire

class Countries {
    struct CountryData {
        var name: String
        var region: String
        var currencyName: String
        var currencySymbol: String
        var flagURL: String
    }
    
    var countryArray: [CountryData] = []
    var countryURL = "https://countryapi.gear.host/v1/Country/getCountries"
    
    
    func getCountries(completed: @escaping () -> ()) {
        Alamofire.request(countryURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let numberOfCountries = json["Response"].count
                for index in 0...numberOfCountries - 1 {
                    let name = json["Response"][index]["Name"].stringValue
                    let region = json["Response"][index]["Region"].stringValue
                    let currencyName = json["Response"][index]["CurrencyName"].stringValue
                    let currencySymbol = json["Response"][index]["CurrencySymbol"].stringValue
                    let flagURL = json["Response"][index]["FlagPng"].stringValue
                    self.countryArray.append(CountryData(name: name, region: region, currencyName: currencyName, currencySymbol: currencySymbol, flagURL: flagURL))
                }
            case .failure(let error):
                print("*** ERROR: failed to get data from url \(self.countryURL) \(error.localizedDescription)")
            }
            completed()
        }
        
    }
}
