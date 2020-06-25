//
//  API.swift
//  Todo
//
//  Created by 김기현 on 2020/06/25.
//  Copyright © 2020 김기현. All rights reserved.
//

import Foundation

struct Data: Codable {
    let data: [Todo]
    let ok: Bool
}

struct Todo: Codable {
    let id: Int?
    let text: String?
    let idDone: Bool?
}
