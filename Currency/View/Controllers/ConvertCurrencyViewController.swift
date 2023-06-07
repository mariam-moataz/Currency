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
    
    let viewModel = CurrencyViewModel()
    let disposeBag = DisposeBag()
    var currencies : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDropList.optionArray = ["1","2"]
        viewModel.currencies.observe(on: MainScheduler.instance).subscribe { [weak self] currencyResponse in
            guard let rates = currencyResponse.element?.rates else { return }
            self?.currencies = rates.keys.map {String($0)}
            self?.fromDropList.optionArray = self?.currencies ?? []
            //self?.fromDropList.reloadInputViews()
        }.disposed(by: disposeBag)
        fromDropList.optionArray = currencies
    }
    
    
    @IBAction func swapBtn(_ sender: Any) {
    }
    
    
    @IBAction func detailsBtn(_ sender: Any) {
    }
    
}


