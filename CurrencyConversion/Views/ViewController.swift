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
    @IBOutlet weak var tbvResult: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    
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
        
        tbvResult.register(UINib(nibName: String.init(describing: ResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: String.init(describing: ResultTableViewCell.self))
    }
    
    func setupTFCurrency() {
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
        
        tfAmount?.rx.text
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.amountDidUpdate(amount: text ?? "")
            }).disposed(by: disposeBag)
        
        viewModel.results
            .bind(to: tbvResult.rx.items(cellIdentifier: String(describing: ResultTableViewCell.self), cellType: ResultTableViewCell.self)) { (_, cellViewModel, cell) in
                cell.set(viewModel: cellViewModel)
            }.disposed(by: disposeBag)
        
        tbvResult.rx.didScroll.subscribe { [weak self] _ in
            self?.tfCurrency?.resignFirstResponder()
            self?.tfAmount?.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            if isLoading {
                self?.activityIndicatorView?.startAnimating()
            } else {
                self?.activityIndicatorView?.stopAnimating()
            }
        }).disposed(by: disposeBag)
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

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789.").inverted) != nil {
            return false
        }
        
        if let text = textField.text, let range = Range(range, in: text) {
            let newText = text.replacingCharacters(in: range, with: string)
            do {
                let regex = try NSRegularExpression(pattern: "^\\d*\\.?\\d*$", options: .anchorsMatchLines)
                return regex.matches(in: newText, options: .anchored, range: NSRange(location: 0, length: newText.count)).count > 0
            } catch {}
        }
        
        return true
    }
}
