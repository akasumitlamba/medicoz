//
//  appointmentModel.swift
//  medicoz
//
//  Created by Sachin Sharma on 24/01/23.
//

import Foundation

struct appointmentModel {
    var id: Int
    var title: doctorTitle
    var image: String
    var type: String
    var time: String
    var color: String
}

enum doctorTitle: String {
    case ayush, Api, poldu, golu
}
