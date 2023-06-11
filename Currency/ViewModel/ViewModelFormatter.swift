//
//  ViewModelFormatter.swift
//  Currency
//
//  Created by Mariam Moataz on 10/06/2023.
//

import Foundation

class ViewModelFormatter{
    
    func convertDate(date : Date?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date ?? Date())
        return dateString
    }
    
    func isNumeber(_ string: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string) != nil
    }
}
