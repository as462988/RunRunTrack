//
//  HTTPClient.swift
//  RunRunTruck
//
//  Created by Yueh-chen Hsu on 2019/10/2.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

enum HTTPMethod: String {

    case GET

    case POST
}

enum HTTPHeaderField: String {

    case contentType = "Content-Type"

    case auth = "Authorization"
}

enum HTTPHeaderValue: String {

    case json = "application/json"
}

class HTTPClient {
    
}
