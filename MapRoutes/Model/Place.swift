//
//  Place.swift
//  MapRoutes
//
//  Created by 이연정 on 2023/07/13.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
}
