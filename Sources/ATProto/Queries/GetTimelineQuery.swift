//
//  GetTimelineQuery.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

/// https://docs.bsky.app/docs/api/app-bsky-feed-get-timeline
/// Get a view of the requesting account's home timeline. This is expected to be some form of reverse-chronological feed.
public final class GetTimelineQuery: RequestType {
    public typealias ResponseType = Response
    public let method: HTTPMethod = .get
    public let path: String = "xrpc/app.bsky.feed.getTimeline"
    public let parameters: Parameters?

    init() {
        parameters = nil
    }

    init(opts: GetTimelineRequest) {
        parameters = [
            "algorithm": opts.algorithm,
            "limit": opts.limit ?? 50,
            "cursor": opts.cursor,
        ]
    }

    public struct Response: Codable, Sendable {
        public let feed: [FeedElement]
        public let cursor: String?
    }

    public struct FeedElement: Codable, Sendable {
        public let post: Post
        public let reply: FeedReply?
        public let reason: Reason?
    }

    public struct Post: Codable, Sendable {
        public let uri: String
        public let cid: String
        public let author: Author
        public let record: Record
        public let replyCount: Int
        public let repostCount: Int
        public let likeCount: Int
        public let quoteCount: Int
        public let indexedAt: String
//        public let viewer: PostViewer
//        public let labels: [JSONAny]
//        public let embed: Embed?
//        public let threadgate: Threadgate?
    }

    public struct Author: Codable, Sendable {
        public let did: String
        public let handle: String
        public let displayName: String
        public let avatar: String
//        public let associated: Associated
//        public let viewer: ByViewer
        public let labels: [Label]
        public let createdAt: String
//        public let verification: AuthorVerification?
    }

    public struct Label: Codable, Sendable {
        public let src: String
        public let uri: String
        public let cid: String
//        public let val: Val
        public let cts: String
    }

    public struct Embed: Codable, Sendable {
        public let type: EmbedType
        public let images: [EmbedImage]?
        public let record: Record?
//        public let external: PurpleExternal?
//        public let media: PurpleMedia?

        public enum EmbedType: String, Codable, Sendable {
            case appBskyEmbedExternalView = "app.bsky.embed.external#view"
            case appBskyEmbedImagesView = "app.bsky.embed.images#view"
            case appBskyEmbedRecordView = "app.bsky.embed.record#view"
            case appBskyEmbedRecordWithMediaView = "app.bsky.embed.recordWithMedia#view"
            case appBskyEmbedVideoView = "app.bsky.embed.video#view"
        }

        public enum CodingKeys: String, CodingKey, Sendable {
            case type = "$type"
            case images
            case record
//            case external = "external"
//            case media = "media"
        }
    }

    public struct EmbedImage: Codable, Sendable {
        public let thumb: String
        public let fullsize: String
        public let alt: String
//        public let aspectRatio: AspectRatio
    }

    public struct Record: Codable, Sendable {
        public let type: String?
        public let uri: String?
        public let cid: String?
        public let author: Author?
//        public let value: TentacledValue?
//        public let labels: [JSONAny]?
        public let likeCount: Int?
        public let replyCount: Int?
        public let repostCount: Int?
        public let quoteCount: Int?
        public let indexedAt: String?
//        public let embeds: [FluffyMedia]?
        public let did: String?
//        public let creator: Creator?
        public let displayName: String?
        public let description: String?
        public let avatar: String?
//        public let viewer: RecordViewer?
//        public let record: FluffyRecord?

        public enum CodingKeys: String, CodingKey, Sendable {
            case type = "$type"
            case uri
            case cid
            case author
//            case value = "value"
//            case labels = "labels"
            case likeCount
            case replyCount
            case repostCount
            case quoteCount
            case indexedAt
//            case embeds = "embeds"
            case did
//            case creator = "creator"
            case displayName
            case description
            case avatar
//            case viewer = "viewer"
//            case record = "record"
        }
    }

    public struct Reason: Codable, Sendable {
        public let type: ReasonType
        public let by: Author
        public let uri: String
        public let cid: String
        public let indexedAt: String

        public enum ReasonType: String, Codable, Sendable {
            case appBskyFeedDefsReasonRepost = "app.bsky.feed.defs#reasonRepost"
        }

        public enum CodingKeys: String, CodingKey {
            case type = "$type"
            case by
            case uri
            case cid
            case indexedAt
        }
    }

    public struct FeedReply: Codable, Sendable {}
}

struct GetTimelineRequest {
    let algorithm: String?
    let limit: Int?
    let cursor: String?
}
