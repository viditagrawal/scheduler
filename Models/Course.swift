//
//  Course.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation

struct Course : Decodable {
    var title: String
    var description: String
    var instructor: String
    var beginTime: String
    var endTime: String
    var unitsFixed: Int
    var courseID: String
    var enrollCode: String
    var embedding: [Double]
}
