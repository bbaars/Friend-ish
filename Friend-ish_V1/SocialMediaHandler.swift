//
//  File.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/17/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import TwitterKit

extension WalkthroughViewController {
    
    /*
     * Obtains the list data in JSON of all the passed Users Screen Name (twitter handle)
     *
     * @ params screenName: String the screen name of the requested User
     */
    func updateTwitterFollowers (_ screenName: String) {
        
        var resourceURL = ""
        let params = ["screen_name": screenName]

        resourceURL = "https://api.twitter.com/1.1/users/show.json?.screen_name=\(screenName)"
        self.request(url: resourceURL, params: params, screenName: screenName)
    }
    
    
    private func request (url: String, params: [String:Any], screenName: String) {
        
        let client = TWTRAPIClient()
        var clientError: NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: url, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) in
            
            if connectionError != nil {
                print("CONNECTION ERROR: \(connectionError!)")
                
            } else {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    //print(json)
                    
                    if let j = json as? [String : Any]{
                        print(j)
                        if let profileImg = j["profile_image_url_https"] as? String {
                            currentUser["twitProfilePhoto"] = profileImg
                        }
                        
                        if let screenName = j["screen_name"] as? String {
                            currentUser["twitName"] = screenName
                        }
                    }
                }
                catch let jsonError as NSError {
                    print(jsonError.localizedDescription)
                }
            }
        }
    }
}
