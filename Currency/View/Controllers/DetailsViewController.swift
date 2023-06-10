//
//  DetailsViewController.swift
//  Currency
//
//  Created by Mariam Moataz on 06/06/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var historicalDataTableView: UITableView!
    @IBOutlet weak var otherCurrenciesTableView: UITableView!
    
    //historicalDataTableView
    let viewModel = CurrencyViewModel()
    var info : [Int : [ExchangeInfo]]?
    
    //otherCurrenciesTableView
    //let otherCurrenciesVM = OtherCurrenciesViewModel()
    var baseCurrency : String?
    var amount : String?
    var rates : [String : Double] = [:]
    var popularCurrencies : [ExchangeInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historicalDataTableView.delegate = self
        historicalDataTableView.dataSource = self
        otherCurrenciesTableView.delegate = self
        otherCurrenciesTableView.dataSource = self
        
        let nib1 = UINib(nibName: "TableViewCell", bundle: nil)
        historicalDataTableView.register(nib1, forCellReuseIdentifier: "cell1")
        let nib2 = UINib(nibName: "TableViewCell", bundle: nil)
        otherCurrenciesTableView.register(nib2, forCellReuseIdentifier: "cell2")
        
        guard let fetchedInfo = viewModel.fetch(appDel: AppDelegate()) else {return}
        info = fetchedInfo
        
        guard let popularCurrencies = viewModel.getCurrencies(rates: rates, base: baseCurrency ?? nil, amount: amount ?? nil) else {return}
        self.popularCurrencies = popularCurrencies
    }
    
    @objc func back(sender: UIBarButtonItem){
            self.navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case historicalDataTableView:
            switch section{
            case 0:
                return info?[0]?.count ?? 0
            case 1:
                return info?[1]?.count ?? 0
            case 2:
                return info?[2]?.count ?? 0
            default:
                return info?[3]?.count ?? 0
            }
        default:
            return popularCurrencies?.count ?? 0
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView{
        case historicalDataTableView:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard tableView == historicalDataTableView else{
            return nil
        }
        switch section{
        case 0:
            return "Today"
        case 1:
            return "Day 1"
        case 2:
            return "Day 2"
        default:
            return "Day 3"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView{
            
        case historicalDataTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableViewCell
            
            let converterViewModel = ViewModelDateFormatter()
            
            switch indexPath.section {
            case 0:
                cell.fromCurrencyLabel.text = info?[0]?[indexPath.row].baseCurrency
                cell.toCurrencyLabel.text = info?[0]?[indexPath.row].targetCurrency
                cell.fromValueLabel.text = info?[0]?[indexPath.row].amount
                cell.toValueLabel.text = info?[0]?[indexPath.row].convertedAmount
                cell.dateLabel.text = converterViewModel.convertDate(date: info?[0]?[indexPath.row].date)
                
            case 1:
                cell.fromCurrencyLabel.text = info?[1]?[indexPath.row].baseCurrency
                cell.toCurrencyLabel.text = info?[1]?[indexPath.row].targetCurrency
                cell.fromValueLabel.text = info?[1]?[indexPath.row].amount
                cell.toValueLabel.text = info?[1]?[indexPath.row].convertedAmount
                cell.dateLabel.text = converterViewModel.convertDate(date: info?[1]?[indexPath.row].date)
                
            case 2:
                cell.fromCurrencyLabel.text = info?[2]?[indexPath.row].baseCurrency
                cell.toCurrencyLabel.text = info?[2]?[indexPath.row].targetCurrency
                cell.fromValueLabel.text = info?[2]?[indexPath.row].amount
                cell.toValueLabel.text = info?[2]?[indexPath.row].convertedAmount
                cell.dateLabel.text = converterViewModel.convertDate(date: info?[2]?[indexPath.row].date)
                
            default:
                cell.fromCurrencyLabel.text = info?[3]?[indexPath.row].baseCurrency
                cell.toCurrencyLabel.text = info?[3]?[indexPath.row].targetCurrency
                cell.fromValueLabel.text = info?[3]?[indexPath.row].amount
                cell.toValueLabel.text = info?[3]?[indexPath.row].convertedAmount
                cell.dateLabel.text = converterViewModel.convertDate(date: info?[3]?[indexPath.row].date)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCell
            cell.fromCurrencyLabel.text = popularCurrencies?[indexPath.row].baseCurrency
            cell.toCurrencyLabel.text = popularCurrencies?[indexPath.row].targetCurrency
            cell.fromValueLabel.text = popularCurrencies?[indexPath.row].amount
            print(popularCurrencies?[indexPath.row].amount ?? "")
            cell.toValueLabel.text = popularCurrencies?[indexPath.row].convertedAmount
            cell.dateLabel.text = ""
            return cell
        }
        
    }


}
