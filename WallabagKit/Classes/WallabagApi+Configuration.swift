//
//  WallabagApi+Configuration.swift
//  Pods
//
//  Created by maxime marinel on 08/05/2017.
//
//

import Foundation

public extension WallabagApi {
    public static func isConfigured() -> Bool {
        return getHost() != nil && getClientId() != nil && getClientSecret() != nil && getToken() != nil && getRefreshToken() != nil
    }

    public static func configure(host: String) {
        userStorage.set(host, forKey: "host")
    }

    public static func configure(clientId: String, clientSecret: String) {
        userStorage.set(clientId, forKey: "clientId")
        userStorage.set(clientSecret, forKey: "clientSecret")
    }

    public static func set(token: String) {
        userStorage.set(token, forKey: "token")
    }

    public static func set(refreshToken: String) {
        userStorage.set(refreshToken, forKey: "refreshToken")
    }

    public static func getHost() -> String? {
        return userStorage.string(forKey: "host")
    }

    public static func getClientId() -> String? {
        return userStorage.string(forKey: "clientId")
    }

    public static func getClientSecret() -> String? {
        return userStorage.string(forKey: "clientSecret")
    }

    public static func getToken() -> String? {
        return userStorage.string(forKey: "token")
    }

    public static func getRefreshToken() -> String? {
        return userStorage.string(forKey: "refreshToken")
    }

}
