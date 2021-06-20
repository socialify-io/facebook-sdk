//
//  FacebookClient.swift
//
//
//  Created by Tomasz on 22/05/2021.
//

import Foundation

public class FacebookClient {
    
    /// MARK: - Public variables
    
    public init() {
        self.myDelegate = true ? MySession() : nil
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
    }
    
    public let LIBRARY_VERSION = "v0.0.1"
    public var myDelegate: MySession?

    public var session: URLSession?
    
    /// MARK: - Facebook Errors
    
    public enum FacebookError: Error {
        case ConnectionError
        case UnexpectedError
    }
}

/// MARK: - Helper classes

public class MySession: NSObject, URLSessionTaskDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
