//
//  SearchResultViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 13.01.2023.
//

import UIKit

protocol SearchResultViewInterface {
  func configureTableView()
}

class SearchResultViewController: UIViewController {
    private let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      configureTableView()
    }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
}

extension SearchResultViewController:SearchResultViewInterface{
  func configureTableView() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    
  }


}

extension SearchResultViewController:UITableViewDataSource,UITableViewDelegate{


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

}
