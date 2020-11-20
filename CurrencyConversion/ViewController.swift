//
//  ViewController.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.start()
    }


}

