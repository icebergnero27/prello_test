//
//  WebService.swift
//  PrelloTest
//
//  Created by antonio yaphiar on 11/16/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import Foundation
import CoreLocation
import Foundation
import SystemConfiguration

class WebService {
    
    static let shared = WebService()
    
    var idToken: String? = nil
    var endPoint : String? = "https://dev.prelo.id/api/"
    
    var webTask: URLSessionDataTask?
    
    var session: URLSession {
        return URLSession.shared
    }
    
    func login(_ email:String ,_ password:String, completion: @escaping (([String:AnyObject]) -> Void)) -> (){
        var urlString : String = "\(endPoint!)/auth/login"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = NSURL(string : urlString)
        var request = URLRequest(url: url! as URL )
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        let json: [String: Any] = ["username_or_email": email,
                                   "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if(error != nil){
                print(error.debugDescription)
            }else{
                do{
                    let apiResponse  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async {
                        completion(apiResponse as! [String : AnyObject])
                    }
                    
                }catch let error as NSError{
                    print (error)
                }
            
            }
        }
        task.resume()
        
    }
    
    // MARK: - HUDPROGRESS
//    func showHudProgress(){
//        window = UIApplication.shared.delegate!.window!!
//        self.hud = MBProgressHUD.showAdded(to: window, animated: true)
//        hud.mode = MBProgressHUDMode.indeterminate
//    }
//    
//    func hideHudProgress(){
//        window = UIApplication.shared.delegate!.window!!;
//        MBProgressHUD.hide(for: window, animated: true)
//    }
    
    // MARK: - REACHBILITY
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
