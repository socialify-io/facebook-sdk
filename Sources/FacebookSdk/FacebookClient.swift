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
        self.delegate = true ? Session() : nil
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
    }
    
    public let LIBRARY_VERSION = "v0.0.1"
    
    public var delegate: Session?
    public var session: URLSession?
    
    /// MARK: - Facebook Errors
    
    public enum FacebookError: Error {
        case ConnectionError
        case UnexpectedError
        case FacebookError
        case ScrapperError
    }
}
