//
//  LoanTransaction.swift
//  Trackine
//
//  Created by Dayton on 22/04/21.
//

import Foundation

protocol LoanTransaction: AnyObject {
    
    func updateResultToCoreData(_ loan: Loan)
}
