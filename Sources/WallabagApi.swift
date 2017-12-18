//
//  WallabagApi.swift
//  WallabagKit
//
//  Created by maxime marinel on 04/12/2017.
//  Copyright © 2017 WallabagKit. All rights reserved.
//

import Foundation
import Alamofire

public enum Result<T> {
    public enum ErrorType {
        case invalidAuth
        case emptyJSON
        case emptyData
    }
    case success(T)
    case error(ErrorType)
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}

public class WallabagApi {
    let sessionManager: SessionManager

    internal let host: String
    internal let username: String
    internal let password: String
    internal let clientId: String
    internal let clientSecret: String

    public init(host: String,
                username: String,
                password: String,
                clientId: String,
                clientSecret: String) {
        self.host = host
        self.username = username
        self.password = password
        self.clientId = clientId
        self.clientSecret = clientSecret
        sessionManager = SessionManager.default
        let token = BearerTokenAdapter(baseURLString: host,
                                       clientID: clientId,
                                       clientSecret: clientSecret,
                                       username: username,
                                       password: password)
        sessionManager.adapter = token
        sessionManager.retrier = token
    }

    public func entry(parameters: Parameters = [:], completion: @escaping (Result<[WallabagEntry]>) -> Void) {
        sessionManager.request(host + "/api/entries", parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                guard let JSON = result as? [String: Any],
                    let embedded = JSON["_embedded"] as? [String: Any],
                    let items = embedded["items"] as? [[String: Any]] else {
                        completion(Result.error(.emptyJSON))
                        return
                }
                var entries: [WallabagEntry] = []
                for item in items {
                    if let entry = try? JSONDecoder().decode(WallabagEntry.self, from: Data(item.json.utf8)) {
                        entries.append(entry)
                    }
                }
                completion(Result.success(entries))
                break
            case .failure:
                if 401 == response.response?.statusCode {
                    completion(Result.error(.invalidAuth))
                } else {
                    completion(Result.error(.emptyData))
                }
            }
        }
    }

    public func entry(delete id: Int, completion: @escaping (Result<Bool>) -> Void) {
        sessionManager.request(host + "/api/entries/\(id)", method: .delete).validate().responseJSON { response in
            switch response.result {
                case .success:
                completion(Result.success(true))
                case .failure:
                    if 401 == response.response?.statusCode {
                        completion(Result.error(.invalidAuth))
                    } else {
                        completion(Result.error(.emptyData))
                }
            }
        }
    }

    public func entry(get id: Int, completion: @escaping (Result<WallabagEntry>) -> Void) {
        sessionManager.request(host + "/api/entries/\(id)").validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                guard let JSON = result as? [String: Any], let entry = try? JSONDecoder().decode(WallabagEntry.self, from: Data(JSON.json.utf8)) else {
                    completion(Result.error(.emptyJSON))
                    return
                }
                completion(Result.success(entry))
            case .failure:
                if 401 == response.response?.statusCode {
                    completion(Result.error(.invalidAuth))
                } else {
                    completion(Result.error(.emptyData))
                }
            }
        }
    }

    public func entry(add url: URL, completion: @escaping (Result<WallabagEntry>) -> Void) {
        sessionManager.request(host + "/api/entries", method: .post, parameters: ["url": url.absoluteString]).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                guard let JSON = result as? [String: Any], let entry = try? JSONDecoder().decode(WallabagEntry.self, from: Data(JSON.json.utf8)) else {
                    completion(Result.error(.invalidAuth))
                    return
                }
                completion(Result.success(entry))
            case .failure:
                if 401 == response.response?.statusCode {
                    completion(Result.error(.invalidAuth))
                } else {
                    completion(Result.error(.emptyData))
                }
            }
        }
    }

    public func entry(update id: Int, parameters: Parameters = [:], completion: @escaping (Result<WallabagEntry>) -> Void) {
        sessionManager.request(host + "/api/entries/\(id)", method: .patch, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                guard let JSON = result as? [String: Any], let entry = try? JSONDecoder().decode(WallabagEntry.self, from: Data(JSON.json.utf8)) else {
                    completion(Result.error(.invalidAuth))
                    return
                }
                completion(Result.success(entry))
            case .failure:
                if 401 == response.response?.statusCode {
                    completion(Result.error(.invalidAuth))
                } else {
                    completion(Result.error(.emptyData))
                }
            }
        }
    }
}
