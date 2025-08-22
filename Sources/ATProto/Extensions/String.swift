//
//  String.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Foundation

public extension String {
    var base64DecodedString: String? {
        let formatedString: String = self + Array(repeating: "=", count: count % 4).joined()
        if let data = Data(base64Encoded: formatedString, options: [.ignoreUnknownCharacters]) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    var base64EncodedString: String {
        data(using: .utf8)!.base64EncodedString(options: [])
    }
}
