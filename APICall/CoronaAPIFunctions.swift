//
//  CoronaAPIFunctions.swift
//  coronavirusAPI
//
//  Created by nic Wanavit on 3/16/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation


class CoronaAPIFunctions{
    static let url = URL(string: "https://coronavirus-tracker-api.herokuapp.com/all")!
    
    
    static func GetAllData()->Data?{
        
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        URLSession.shared.dataTask(with: CoronaAPIFunctions.url, completionHandler: { (d, r, e) in
            data = d
            response = r
            error = e
            semaphore.signal()
            }).resume()
        
        guard error == nil else {
            debugPrint("error fetching data", error!)
            return nil
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        guard data != nil else {
            debugPrint("Data is nil")
            return nil
        }
        
//        debugPrint(String(data: data!, encoding: .utf8))
        
        return data
    }
    
    
    
    
    static func updateData(coronaDataList:CoronaDataList){
        let data = CoronaAPIFunctions.GetAllData()!
        let decoder = JSONDecoder()
        do {
            let db = try decoder.decode(MainObject.self, from: data)
            debugPrint("total cases are",db.confirmed.total)
            CoronaAPIFunctions.updateCoronaData(db: db, coronaDataList: coronaDataList)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    static func updateCoronaData(db:MainObject, coronaDataList:CoronaDataList){
        var coronaList:[CoronaData] = []
        for infectionPack in db.confirmed.countries{
            //only append if not repeated
            let countryPack = CoronaAPIFunctions.convertCountryToCoronaData(country: infectionPack, db: db)
            if var country = coronaList.first(where: { return $0.country == infectionPack.name}) {
                country.death += countryPack.death
                country.infections += countryPack.infections
                country.recovered += countryPack.recovered
                coronaList.removeAll(where: { $0.country == country.country })
                coronaList.append(country)
                
                if country.country == "China"{
                    debugPrint(infectionPack.province, " ", infectionPack.total)
                }
                
            } else {
                coronaList.append(countryPack)
            }
            
        }
        DispatchQueue.main.async {
            coronaDataList.data = coronaList.sorted(by: { (first, second) -> Bool in
                return first.infections > second.infections
            })
                
            coronaDataList.totalCases = db.confirmed.total
        }
        

        
    }
    static func convertCountryToCoronaData(country:Country, db:MainObject)->CoronaData{
//        let name = country.name
        let latitude = country.coordinates.lat
        let infection = country.total
        let countryCode = country.countryCode
        let deathsPack = db.deaths.countries.first { (country) -> Bool in
            return country.coordinates.lat == latitude
        }
        let death = deathsPack?.total ?? 0
        let recoveredPack = db.recovered.countries.first { (country) -> Bool in
            return country.coordinates.lat == latitude
        }
        let recovered = recoveredPack?.total ?? 0
        
        return CoronaData(country: country.name, infections: infection, death: death, recovered: recovered, code: countryCode)
    }
}


struct MainObject:Codable {
    var confirmed:Confirmed
    var deaths:Confirmed
    var latest: Latest
    var recovered: Confirmed
}

struct Confirmed:Codable {
    var lastUpdated:String
    var total: Int
    var countries:[Country]
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case total = "latest"
        case countries = "locations"
    }
}

struct Country:Codable {
    var name:String
    var total:Int
    var province:String
    var coordinates:Coordinates
    var countryCode:String
    
    enum CodingKeys: String, CodingKey {
        case name = "country"
        case total = "latest"
        case countryCode = "country_code"
        case coordinates
        case province
        
    }
}

struct Coordinates:Codable {
    var lat:String
    var long:String
}


struct Latest:Codable {
    var confirmed:Int
    var deaths: Int
    var recovered: Int
}
