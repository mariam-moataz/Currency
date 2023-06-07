//
//  CurrencyResponse.swift
//  Currency
//
//  Created by Mariam Moataz on 06/06/2023.
//

import Foundation

struct CurrencyResponse : Decodable{
    var success : Bool?
    var timestamp : Int?
    var base : String?
    var date : String?
    var rates : [String : Double]?
}
