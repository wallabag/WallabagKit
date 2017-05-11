//
//  WallabagApi+Wrapped.swift
//  Pods
//
//  Created by maxime marinel on 09/05/2017.
//
//

import Foundation
import Alamofire

extension WallabagApi {

    public static func deleteArticle(_ article: Article, completion: @escaping() -> Void) {
        sessionManager.request(getHost()! + "/api/entries/" + String(article.id), method: .delete).validate().responseJSON { _ in
            completion()
        }
    }

    public static func patchArticle(_ article: Article, withParamaters withParameters: [String: Any], completion: @escaping(_ article: Article) -> Void) {
        sessionManager.request(getHost()! + "/api/entries/" + String(article.id), method: .patch, parameters: withParameters)
            .validate()
            .responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    completion(Article(fromDictionary: JSON))
                }
        }
    }

}
