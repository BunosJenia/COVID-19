//
//  Models.swift
//  Covid-19
//
//  Created by Yauheni Bunas on 5/29/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SwiftUI

struct Daily: Identifiable {
    var id: Int
    var day: String
    var cases: Int
}

struct MainData: Decodable {
    var deaths: Int
    var recovered: Int
    var active: Int
    var critical: Int
    var cases: Int
}

struct MyCountry: Decodable {
    var timeline: [String: [String: Int]]
}

struct Global: Decodable {
    var cases: [String: Int]
}
