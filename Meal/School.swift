//
//  School.swift
//  Meal
//
//  Created by almond on 2017. 1. 2..
//  Copyright © 2017년 almond. All rights reserved.
//

struct School {
    var code: String
    var name: String
    var type: String
    
    init?(dictionary: [String: Any]) {
        guard let code = dictionary["code"] as? String,
            let name = dictionary["name"] as? String,
            let type = dictionary["type"] as? String
            else { return nil }
        
        self.code = code
        self.name = name
        self.type = type
    }
}
