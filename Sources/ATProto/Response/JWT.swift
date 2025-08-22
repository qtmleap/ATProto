//
//  JWT.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Foundation

struct JWT<Payload: Codable>: Codable, Sendable where Payload: Sendable {
    let header: Header
    let payload: Payload
    let signature: String
    let rawValue: String

    struct Header: Codable, Sendable {
        let typ: String
        let alg: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value: String = try container.decode(String.self)
        let values: [String] = value.split(separator: ".").map(String.init)
        if values.count < 3 {
            throw NSError(domain: "Json Web Token", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JWT format"])
        }
        let data: [Data] = values.compactMap(\.base64DecodedString).compactMap { $0.data(using: .utf8) }
        let decoder: JSONDecoder = .init()
        decoder.dateDecodingStrategy = .secondsSince1970
        header = try! decoder.decode(Header.self, from: data[0])
        payload = try! decoder.decode(Payload.self, from: data[1])
        signature = values[2]
        rawValue = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    init(_ value: String) throws {
        let values: [String] = value.split(separator: ".").map(String.init)
        if values.count < 3 {
            throw NSError(domain: "Json Web Token", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JWT format"])
        }
        let data: [Data] = values.compactMap(\.base64DecodedString).compactMap { $0.data(using: .utf8) }
        let decoder: JSONDecoder = .init()
        decoder.dateDecodingStrategy = .secondsSince1970
        header = try! decoder.decode(Header.self, from: data[0])
        payload = try! decoder.decode(Payload.self, from: data[1])
        signature = values[2]
        rawValue = value
    }
}

struct AccessToken: Codable, Sendable {
    let scope: String
    let sub: String
    let aud: String
    let iat: Int
    let exp: Int
}

struct RefreshToken: Codable, Sendable {
    let scope: String
    let sub: String
    let jti: String
    let iat: Int
    let exp: Int
}
