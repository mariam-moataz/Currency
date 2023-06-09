//
//  EndPoints.swift
//  Currency
//
//  Created by Mariam Moataz on 07/06/2023.
//

import Foundation

enum EndPoints{
    
    private var key : String {
        return "974fbb215f382acec6384896ac2a3a2a"
        
    }
    
    private var baseURL : String { return "http://data.fixer.io/api/latest?access_key=\(key)"}
        
    case base
    
    var fullPath : String{
        var endPoint : String
        switch self{
        case .base:
            endPoint = baseURL
        }
        return endPoint
    }
}
