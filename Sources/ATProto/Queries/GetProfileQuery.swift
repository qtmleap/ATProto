//
//  GetProfileQuery.swift
//  ATProto
//
//  Created by devonly on 2025/08/21.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

/// https://docs.bsky.app/docs/api/app-bsky-actor-get-profile
/// Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth.
final class GetProfileQuery: RequestType {
    typealias ResponseType = Response
    let method: HTTPMethod = .get
    let path: String = "xrpc/app.bsky.actor.getProfile"
    let parameters: Parameters?

    init(opts: GetProfileRequest) {
        parameters = [
            "actor": opts.actor,
        ]
    }

    struct Response: Decodable, Sendable {
        let did: String
        let handle: String
        let displayName: String
        let avatar: URL
//        public let associated: Associated
        let viewer: Viewer
//        public let labels: [JSONAny]
//        public let createdAt: String
        let description: String
//        public let indexedAt: String
        let followersCount: Int
        let followsCount: Int
        let postsCount: Int
    }

    struct Viewer: Decodable, Sendable {
        let muted: Bool
        let blockedBy: Bool
    }
}

struct GetProfileRequest {
    let actor: String
}
