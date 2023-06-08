//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mariam Moataz on 05/06/2023.
//

import UIKit
import iOSDropDown
import RxSwift

class ConvertCurrencyViewController: UIViewController {

    @IBOutlet weak var fromDropList: DropDown!
    @IBOutlet weak var toDropList: DropDown!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var convertedValueTxtField: UITextField!
    
    
    private let disposeBag = DisposeBag()
    var viewModel : CurrencyViewModel!
    var sortedCurrencies : [String] = []
    var rates : [String : Double] = [:]
    var theCurrencies = (0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTxtField.delegate = self

        let base = EndPoints.base
        viewModel = CurrencyViewModel(url: base.fullPath)
        
        
        viewModel.currencies.observe(on: MainScheduler.instance).subscribe { [weak self] currencyResponse in
            
            guard let rates = currencyResponse.element?.rates else { return }
            self?.rates = rates
            
            self?.sortedCurrencies = rates.keys.map{String($0)}
            self?.sortedCurrencies.sort()
            
            self?.fromDropList.optionArray = rates.keys.map {String($0)}
            self?.toDropList.optionArray = rates.keys.map {String($0)}
            
            self?.fromDropList.optionArray.sort()
            self?.toDropList.optionArray.sort()
            self?.fromDropList.reloadInputViews()
            self?.toDropList.reloadInputViews()
            
            self?.fromDropList.text = self?.sortedCurrencies[0]
            self?.toDropList.text = self?.sortedCurrencies[1]
            let baseCurrency = rates[(self?.fromDropList.text!)!] ?? 1.0
            let targetCurrency = rates[(self?.toDropList.text!)!] ?? 1.0
            
            self?.theCurrencies.0 = baseCurrency
            self?.theCurrencies.1 = targetCurrency
            
            self?.convertedValueTxtField.text = self?.viewModel.doCurrencyOperation(baseCurrency: (self?.fromDropList.text!)!, baseCurrencyRate: baseCurrency, targetCurrency: (self?.toDropList.text!)!, targetCurrencyRate: targetCurrency, amount: 1.0)
        }.disposed(by: disposeBag)

        fromDropList.didSelect { selectedText, index, id in
            self.fromDropList.text = selectedText
            self.amountTxtField.text = "1"
            self.theCurrencies.0 = self.rates[selectedText] ?? 1.0
            self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (selectedText), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (self.toDropList.text!), targetCurrencyRate: self.theCurrencies.1, amount: 1.0)
        }
        
        toDropList.didSelect { selectedText, index, id in
            self.toDropList.text = selectedText
            self.amountTxtField.text = "1"
            self.theCurrencies.1 = self.rates[selectedText] ?? 1.0
            self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (self.fromDropList.text!), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (selectedText), targetCurrencyRate: self.theCurrencies.1, amount: 1.0)
        }
        
        
        fromDropList.listWillAppear {
            self.fromDropList.selectedIndex = 0
            self.fromDropList.text = self.sortedCurrencies[0]
        }
        
        toDropList.listWillAppear {
            self.toDropList.selectedIndex = 1
            self.toDropList.text = self.sortedCurrencies[1]
        }
        
        
        
    }
    
    
    
    @IBAction func swapBtn(_ sender: Any) {
    }
    
    
    @IBAction func detailsBtn(_ sender: Any) {
    }
    
}

extension ConvertCurrencyViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == amountTxtField{
            let baseRate = rates[fromDropList.text!]!
            let targetRate = rates[toDropList.text!]!
            
            if let amount = Double(textField.text!) {
                convertedValueTxtField.text = viewModel.doCurrencyOperation(baseCurrency: fromDropList.text!, baseCurrencyRate: baseRate, targetCurrency: toDropList.text!, targetCurrencyRate: targetRate, amount: amount)
            }
            else {
                print("Not a valid number: \(textField.text!)")
            }
            
            
        }
    }
    
}
