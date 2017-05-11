//
//  WallabagApi.swift
//  wallabag
//

import Foundation
import Alamofire

public class WallabagApi {

    /*public enum RetrieveMode: String {
        case allArticles
        case archivedArticles
        case unarchivedArticles
        case starredArticles

        public func humainReadable() -> String {
            switch self {
            case .allArticles:
                return "All articles"
            case .archivedArticles:
                return "Read articles"
            case .starredArticles:
                return "Starred articles"
            case .unarchivedArticles:
                return "Unread articles"
            }
        }
    }*/

    static let sessionManager = SessionManager()
    static var userStorage: UserDefaults!

    //public static var mode: RetrieveMode = .allArticles

    public static func `init`(userStorage: UserDefaults) {
        self.userStorage = userStorage

        guard let host = getHost(),
            let clientId =  getClientId(),
            let clientSecret = getClientSecret(),
            let accessToken = getToken(),
            let refreshToken = getRefreshToken() else {
                return
        }
        let bearer = BearerTokenAdapter(clientID: clientId, clientSecret: clientSecret, baseURLString: host, accessToken: accessToken, refreshToken: refreshToken)
        sessionManager.adapter = bearer
        sessionManager.retrier = bearer
    }

    public static func requestToken(username: String, password: String, _ completion: @escaping(_ success: Bool, _ error: String?) -> Void) {
        guard let host = getHost(),
            let clientId =  getClientId(),
            let clientSecret = getClientSecret() else {
            completion(false, nil)
            return
        }
        let parameters = ["grant_type": "password",
                          "client_id": clientId,
                          "client_secret": clientSecret,
                          "username": username,
                          "password": password
        ]
        Alamofire.request(host + "/oauth/v2/token", method: .post, parameters: parameters).responseJSON { response in
            if response.response?.statusCode != 200 {
                guard let result = response.result.value,
                    let JSON = result as? [String: Any],
                    let errorDescription = JSON["error_description"] as? String else {
                        completion(false, "Unexpected error")
                        return
                }
                completion(false, errorDescription)
            }

            guard let result = response.result.value,
                let JSON = result as? [String: Any],
                let accessToken = JSON["access_token"] as? String,
                let refreshToken = JSON["refresh_token"] as? String else {
                    return
            }

            set(token: accessToken)
            set(refreshToken: refreshToken)

            let bearer = BearerTokenAdapter(clientID: clientId, clientSecret: clientSecret, baseURLString: host, accessToken: accessToken, refreshToken: refreshToken)
            sessionManager.adapter = bearer
            sessionManager.retrier = bearer

            completion(true, nil)
        }
    }

    // MARK: - Article
    public static func patchArticle(_ id: Int, withParamaters withParameters: [String: Any], completion: @escaping(_ article: Article) -> Void) {
        sessionManager.request(getHost()! + "/api/entries/" + String(id), method: .patch, parameters: withParameters)
            .validate()
            .responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    completion(Article(fromDictionary: JSON))
                }
        }
    }

    public static func deleteArticle(_ id: Int, completion: @escaping() -> Void) {
        sessionManager.request(getHost()! + "/api/entries/" + String(id), method: .delete).validate().responseJSON { _ in
            completion()
        }
    }

    public static func addArticle(_ url: URL, completion: @escaping(_ article: Article) -> Void) {
        sessionManager.request(getHost()! + "/api/entries", method: .post, parameters: ["url": url.absoluteString]).validate().responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                completion(Article(fromDictionary: JSON))
            }
        }
    }

    public static func retrieveArticle(page: Int = 1, withParameters: [String: Any] = [:], _ completion: @escaping([Article], _ error: String?) -> Void) {
        var parameters: [String: Any] = ["page": page]
        parameters = parameters.merge(dict: withParameters)
        var articles = [Article]()

        sessionManager.request(getHost()! + "/api/entries", parameters: parameters).validate().responseJSON { response in
            switch response.result {
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

        }
    }

    public static func retrieveUnreadArticle(_ completion: @escaping(_ total: Int) -> Void) {
        let parameters: [String: Any] = ["perPage": 99, "archive": 0]
        var total = 0

        sessionManager.request(getHost()! + "/api/entries", parameters: parameters).validate().responseJSON { response in
            if let result = response.result.value {
                if let JSON = result as? [String: Any] {
                    if let embedded = JSON["_embedded"] as? [String: Any] {
                        if let items = embedded["items"] as? [[String: Any]] {
                            total = items.count
                        }
                    }
                }
            }
            completion(total)
        }
    }

    /*public static func getRetrieveMode() -> [String: Any] {
        switch mode {
        case .allArticles:
            return [:]
        case .archivedArticles:
            return ["archive": 1]
        case .unarchivedArticles:
            return ["archive": 0]
        case .starredArticles:
            return ["starred": 1]
        }
    }*/
}
