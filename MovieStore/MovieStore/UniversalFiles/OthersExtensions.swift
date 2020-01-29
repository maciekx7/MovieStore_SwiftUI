//
//  Extensions.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 11/01/2020.
//  Copyright © 2020 Maciej Krysiak. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

