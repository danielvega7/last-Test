//
//  Movie Class.swift
//  last Test
//
//  Created by DANIEL VEGA on 3/9/22.
//

import Foundation
import Firebase

public class Movie: Codable {
    var name: String
    var votes: Int
    init(n: String, v: Int){
        name = n
        votes = v
    }
}
