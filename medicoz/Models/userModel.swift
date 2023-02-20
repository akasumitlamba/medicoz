//
//  userModel.swift
//  medicoz
//
//  Created by Sachin Sharma on 11/02/23.
//

import Foundation

struct Users: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var gender: String
    var mobile_No: String
    var age: Int
    var weight: Int
    var bg: String
}
