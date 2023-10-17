//
//  State.swift
//  cargo
//
//  Created by Apple on 10/16/23.
//

import Foundation

struct UState {
    
    var name = ""
    var abbreviation = ""
    
    init() {
        
    }
    
    init(name: String, abbreviation: String) {
        self.name = name
        self.abbreviation = abbreviation
    }
    
    public static let states: [UState] = [
        UState(name: "Alabama", abbreviation: "AL"),
        UState(name: "Alaska", abbreviation: "AK"),
        UState(name: "Arizona", abbreviation: "AZ"),
        UState(name: "Arkansas", abbreviation: "AR"),
        UState(name: "American Samoa", abbreviation: "AS"),
        UState(name: "California", abbreviation: "CA"),
        UState(name: "Colorado", abbreviation: "CO"),
        UState(name: "Connecticut", abbreviation: "CT"),
        UState(name: "Delaware", abbreviation: "DE"),
        UState(name: "District of Columbia", abbreviation: "DC"),
        UState(name: "Florida", abbreviation: "FL"),
        UState(name: "Georgia", abbreviation: "GA"),
        UState(name: "Guam", abbreviation: "GU"),
        UState(name: "Hawaii", abbreviation: "HI"),
        UState(name: "Idaho", abbreviation: "ID"),
        UState(name: "Illinois", abbreviation: "IL"),
        UState(name: "Indiana", abbreviation: "IN"),
        UState(name: "Iowa", abbreviation: "IA"),
        UState(name: "Kansas", abbreviation: "KS"),
        UState(name: "Kentucky", abbreviation: "KY"),
        UState(name: "Louisiana", abbreviation: "LA"),
        UState(name: "Maine", abbreviation: "ME"),
        UState(name: "Maryland", abbreviation: "MD"),
        UState(name: "Massachusetts", abbreviation: "MA"),
        UState(name: "Michigan", abbreviation: "MI"),
        UState(name: "Minnesota", abbreviation: "MN"),
        UState(name: "Mississippi", abbreviation: "MS"),
        UState(name: "Missouri", abbreviation: "MO"),
        UState(name: "Montana", abbreviation: "MT"),
        UState(name: "Nebraska", abbreviation: "NE"),
        UState(name: "Nevada", abbreviation: "NV"),
        UState(name: "New Hampshire", abbreviation: "NH"),
        UState(name: "New Jersey", abbreviation: "NJ"),
        UState(name: "New Mexico", abbreviation: "NM"),
        UState(name: "New York", abbreviation: "NY"),
        UState(name: "North Carolina", abbreviation: "NC"),
        UState(name: "North Dakota", abbreviation: "ND"),
        UState(name: "Northern Mariana Islands", abbreviation: "MP"),
        UState(name: "Ohio", abbreviation: "OH"),
        UState(name: "Oklahoma", abbreviation: "OK"),
        UState(name: "Oregon", abbreviation: "OR"),
        UState(name: "Pennsylvania", abbreviation: "PA"),
        UState(name: "Puerto Rico", abbreviation: "PR"),
        UState(name: "Rhode Island", abbreviation: "RI"),
        UState(name: "South Carolina", abbreviation: "SC"),
        UState(name: "South Dakota", abbreviation: "SD"),
        UState(name: "Tennessee", abbreviation: "TN"),
        UState(name: "Texas", abbreviation: "TX"),
        UState(name: "Trust Territories", abbreviation: "TT"),
        UState(name: "Utah", abbreviation: "UT"),
        UState(name: "Vermont", abbreviation: "VT"),
        UState(name: "Virginia", abbreviation: "VA"),
        UState(name: "Virgin Islands", abbreviation: "VI"),
        UState(name: "Washington", abbreviation: "WA"),
        UState(name: "West Virginia", abbreviation: "WV"),
        UState(name: "Wisconsin", abbreviation: "WI"),
        UState(name: "Wyoming", abbreviation: "WY"),
    ]
    
    
}
