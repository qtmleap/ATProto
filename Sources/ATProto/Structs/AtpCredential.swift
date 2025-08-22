//
//  AtpCredential.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//

import Alamofire
import Foundation

public struct AtpCredential: AuthenticationCredential, Codable, Sendable {
    let accessToken: JWT<AccessToken>
    let refreshToken: JWT<RefreshToken>

    public var requiresRefresh: Bool {
        accessToken.payload.exp < Int(Date.now.timeIntervalSince1970)
    }

    init(accessToken: JWT<AccessToken>, refreshToken: JWT<RefreshToken>) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
