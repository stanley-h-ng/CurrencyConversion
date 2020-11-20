//
//  ResultTableViewCell.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet var lblCurrency: UILabel?
    @IBOutlet var lblAmount: UILabel?
    
    func set(viewModel: ResultCellViewModel) {
        lblCurrency?.text = viewModel.currency
        lblAmount?.text = viewModel.amount
    }
    
}
