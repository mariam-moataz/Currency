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
            //save to coreData
            self?.callViewModelTosave()
            
        }.disposed(by: disposeBag)

        fromDropList.didSelect { selectedText, index, id in
            self.fromDropList.text = selectedText
            self.amountTxtField.text = "1"
            self.theCurrencies.0 = self.rates[selectedText] ?? 1.0
            self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (selectedText), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (self.toDropList.text!), targetCurrencyRate: self.theCurrencies.1, amount: 1.0)
            
            //save to coreData
            self.callViewModelTosave()
        }
        
        toDropList.didSelect { selectedText, index, id in
            self.toDropList.text = selectedText
            self.amountTxtField.text = "1"
            self.theCurrencies.1 = self.rates[selectedText] ?? 1.0
            self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (self.fromDropList.text!), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (selectedText), targetCurrencyRate: self.theCurrencies.1, amount: 1.0)
            
            //save to coreData
            self.callViewModelTosave()
        }
        
        fromDropList.selectedIndex = 0
        toDropList.selectedIndex = 1
    }
    
    
    
    @IBAction func swapBtn(_ sender: Any) {
        guard let fromIndex = fromDropList.selectedIndex, let toIndex = toDropList.selectedIndex else {
               return
        }
        
        let fromValue = fromDropList.text
        let toValue = toDropList.text
        fromDropList.selectedIndex = toIndex
        fromDropList.text = toValue
        toDropList.selectedIndex = fromIndex
        toDropList.text = fromValue
        
        self.theCurrencies.0 = rates[fromDropList.text!] ?? 1.0
        self.theCurrencies.1 = rates[toDropList.text!] ?? 1.0
        
        self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (self.fromDropList.text!), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (self.fromDropList.text!), targetCurrencyRate: self.theCurrencies.1, amount: Double(amountTxtField.text ?? "") ?? 1.0)
        //save to coreData
        self.callViewModelTosave()
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
                
                //save to coreData
                callViewModelTosave()
            }
            else {
                print("Not a valid number: \(textField.text!)")
            }
            
            
        }
    }
    
}


extension ConvertCurrencyViewController{
    
    func callViewModelTosave(){
        self.viewModel.save(appDel: AppDelegate(), baseCur: (self.fromDropList.text!), targetCur: (self.toDropList.text!), amount: (self.amountTxtField.text ?? "0.0"), amountConverted: (self.convertedValueTxtField.text ?? "0.0"))
    }
}
