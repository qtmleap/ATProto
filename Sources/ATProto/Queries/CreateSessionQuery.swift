//
//  CreateSessionQuery.swift
//  ATProto
//
//  Created by devonly on 2025/08/21.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

/// https://docs.bsky.app/docs/api/com-atproto-server-create-session
/// Create an authentication session.
public final class CreateSessionQuery: RequestType {
    public typealias ResponseType = Response
    public let method: HTTPMethod = .post
    public let path: String = "xrpc/com.atproto.server.createSession"
    public let parameters: Parameters?

    init(opts: CreateSessionRequest) {
        let parameters: [String: Any?] = [
            "identifier": opts.identifier,
            "password": opts.password,
            "authFactorToken": opts.authFactorToken,
            "allowTakedown": opts.allowTakedown,
        ]
        self.parameters = parameters.compactMapValues { $0 }
    }

    public struct Response: Decodable, Sendable {
        let accessJwt: JWT<AccessToken>
        let refreshJwt: JWT<RefreshToken>
        public let handle: String
        public let did: String
        public let didDoc: DidDoc
        public let email: String?
        public let emailConfirmed: Bool?
        public let emailAuthFactor: Bool?
        public let active: Bool?
        public let status: SessionStatus?
    }

    public struct DidDoc: Decodable, Sendable {
        public let context: [String]
        public let id: String
        public let alsoKnownAs: [String]
        public let verificationMethod: [VerificationMethod]
        public let service: [Service]

        public enum CodingKeys: String, CodingKey {
            case context = "@context"
            case id
            case alsoKnownAs
            case verificationMethod
            case service
        }
    }

    public struct VerificationMethod: Decodable, Sendable {
        public let id: String
        public let type: String
        public let controller: String
        public let publicKeyMultibase: String
    }

    public struct Service: Decodable, Sendable {
        public let id: String
        public let type: String
        public let serviceEndpoint: URL
    }

    public enum SessionStatus: String, CaseIterable, Decodable, Sendable {
        case takedown
        case suspended
        case deactivated
    }
}

public struct CreateSessionRequest {
    let identifier: String
    let password: String
    let authFactorToken: String?
    let allowTakedown: Bool?

    public init(identifier: String, password: String, authFactorToken: String? = nil, allowTakedown: Bool? = nil) {
        self.identifier = identifier
        self.password = password
        self.authFactorToken = authFactorToken
        self.allowTakedown = allowTakedown
    }
}
