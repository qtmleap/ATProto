//
//  RequestType.swift
//  ATProto
//
//  Created by devonly on 2025/08/21.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

public protocol RequestType: URLRequestConvertible, Sendable {
    associatedtype ResponseType: Decodable, Sendable

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

public extension RequestType {
    var encoding: ParameterEncoding {
        switch method {
            case .get:
                URLEncoding.default
            case .post:
                JSONEncoding.default
            default:
                URLEncoding.default
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var parameters: Parameters? {
        nil
    }

    var baseURL: URL {
        .init(string: "https://bsky.social")!
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.allHTTPHeaderFields = headers?.dictionary
        return try encoding.encode(request, with: parameters)
    }
}
