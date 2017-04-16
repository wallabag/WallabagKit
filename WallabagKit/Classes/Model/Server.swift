//
//  Server.swift
//  Pods
//
//  Created by maxime marinel on 16/04/2017.
//
//

import Foundation

public struct Server {
    public let host: String
    public let client_secret: String
    public let client_id: String
    public let username: String
    public let password: String

    public init(host: String, client_secret: String, client_id: String, username: String, password: String) {
        self.host = host
        self.client_secret = client_secret
        self.client_id = client_id
        self.username = username
        self.password = password
    }
}
