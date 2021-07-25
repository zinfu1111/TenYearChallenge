//
//  LocationManager.swift
//  TenYearChallenge
//
//  Created by 連振甫 on 2021/7/25.
//

import UIKit
import CoreLocation
import Foundation

class LocationManager {
    
    static let shared = LocationManager()
    let imageCache = NSCache<NSURL, UIImage>()
    
    var info = CLLocation(latitude:  35.68, longitude: 139.69)
    
    func setPosition(lat: Double,long: Double) {
        self.info = CLLocation(latitude: lat, longitude: long)
    }
    
    func getSatellitePhoto(from queryDate:String, completion: @escaping (String,UIImage)->Void ) {
        
        let url = "https://api.nasa.gov/planetary/earth/imagery?lon=\(info.coordinate.longitude)&lat=\(info.coordinate.latitude)&date=\(queryDate)-18&dim=0.23&api_key=Jhg31gYWdrK1ZKOGvo7pegX51auz3ohLaYawBWoA"
        
        if let image = imageCache.object(forKey: URL(string: url)! as NSURL) {
            completion(queryDate,image)
            return
        }
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data,response,error in
            guard let data = data,let image = UIImage(data: data), error == nil else {
                return
            }
            self.imageCache.setObject(image, forKey: URL(string: url)! as NSURL)
            completion(queryDate,image)
        })
        
        task.resume()
    }
}
