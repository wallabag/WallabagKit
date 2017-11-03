//
//  WallabagAuthApi.swift
//  WallabagKit
//
//  Created by maxime marinel on 04/12/2017.
//  Copyright © 2017 WallabagKit. All rights reserved.
//

import Foundation
import Alamofire

public enum WallabagAuthApiResult {
    case success()
    case error
}

public class WallabagAuthApi {
    //let sessionManager: SessionManager
    let host: String
    let username: String
    let password: String
    let clientId: String
    let clientSecret: String

    public init(host: String,
                username: String,
                password: String,
                clientId: String,
                clientSecret: String,
                sessionManager: SessionManager) {
        //self.sessionManager = sessionManager
        self.host = host
        self.username = username
        self.password = password
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    public func createSession() -> SessionManager {
        let sessionManager = SessionManager()
        let token = BearerTokenAdapter(baseURLString: host, clientID: clientId, clientSecret: clientSecret, username: username, password: password)

        sessionManager.adapter = token
        sessionManager.retrier = token

        return sessionManager
    }

    /*public func auth(completion: @escaping (WallabagAuthApiResult) -> Void) {
        sessionManager.request("\(host)/oauth/v2/token", method: .post, parameters: ["grant_type": "password",
                                                                                     "client_id": clientId,
                                                                                     "client_secret": clientSecret,
                                                                                     "username": username,
                                                                                     "password": password
            ]).responseJSON { response in
                if 200 != response.response?.statusCode {
                    completion(.error)
                }


        }
        //let urlRequest = URLComponents(string: host)
        //        urlRequest.httpMethod = "POST"

        //        urlSession.dataTask(with: urlRequest) { data, response, error in

        //        }
    }*/
}
