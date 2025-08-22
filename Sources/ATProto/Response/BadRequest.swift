//
//  BadRequest.swift
//  ATProto
//
//  Created by devonly on 2025/08/21.
//  Copyright © 2025 QuantumLeap, Corporation. All rights reserved.
//

import Foundation

struct BadRequest: Decodable, Error {
    let error: String
    let message: String
}
