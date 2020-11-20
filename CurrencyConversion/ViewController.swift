//
//  ViewController.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tfCurrency: UITextField?
    @IBOutlet weak var tfAmount: UITextField?
    
    let currencyPickerView = UIPickerView()
    
    let viewModel = ViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.start()
        
        initUI()
        binding()
    }
    
    func initUI() {
        setupTFCurrency()
    }
    
    func setupTFCurrency() {
        tfCurrency?.placeholder = "Currency"
        tfCurrency?.inputView = currencyPickerView
        tfCurrency?.inputAccessoryView = toolbarForDataPicker(selector: #selector(currencyPickerDoneDidClick))
    }
    
    func binding() {
        viewModel.currencies.bind(to: currencyPickerView.rx.itemTitles) { (row, elements) in
            return "\(elements.code) - \(elements.name)"
        }.disposed(by: disposeBag)
        
        currencyPickerView.rx.itemSelected.subscribe(onNext: { [weak self] value in
            self?.viewModel.currencyDidSelect(index: value.row)
        }).disposed(by: disposeBag)
        
        viewModel.currencyText.subscribe { [weak self] currencyText in
            self?.tfCurrency?.text = currencyText
        }.disposed(by: disposeBag)
    }
    
    @objc func currencyPickerDoneDidClick() {
        tfAmount?.becomeFirstResponder()
        viewModel.currencyDidSelect(index: currencyPickerView.selectedRow(inComponent: 0))
    }
    
    private func toolbarForDataPicker(selector: Selector?) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpaceButton, doneButton], animated: false)
        return toolbar
    }
}

