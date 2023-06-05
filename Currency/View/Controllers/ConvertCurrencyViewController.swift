//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mariam Moataz on 05/06/2023.
//

import UIKit
import iOSDropDown

class ConvertCurrencyViewController: UIViewController {

    @IBOutlet weak var fromDropList: DropDown!
    @IBOutlet weak var toDropList: DropDown!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var convertedValueTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // fromDropList.frame(forAlignmentRect: CGRect(x: 110, y: 140, width: 200, height: 30))
        fromDropList.optionArray = ["1","2","3"]
    }
    
    
    @IBAction func swapBtn(_ sender: Any) {
    }
    
    
    @IBAction func detailsBtn(_ sender: Any) {
    }
    
}
