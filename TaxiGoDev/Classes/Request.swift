//
//  Request.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation
import HandyJSON

extension TaxiGo.API {
    
    public func requestARide(withAccessToken: String,
                             startLatitude: Double,
                             startLongitude: Double,
                             startAddress: String,
                             endLatitude: Double? = nil,
                             endLongitude: Double? = nil,
                             endAddress: String? = nil,
                             success: @escaping (Ride) -> Void, failure: @escaping (Error) -> Void) {
        
        let param: [String: Any] = ["start_latitude": startLatitude,
                                    "start_longitude": startLongitude,
                                    "start_address": startAddress,
                                    "end_latitude": endLatitude,
                                    "end_longitude": endLongitude,
                                    "end_address": endAddress]
        
        call(withAccessToken: withAccessToken, .post, path: "/ride", parameter: param) { (err, dic, array) in
           
            if err == nil {

                // TODO: transfer dic and pass out
//                success(rideData(data: data))
                if let ride = JSONDeserializer<Ride>.deserializeFrom(dict: dic) {
                    success(ride)
                    print(ride.toJSONString(prettyPrint: true))
                    print("-------uuuuu------")
                    guard let model = Ride.deserialize(from: dic) else { return }
                    print(model.start_address)
                    print(model.id)
                    print("-------uuuuu------")

                }

            } else if let err = err {
                
                failure(err)
                print("QQ failed.")
                
            }
        }
        
    }
    
    public func cancelARide(withAccessToken: String, id: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .delete, path: "/ride/\(id)", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                print("Delete")
                print(dic)
                
            } else if let err = err {
                
                failure(err)
                print("Failed to delete.")
                
            }
            
        }
        
    }
 
    public func getRidesHistory(withAccessToken: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/ride", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                print("---------aaaa--------")
                print(model.driver?.driver_id)
                print(model.start_address)
                print("---------aaaa--------")

            } else if let err = err {
                failure(err)
                print("get history failed")
            }
            
        }
        
    }
    
    public func getSpecificRideHistory(withAccessToken: String, id: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/ride/\(id)", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                print("---------aaaa--------")
                print(model.driver?.driver_id)
                print(model.start_address)
                print("---------aaaa--------")
                
            } else if let err = err {
                failure(err)
                print("get specific ride history failed")
            }
            
        }
        
    }
    
    public func getRiderInfo(withAccessToken: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/me", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                guard let model = Rider.deserialize(from: dic) else { return }
                print("---------bbbb--------")
                print(model.name)
                print(model.profile_img)
                
                if let favorite = dic?["favorite"] as? [[String: Any]] ?? nil {
                    
                    if let fav = [Favorite].deserialize(from: favorite) {
                        
                        fav.forEach({ (info) in
                            print(info?.address)
                            print(info?.lat)
                        })
                        
                    }

                }
                
                print("---------bbbb--------")
                
            } else if let err = err {
                failure(err)
                print("get history failed")
            }

            
        }
        
    }
    
    public func getNearbyDriver(withAccessToken: String, lat: Double, lng: Double, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/driver?lat=\(lat)&lng=\(lng)", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                if let driver = [NearbyDrivers].deserialize(from: array) {
                    
                    driver.forEach({ (info) in
                        print(info?.lat)
                        print(info?.lng)
                    })
                    
                }
                
            }
            
        }
        
    }
    
}
