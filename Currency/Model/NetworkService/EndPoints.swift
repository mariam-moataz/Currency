//
//  EndPoints.swift
//  Currency
//
//  Created by Mariam Moataz on 07/06/2023.
//

import Foundation

enum EndPoints{
    
    private var key : String {
        //return "48077b55b55d82ccb7c21382a249b725"
        return "974fbb215f382acec6384896ac2a3a2a"
        
    }
    
    private var baseURL : String { return "http://data.fixer.io/api/latest?access_key=\(key)"}
        
    case base
    //case convertEndPoint(from:String, to:String, amount : Double)
    
        var fullPath : String{
            var endPoint : String
            switch self{
            case .base:
                endPoint = baseURL
//            case .convertEndPoint(from: let from, to: let to, amount: let amount):
//                endPoint = baseURL + "& from = \(from)& to = JPY"
            }
            return endPoint
        }
}
