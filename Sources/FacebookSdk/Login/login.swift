//
//  login.swift
//  
//
//  Created by Tomasz on 20/06/2021.
//

import Foundation
import SwiftSoup

extension FacebookClient {
    
    /// MARK: - Logging in functions
    
    /// Logging in
    /// Parameters:
    ///  - email
    ///  - password
    /// Returns
    /// - true or false
    
    public func login(email: String, password: String, completion: @escaping (Result<Bool, FacebookError>) -> Void) {
        self.getParams(email: email, password: password) { [self] payload in
            switch payload {
            case .success(let payload):
                // Creating privacy mutation token
                let timestamp = Int64((Date().timeIntervalSince1970))
                let privacyMutationToken = Data("{\"type\":0,\"creation_time\":\(timestamp),\"callsite_id\":381229079575946}".utf8).base64EncodedString()
                
                // Preparing request
                let url = URL(string: "https://www.facebook.com/login/?privacy_mutation_token=\(privacyMutationToken)")!
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = Data(payload.map { "\($0.key)=\($0.value)" }.joined(separator: "&").utf8)
                
                // Preparing headers
                request.allHTTPHeaderFields = [
                    "Cookie": "datr=QfbNYK0kA7zXWagrFbytAswt",
                    "Content-Type": "application/x-www-form-urlencoded",
                    "Upgrade-Insecure-Requests": "1",
                    "Sec-Fetch-Site": "same-origin",
                    "Sec-Fetch-Mode": "navigate",
                    "Sec-Fetch-User": "?1",
                    "Sec-Fetch-Dest": "document",
                    "connection": "close",
                    "Accept-Encoding": "gzip, deflate",
                    "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8"
                ]
                
                // Send request
                self.makeRequest(request: request) { result in
                    switch result {
                    case .success(let result):
                        let response = result["response"]
                        if let response = response as? HTTPURLResponse {
                            // Checking is logged in
                            if(response.statusCode == 302) {
                                completion(.success(true))
                            } else {
                                completion(.success(false))
                            }
                        }
                    
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getParams(email: String, password: String, completion: @escaping (Result<[String: Any], FacebookError>) -> Void) {
        // Names of inpust for scrapping
        let requiredInputs = ["jazoest", "lsd"]
        
        // Declaring a variable with payload
        var payload: [String: Any] = [
            "jazoest": "",
            "lsd": "",
            "login_source": "comet_headerless_login",
            "next": "",
            "email": email,
            "pass": password
        ]
        
        // Preparing request
        let url = URL(string: "https://www.facebook.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = [
            "Cookie": "datr=QfbNYK0kA7zXWagrFbytAswt",
            "Content-Type": "application/x-www-form-urlencoded",
            "Upgrade-Insecure-Requests": "1",
            "Sec-Fetch-Site": "same-origin",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-User": "?1",
            "Sec-Fetch-Dest": "document",
            "connection": "close",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8"
        ]
        
        // Sending request
        self.makeRequest(request: request) { response in
            switch response {
            case .success(let response):
                // Parsing response
                let content: String = String(data: response["data"] as! Data, encoding: String.Encoding.utf8) ?? ""
                
                if content.contains("Sorry, something went wrong.") {
                    completion(.failure(FacebookError.FacebookError))
                }
                
                do {
                    let doc: Document = try SwiftSoup.parse(content)
                    
                    // Getting inputs
                    let inputs = try doc.select("input")
                    
                    // Scrapping inputs
                    try inputs.forEach { input in
                        if (requiredInputs.contains(try input.attr("name"))) {
                            payload[try input.attr("name")] = try input.attr("value")
                        }
                    }
                    
                    completion(.success(payload))
                } catch {
                    completion(.failure(FacebookError.ScrapperError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
