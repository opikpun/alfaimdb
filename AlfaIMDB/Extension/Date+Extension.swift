//
//  Date+Extension.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import Foundation

extension Date {
    
    func string(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
        
    }
    
}
