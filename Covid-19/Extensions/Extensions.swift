//
//  Extensions.swift
//  Covid-19
//
//  Created by Yauheni Bunas on 5/30/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SwiftUI

extension CGFloat {
    static func getGeometryReaderHeight(value: Int, lastValue: Int, height: CGFloat) ->CGFloat {
        if lastValue != 0 {
            let converted = CGFloat(value) / CGFloat(lastValue)
            
            return converted * height
        }
        
        return 0
    }
}
