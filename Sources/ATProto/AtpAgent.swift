//
//  AtpAgent.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation
import SwiftUI
import SwiftyLogger
@preconcurrency
import KeychainAccess

@Observable
public final class AtpAgent {
    public static let `default`: AtpAgent = .init()
    private let session: Alamofire.Session = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    private let keychain: Keychain = .init(service: Bundle.main.bundleIdentifier!)
    private var interceptor: AuthenticationInterceptor<AtpAgent>? {
        guard let data: Data = try? keychain.getData("credential")
        else {
            return nil
        }
        guard let credential: AtpCredential = try? decoder.decode(AtpCredential.self, from: data)
        else {
            return nil
        }
        return .init(authenticator: self, credential: credential)
    }

    init(service: String) {
        SwiftyLogger.configure()
    }

    public init() {
        SwiftyLogger.configure()
    }

    private func request<T: RequestType>(_ request: T) async throws -> T.ResponseType {
        let result = await session.request(request, interceptor: interceptor)
            .cURLDescription(calling: { request in
                #if DEBUG || targetEnvironment(simulator)
                SwiftyLogger.debug(request)
                #endif
            })
            .serializingData(automaticallyCancelling: true)
            .result
        switch result {
            case let .success(success):
                do {
                    // デコード可能ならレスポンスを返す
                    return try decoder.decode(T.ResponseType.self, from: success)
                } catch {
                    SwiftyLogger.error(error)
                    // デコード失敗したときはエラーメッセージを返す
                    throw try decoder.decode(BadRequest.self, from: success)
                }
            case let .failure(failure):
                SwiftyLogger.error(failure)
                // Data型が受け取れなければそもそも通信失敗とみなしてエラーをそのまま返す
                throw failure
        }
    }

    func createAccount() async {}

    func resumeSession() async {}

    public func login(
        identifier: String,
        password: String,
        authFactorToken: String? = nil,
        allowTakedown: Bool? = nil,
    ) async throws {
        try await login(opts: .init(identifier: identifier, password: password, authFactorToken: authFactorToken, allowTakedown: allowTakedown))
    }

    func login(opts: CreateSessionRequest) async throws {
        let result = try await request(CreateSessionQuery(opts: opts))
        let data: Data = try encoder.encode(Credential(accessToken: result.accessJwt, refreshToken: result.refreshJwt))
        try keychain.set(data, key: "credential")
    }

    // Feeds and content
    public func getTimeline() async throws -> GetTimelineQuery.Response {
        try await request(GetTimelineQuery())
    }

    func getAuthorFeed() async {}

    func getPostThread() async {}

    func getPost() async {}

    func getPosts() async {}

    func getLikes() async {}

    func getRepostedBy() async {}

    func post() async {}

    func deletePost() async {}

    func like() async {}

    func repost() async {}

    func deleteRepost() async {}

    func uploadBlob() async {}

    // Social graph
    func getFollows() async {}

    func getFollowers() async {}

    func follow() async {}

    func deleteFollow() async {}

    // Actors
    func getProfile() async {}

    func upsertProfile() async {}

    func getProfiles() async {}

    func getSuggestions() async {}

    func searchActors() async {}

    func searchActorsTypeahead() async {}

    func mute() async {}

    func unmute() async {}

    func muteModList() async {}

    func unmuteModList() async {}

    func blockModList() async {}

    func unblockModList() async {}

    // Notifications
    func listNotifications() async {}

    func countUnreadNotifications() async {}

    func updateSeenNotifications() async {}

    // Identity
    func resoloveHandle() async {}

    func updateHandle() async {}
}

extension AtpAgent: Authenticator {
    public typealias Credential = AtpCredential

    public func apply(_ credential: AtpCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken.rawValue))
    }

    public func refresh(_ credential: AtpCredential, for session: Alamofire.Session, completion: @escaping @Sendable (Result<AtpCredential, any Error>) -> Void) {
        completion(.success(credential))
    }

    public func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: AtpCredential) -> Bool {
        true
    }

    public func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        response.statusCode == 401
    }
}
