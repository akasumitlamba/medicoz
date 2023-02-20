//
//  mostPopularModel.swift
//  medicoz
//
//  Created by Sachin Sharma on 19/02/23.
//

import Foundation

struct catagoryModel {
    var id: Int
    var title: catagoryTitle
    var image: String
    var color: String
}

enum catagoryTitle: String {
    case Diagnostic, Shots, Consultation, Ambulance, Nurse, Medical_History
}
