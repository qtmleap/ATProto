//
//  GetProfilesQuery.swift
//  ATProto
//
//  Created by devonly on 2025/08/21.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

/// https://docs.bsky.app/docs/api/app-bsky-actor-get-profiles
/// Get detailed profile views of multiple actors.
final class GetProfilesQuery: RequestType {
    typealias ResponseType = Response
    let method: HTTPMethod = .get
    let path: String = "xrpc/app.bsky.actor.getProfiles"
    let parameters: Parameters?

    init(opts: GetProfilesRequest) {
        parameters = [
            "actors": opts.actors,
        ]
    }

    struct Response: Decodable {
        let profiles: [GetProfilesQuery.Response]
    }
}

struct GetProfilesRequest {
    let actors: [String]
}
