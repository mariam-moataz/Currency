//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mariam Moataz on 05/06/2023.
//

import UIKit
import iOSDropDown
import RxSwift
import Network

class ConvertCurrencyViewController: UIViewController {

    @IBOutlet weak var fromDropList: DropDown!
    @IBOutlet weak var toDropList: DropDown!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var convertedValueTxtField: UITextField!
    @IBOutlet weak var swapOutlet: UIButton!
    @IBOutlet weak var detailsOutlet: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel : CurrencyViewModel!
    var sortedCurrencies : [String] = []
    var rates : [String : Double] = [:]
    var theCurrencies = (0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTxtField.delegate = self
        amountTxtField.keyboardType = .numberPad
        let base = EndPoints.base
        viewModel = CurrencyViewModel(url: base.fullPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let monitor = NWPathMonitor()
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                DispatchQueue.main.async {
                    self.loadData()
                    self.fromDropList.dropDownDefaultStyling()
                    self.toDropList.dropDownDefaultStyling()
                    self.fromDropList.didSelect { selectedText, index, id in
                        self.fromDropList.text = selectedText
                        self.amountTxtField.text = "1"
                        self.theCurrencies.0 = self.rates[selectedText] ?? 1.0
                        self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (selectedText), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (self.toDropList.text!), targetCurrencyRate: self.theCurrencies.1, amount: 1.0)
                        
                        //save to coreData
                        self.callViewModelTosave()
                    }
                    
                    self.toDropList.didSelect { selectedText, index, id in
                        self.toDropList.text = selectedText
                        self.amountTxtField.text = "1"
                        self.theCurrencies.1 = self.rates[selectedText] ?? 1.0
                        self.convertedValueTxtField.text = self.viewModel.doCurrencyOperation(baseCurrency: (self.fromDropList.text!), baseCurrencyRate: self.theCurrencies.0, targetCurrency: (selectedText), targetCurrencyRate: self.theCurrencies.1, amount: 1.0)
                        
                        //save to coreData
                        self.callViewModelTosave()
                    }
                    
                    self.fromDropList.selectedIndex = 0
                    self.toDropList.selectedIndex = 1
                }
            }
            else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Check intertnet connection then restart the app", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.amountTxtField.isEnabled = false
                        self.convertedValueTxtField.isEnabled = false
                        self.fromDropList.isEnabled = false
                        self.toDropList.isEnabled = false
                        self.swapOutlet.isEnabled = false
                        self.detailsOutlet.isEnabled = false
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
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
        let vc = self.storyboard?.instantiateViewController(identifier: "details") as! DetailsViewController
        vc.rates = rates
        vc.baseCurrency = fromDropList.text
        vc.amount = amountTxtField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData(){
        viewModel.currencies?.observe(on: MainScheduler.instance).subscribe { [weak self] currencyResponse in
            
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
    }
}

extension ConvertCurrencyViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        let vm = ViewModelFormatter()
        if let input = textField.text{
            if !vm.isNumeber(input) {
                let alert = UIAlertController(title: "Alert", message: "Please enter a valid number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    textField.text = ""
                    self.convertedValueTxtField.text = ""
                }))
                self.present(alert, animated: true)
                }
        }
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
        guard fromDropList.text != "", toDropList.text != "" else {return}
        self.viewModel.save(appDel: AppDelegate(), baseCur: (self.fromDropList.text!), targetCur: (self.toDropList.text!), amount: (self.amountTxtField.text ?? "0.0"), amountConverted: (self.convertedValueTxtField.text ?? "0.0"))
    }
}
