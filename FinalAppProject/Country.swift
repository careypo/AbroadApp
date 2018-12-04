//
//  Country.swift
//  FinalAppProject
//
//  Created by Paige Carey on 11/27/18.
//  Copyright © 2018 Paige Carey. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MapKit

class Countries: NSObject, MKAnnotation {
    
//    struct CountryData {
        var name: String
        var region: String
        var capitalName: String
        var currencyName: [String]
        var flagURL: String
        var language: [String]
        var coordinate: CLLocationCoordinate2D
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    

    init(name: String, region: String, capitalName: String, currencyName: [String], flagURL: String, language: [String], coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.region = region
        self.capitalName = capitalName
        self.currencyName = currencyName
        self.flagURL = flagURL
        self.language = language
        self.coordinate = coordinate
    }
    
    convenience override init() {
        self.init(name: "", region: "", capitalName: "", currencyName: [], flagURL: "", language: [], coordinate: CLLocationCoordinate2D())
        
    }
        
        
//    }
    
//    var longitude: CLLocationDegrees {
//        return coordinate.longitude
//    }
//    
//    var latitude: CLLocationDegrees {
//        return coordinate.latitude
//    }
//    
//    var location: CLLocation {
//        return CLLocation(latitude: latitude, longitude: longitude)
//    }
    
//    var countryArray: [CountryData] = []
    var countryArray: [Countries] = []
    var countryURL = "https://restcountries.eu/rest/v2/all"
    
    
    func getCountries(completed: @escaping () -> ()) {
        var newArray: [String] = []
        Alamofire.request(countryURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let numberOfCountries = json.count
                for index in 0...numberOfCountries - 1 {
                    let name = json[index]["name"].stringValue
                    let region = json[index]["subregion"].stringValue
                    for num in json[index]["currencies"] {
                        newArray.append(json[index]["currencies"][num.0]["code"].stringValue)
                        print(newArray)
                    }
            
                    let capitalName = json[index]["capital"].stringValue
                    
                    var currencyNames = [String]()
                    for (_, currency) in json[index]["currencies"] {
                        currencyNames.append(currency["name"].stringValue)
                    }
                    
                    var languageNames = [String]()
                    for (_, language) in json[index]["languages"] {
                        languageNames.append(language["name"].stringValue)
                    }
                    
                    
                    
                    let flagURL = json[index]["flag"].stringValue
                    //let population = json[index]["population"].doubleValue
                    let latitude = json[index]["latlng"][0].doubleValue
                    let longitude = json[index]["latlng"][1].doubleValue
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    print(coordinate)
                    self.countryArray.append(Countries(name: name, region: region, capitalName: capitalName, currencyName: currencyNames, flagURL: flagURL, language: languageNames, coordinate: coordinate))
                }
            case .failure(let error):
                print("*** ERROR: failed to get data from url \(self.countryURL) \(error.localizedDescription)")
            }
            completed()
        }
        
    }
}
