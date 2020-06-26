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
    var text: String?
    let isDone: Bool
}

struct PostTodoData: Codable {
    let id: Int?
    var text: String?
    let isDone: Bool
    
    func toTodoData() -> Todo {
        return Todo(id: id ?? 0, text: text ?? "" , isDone: false)
    }
}
