@testable import ATProto
import XCTest

final class ATProtoTests: XCTestCase {
    private let agent: AtpAgent = .default
    private let decoder: JSONDecoder = .init()

    func testCreateSession() async throws {
        let data: Data = try .init(forResource: "com.atproto.server.createSession", withExtension: "json")
        let result: CreateSessionQuery.Response = try decoder.decode(CreateSessionQuery.Response.self, from: data)
        print(result)
    }

    func testRefreshSession() async throws {
        let data: Data = try .init(forResource: "com.atproto.server.refreshSession", withExtension: "json")
        let result: CreateSessionQuery.Response = try decoder.decode(CreateSessionQuery.Response.self, from: data)
        print(result)
    }

    func testGetTimeline() async throws {
        let data: Data = try .init(forResource: "app.bsky.feed.getTimeline", withExtension: "json")
        let result: GetTimelineQuery.Response = try decoder.decode(GetTimelineQuery.Response.self, from: data)
        print(result)
    }

    func testGetProfile() async throws {
        let data: Data = try .init(forResource: "app.bsky.actor.getProfile", withExtension: "json")
        let result: GetProfileQuery.Response = try decoder.decode(GetProfileQuery.Response.self, from: data)
        print(result)
    }

    func testGetProfiles() async throws {}
}

extension Data {
    init(forResource name: String, withExtension ext: String) throws {
        guard let contentsOf: URL = Bundle.module.url(forResource: name, withExtension: ext, subdirectory: nil)
        else {
            throw NSError(domain: "ATProtoTests", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resource file not found"])
        }
        try self.init(contentsOf: contentsOf)
    }
}

enum JSON {
    static func parse(_ value: String) -> [String: Any] {
        guard let data: Data = value.data(using: .utf8),
              let object: [String: Any] = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            fatalError(": Invalid JSON format")
        }
        return object
    }
}
