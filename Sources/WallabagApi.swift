//
//  WallabagApi.swift
//  WallabagKit
//
//  Created by maxime marinel on 04/12/2017.
//  Copyright © 2017 WallabagKit. All rights reserved.
//

import Foundation
import Alamofire

public class WallabagApi {

    let auth: WallabagAuthApi
    let sessionManager: SessionManager

    public init(auth: WallabagAuthApi) {
        self.auth = auth
        self.sessionManager = auth.createSession()
    }
    
    /*
    public init(host: String, clientId: String, clientSecret: String, urlSession: URLSessionProtocol) {
        self.host = host
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    public convenience init(host: String, clientId: String, clientSecret: String) {
        self.init(host: host, clientId: clientId, clientSecret: clientSecret)
    }

 */

    public func entry(completion: @escaping () -> Void) {
        sessionManager.request(auth.host + "/api/entries", parameters: [:]).validate().responseJSON { response in

            completion()
            /*switch response.result {
            case .success(let result):
                if let JSON = result as? [String: Any] {
                    if let embedded = JSON["_embedded"] as? [String: Any] {
                        for item in (embedded["items"] as? [[String: Any]])! {
                            articles.append(Article(fromDictionary: item))
                        }
                    }
                }
                completion(articles, nil)
                break
            case .failure( _):
                completion(articles, "Error")
            }
*/
        }
    }
}

