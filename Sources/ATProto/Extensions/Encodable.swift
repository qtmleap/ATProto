//
//  Encodable.swift
//  ATProto
//
//  Created by devonly on 2025/08/22.
//

import Foundation

extension Encodable {
    var base64EncodedString: String {
        let encoder: JSONEncoder = .init()
        return try! encoder.encode(self).base64EncodedString()
    }
}
