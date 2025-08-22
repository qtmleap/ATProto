//
//  CreateRecordQuery.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Alamofire
import Foundation

/// https://docs.bsky.app/docs/api/com-atproto-repo-create-record
/// Create a single new repository record. Requires auth, implemented by PDS.
final class CreateRecordQuery: RequestType {
    typealias ResponseType = Response
    let method: HTTPMethod = .post
    let path: String = "xrpc/com.atproto.repo.createRecord"
    let parameters: Parameters?

    init(opts: CreateRecordRequest) {
        parameters = [
            "repo": opts.repo,
            "collection": opts.collection,
            "rkey": opts.rkey,
            "validate": opts.validate,
            "record": opts.record.dictionary,
        ]
    }

    struct Response: Decodable {
        let cursor: String
        let feed: [FeedItem]
    }

    struct FeedItem: Decodable {
        //        let post:

        let feedContext: String?
    }
}

struct CreateRecordRequest {
    let repo: String
    let collection: String
    let rkey: String
    let validate: Bool
    let record: Record
    //    let swapCommit: String

    struct Record {
        let type: String
        let text: String
        let createdAt: Date

        var dictionary: [String: Sendable] {
            [
                "$type": type,
                "text": text,
                "createdAt": createdAt,
            ]
        }
    }
}
