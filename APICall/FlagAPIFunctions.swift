//
//  FlagAPIFunctions.swift
//  coronavirusAPI
//
//  Created by nic Wanavit on 3/17/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import UIKit


class FlagApiFunctions{
    
    
    static func getFlag(name:String)->UIImage?{
        
        let flag = Flag(name: name)
        var data: Data?
        var response: URLResponse?
        var error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        if let flagURL = URL(string: flag.url){
            URLSession.shared.dataTask(with: flagURL, completionHandler: { (d, r, e) in
                data = d
                response = r
                error = e
                semaphore.signal()
                }).resume()
                    
                guard error == nil else {
                    debugPrint("error fetching flag", error!)
                    return nil
                }
                
                _ = semaphore.wait(timeout: .distantFuture)
                
                guard data != nil else {
                    debugPrint("Data is nil")
                    return nil
                }
                
            if let image = UIImage(data: data!){
                return image
            } else {
                debugPrint("error converting data to image",error ?? "")
                return nil
            }
        } else {
        debugPrint("flagURLcompilation is invalid")
        return nil
        }
    }
    
    
    
    
    
}

struct Flag {
    var name:String
    var url:String {
        get {return "https://www.countryflags.io/\(name.lowercased())/flat/64.png"}
    }
}
