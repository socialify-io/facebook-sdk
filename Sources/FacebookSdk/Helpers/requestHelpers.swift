//
//  requestHelpers.swift
//  
//
//  Created by Tomasz on 20/06/2021.
//

import Foundation

extension FacebookClient {
    
    /// MARK: - Request helpers
    func makeRequest(request: URLRequest, completion: @escaping (Result<[String: Any], FacebookError>) -> Void) {
        var request = request
        
        // Adding User-Agent
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        // Sending request
        session?.dataTask(with: request) { (data, response, error) in
            // Looking for errors
            guard let data = data else {
                  if let _ = error {
                    completion(.failure(FacebookError.ConnectionError))
                  }
                
                completion(.failure(FacebookError.ConnectionError))
                return
                }
            
            // Preparing return data
            let returnBody: [String: Any] = [
                "data": data,
                "response": response
            ]
            
            completion(.success(returnBody))
        }.resume()
    }
}
