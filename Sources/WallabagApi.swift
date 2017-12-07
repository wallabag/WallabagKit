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

    let auth: WallabagSessionManager
    let sessionManager: SessionManager

    public init(auth: WallabagSessionManager) {
        self.auth = auth
        self.sessionManager = auth.createSession()
    }

    public func entry(completion: @escaping () -> Void) {
        sessionManager.request(auth.host + "/api/entries", parameters: [:]).validate().responseJSON { _ in

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
