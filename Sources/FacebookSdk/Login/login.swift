//
//  login.swift
//  
//
//  Created by Tomasz on 20/06/2021.
//

import Foundation

extension FacebookClient {
    
    /// MARK: - Logging in functions
    
    /// Logging in
    /// Parameters:
    ///  - email
    ///  - password
    /// Returns
    /// - true or false
    
    public func login(email: String, password: String, completion: @escaping (Result<Bool, FacebookError>) -> Void) {
        // Preparing payload
        let payload: [String: Any] = [
            "jazoest": 2935,
            "lsd": "AVpbphIq-K4",
            "login_source": "comet_headerless_login",
            "next": "",
            "email": email,
            "pass": password
        ]
        
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
            "Cookie": "datr=QfbNYK0kA7zXWagrFbytAswt; sb=V_bNYEf2HisBhggP9qDT8fZL; dpr=2; locale=en_GB; wd=876x748; fr=1fj24NQhQ3bYG9HVz.AWVcO1tgdR19ey3Y8wc-RMkxYII.Bgzmbb.q4.AAA.0.0.Bgzmcy.AWXaBBYWli8",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
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
        session?.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                // Checking is logged in
                if(response.statusCode == 302) {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }.resume()
    }
}
