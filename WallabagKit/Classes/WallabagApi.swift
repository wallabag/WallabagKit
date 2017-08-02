//
//  WallabagApi.swift
//  wallabag
//

import Foundation
import Alamofire

/// Types that conform to this model an API endpoint that can be connected to via Alamofire
protocol AlamofireEndPoint {
    /// Provides all the information required to make the API call from Alamofire
    func provideValues()-> (url: String, httpMethod: HTTPMethod, parameters:[String:Any]?,encoding: ParameterEncoding)

    var url: URLConvertible         { get }
    var httpMethod: HTTPMethod      { get }
    var parameters: [String: Any]?  { get }
    var encoding: ParameterEncoding { get }
}

extension AlamofireEndPoint {
    var url: URLConvertible         { return provideValues().url }
    var httpMethod: HTTPMethod      { return provideValues().httpMethod }
    var parameters: [String: Any]?  { return provideValues().parameters }
    var encoding: ParameterEncoding { return provideValues().encoding }
}

/// The response from a method that can result in either a successful or failed state
public enum Result<T> {
    case success(T)
    case failure(Error)
}

/// The Reponse type from Alamofire is Any
typealias AlamofireJSONCompletionHandler = (Result<Any>)->()

/// Used to connect to any JSON API that is modeled by an AlamofireEndpoint
public enum AlamoFireJSONClient {

    static func makeAPICall(to endPoint: AlamofireEndPoint, completionHandler:@escaping AlamofireJSONCompletionHandler) {
        Alamofire.request(endPoint.url, method: endPoint.httpMethod, parameters: endPoint.parameters, encoding: endPoint.encoding).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(Result.success(value))
            case .failure(let error):
                completionHandler(Result.failure(error))
            }
        }
    }
}


/// All of the endpoints return a [String : Any] json object
public typealias WallabagJSONCompletionHandler = (Result<[String : Any]>)->()


/// Types that conform to this can return results from the JSON API
protocol WallabagJSONClient {
    static func handle(result: Result<Any>, completionHandler: WallabagJSONCompletionHandler)
    static func handleSuccessfulAPICall(for json: Any, completionHandler: WallabagJSONCompletionHandler)
    static func handleFailedAPICall(for error: Error, completionHandler: WallabagJSONCompletionHandler)
}

extension WallabagJSONClient {

    static func handle(result: Result<Any>, completionHandler: WallabagJSONCompletionHandler) {
        switch result {
        case .success(let json):
            self.handleSuccessfulAPICall(for: json, completionHandler: completionHandler)
        case .failure(let error):
            self.handleFailedAPICall(for: error, completionHandler: completionHandler)
        }
    }

    static func handleSuccessfulAPICall(for json: Any, completionHandler: WallabagJSONCompletionHandler) {
        guard let json = json as? [String : Any] else {
          //  let error = NetworkingError.badJSON
           // handleFailedAPICall(for: error, completionHandler: completionHandler)
            return
        }
        completionHandler(Result.success(json))
    }

    static func handleFailedAPICall(for error: Error, completionHandler: WallabagJSONCompletionHandler) {
        completionHandler(Result.failure(error))
    }
}




public class WallabagApi {

    static let sessionManager = SessionManager()
    static var userStorage: UserDefaults!

    enum EntryEndPoint: AlamofireEndPoint {

        case delete(id: Int)
        case add(url: URL)
        case fetchEntry(id: Int)
        case fetch(parameters: [String: Any])
        case update(id: Int, parameters: [String: Any])

        func provideValues() -> (url: String, httpMethod: HTTPMethod, parameters: [String : Any]?, encoding: ParameterEncoding) {
            switch self {
            case .fetchEntry(let id):
                return (url: "\(WallabagApi.getHost()!)/api/entries/\(String(id))", httpMethod: .get, parameters: nil, encoding: URLEncoding.default)
            case .fetch(let parameters):
                return (url: "\(WallabagApi.getHost()!)/api/entries", httpMethod: .get, parameters: parameters, encoding: URLEncoding.default)
            case .delete(let id):
                return (url: "\(WallabagApi.getHost()!)/api/entries/\(String(id))", httpMethod: .delete, parameters: nil, encoding: URLEncoding.default)
            case .add(let url):
                return (url: "\(WallabagApi.getHost()!)/api/entries", httpMethod: .post, parameters: ["url": url.absoluteString], encoding: URLEncoding.default)
            case .update(let id, let parameters):
                return (url: "\(WallabagApi.getHost()!)/api/entries/\(String(id))", httpMethod: .patch, parameters: parameters, encoding: URLEncoding.default)
            }
        }
    }

    public enum Entry: WallabagJSONClient {
        public static func delete(id: Int, _ completionHandler: @escaping WallabagJSONCompletionHandler) {
            WallabagApi.makeAPICall(to: EntryEndPoint.delete(id: id)) { (result) in
                self.handle(result: result, completionHandler: completionHandler)
            }
        }
        public static func add(url: URL, _ completionHandler: @escaping WallabagJSONCompletionHandler) {
            WallabagApi.makeAPICall(to: EntryEndPoint.add(url: url)) { (result) in
                self.handle(result: result, completionHandler: completionHandler)
            }
        }
        public static func fetchEntry(id: Int, _ completionHandler: @escaping WallabagJSONCompletionHandler) {
            WallabagApi.makeAPICall(to: EntryEndPoint.fetchEntry(id: id)) { (result) in
                self.handle(result: result, completionHandler: completionHandler)
            }
        }
        public static func fetch(with parameters: [String: Any], _ completionHandler: @escaping WallabagJSONCompletionHandler) {
            WallabagApi.makeAPICall(to: EntryEndPoint.fetch(parameters: parameters)) { (result) in
                self.handle(result: result, completionHandler: completionHandler)
            }
        }
        public static func update(id: Int, with parameters: [String: Any], _ completionHandler: @escaping WallabagJSONCompletionHandler) {
            WallabagApi.makeAPICall(to: EntryEndPoint.update(id: id, parameters: parameters)) { (result) in
                self.handle(result: result, completionHandler: completionHandler)
            }
        }
    }

    static func makeAPICall(to endPoint: AlamofireEndPoint, completionHandler:@escaping AlamofireJSONCompletionHandler) {
        sessionManager.request(endPoint.url, method: endPoint.httpMethod, parameters: endPoint.parameters, encoding: endPoint.encoding).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(Result.success(value))
            case .failure(let error):
                completionHandler(Result.failure(error))
            }
        }
    }


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
}
