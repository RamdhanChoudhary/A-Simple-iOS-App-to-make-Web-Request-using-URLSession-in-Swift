//
//  ViewController.swift
//  Simple Web Request
//
//  Created by RAMDHAN CHOUDHARY on 28/05/19.
//  Copyright © 2019 RDC. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO : Make sure You must add "NSAppTransportSecurity" key in pList for http requests
//        <key>NSAppTransportSecurity</key>
//        <dict>
//        <key>NSAllowsArbitraryLoads</key>
//        <true/>
//        </dict>
        
        //Please call one of the following method at a time for making URL request
        
        //simpleGetUrlRequest()
        //simpleGetUrlWithParamRequest()
        //simpleGetUrlRequestWithErrorHandling()
        simplePostRequestWithParamsAndErrorHandling()
    }
    
    // - - - - - - GET + URL - - - - - - -
    
    
    func simpleGetUrlRequest()
    {
        let url = URL(string: "http://www.stackoverflow.com")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print("The response is : ",String(data: data, encoding: .utf8)!)
            //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
        }
        task.resume()
    }
    
    // - - - - - - - GET + URL + Parameters - - - - - -
    func simpleGetUrlWithParamRequest()
    {
        let url = URL(string: "https://www.google.com/search?q=peace")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            print("The Response is : ",response)
        }
        task.resume()
    }

    // - - - - - - - GET + URL + Error Handling - - -  - - - - -
    func simpleGetUrlRequestWithErrorHandling()
    {
        let session = URLSession.shared
        let url = URL(string: "https://learnappmaking.com/ex/users.json")!
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    // - - - - - - - - POST + URL + Parameters + Error Handling + Custom Request - - - - - - - -

    
    func simplePostRequestWithParamsAndErrorHandling()
    {
        var session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        session = URLSession(configuration: configuration)
        
        let url = URL(string: "https://httpbin.org/post")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters = ["username": "foo", "password": "123456"]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Oops!! there is server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("response is not json")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        })
        
        task.resume()
    }
    
    
}
