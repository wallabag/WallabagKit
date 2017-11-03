//
//  BearerTokenAdapter.swift
//  WallabagKitPackageDescription
//
//  Created by maxime marinel on 05/12/2017.
//

import Alamofire
import Foundation

class BearerTokenAdapter: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    private var clientID: String
    private var clientSecret: String
    private var username: String
    private var password: String
    private var baseURLString: String
    private var accessToken: String?
    private var refreshToken: String?

    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

    public init(baseURLString: String, clientID: String, clientSecret: String, username: String, password: String) {
        self.baseURLString = baseURLString
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.username = username
        self.password = password
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let accessToken = accessToken else {
            return urlRequest
        }
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)

            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }

                    if let accessToken = accessToken, let refreshToken = refreshToken {
                        strongSelf.accessToken = accessToken
                        strongSelf.refreshToken = refreshToken
                    }

                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }

    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }

        isRefreshing = true

        let urlString = "\(baseURLString)/oauth/v2/token"

        /*let parameters: [String: Any] = [
            "refresh_token": refreshToken,
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": "refresh_token"
        ]*/

        let parameters: [String: Any] = [
            "grant_type": "password",
            "client_id": clientID,
            "client_secret": clientSecret,
            "username": username,
            "password": password
        ]

        sessionManager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }

                print(response)
                if
                    let json = response.result.value as? [String: Any],
                    let accessToken = json["access_token"] as? String,
                    let refreshToken = json["refresh_token"] as? String
                {
                    print("success")
                    completion(true, accessToken, refreshToken)
                } else {

                    print("fail")
                    completion(false, nil, nil)
                }
                strongSelf.isRefreshing = false
        }
    }
}
