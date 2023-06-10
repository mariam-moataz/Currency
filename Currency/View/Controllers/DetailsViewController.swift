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
    
    let viewModel = CurrencyViewModel()
    //var info : [ExchangeInfo] = []
    
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
        
        guard let info = viewModel.fetch(appDel: AppDelegate()) else {return}
        //self.info = info
    }
}

extension DetailsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Day 1"
        case 1:
            return "Day 2"
        default:
            return "Day 3"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case historicalDataTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCell
            return cell
        }
        
    }


}
