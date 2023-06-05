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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        historicalDataTableView.delegate = self
//        historicalDataTableView.dataSource = self
//        otherCurrenciesTableView.delegate = self
//        otherCurrenciesTableView.dataSource = self
    }
}

//extension DetailsViewController : UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
