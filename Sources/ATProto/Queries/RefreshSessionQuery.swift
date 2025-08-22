//
//  RefreshSessionQuery.swift
//  ATProto
//
//  Created by devonly on 2025/08/21.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

/// https://docs.bsky.app/docs/api/com-atproto-server-refresh-session
/// Refresh an authentication session. Requires auth using the 'refreshJwt' (not the 'accessJwt').
public final class RefreshSessionQuery: RequestType {
    public typealias ResponseType = CreateSessionQuery.Response
    public let method: HTTPMethod = .post
    public let path: String = "xrpc/com.atproto.server.refreshSession"
    public let parameters: Parameters? = nil

    init() {}
}
