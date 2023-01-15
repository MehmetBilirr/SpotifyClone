//
//  SearchResultViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 13.01.2023.
//

import UIKit




protocol SearchResultViewInterface:AnyObject {
  func configureTableView()
  func getResults(result:[ContentType])
  func reloadData()
  func pushToContentDetail(content:ContentType)

}

class SearchResultViewController: UIViewController {
    let tableView = UITableView()
    lazy var viewModel = SearchResultViewModel(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      viewModel.viewDidLoad()

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

  func getResults(result: [ContentType]) {

    viewModel.getResults(result: result)
  }

  func reloadData() {
    tableView.reloadData()
  }

  func pushToContentDetail(content: ContentType) {
    let vc = ContentDetailsViewController(content: content)
    navigationController?.pushViewController(vc, animated: true)
  }

}

extension SearchResultViewController:UITableViewDataSource,UITableViewDelegate{

  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.numberOfSections()
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    viewModel.titleForHeaderInSection(section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    viewModel.cellForRowAt(indexPath, tableView)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRowsInSection(section)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectRowAt(indexPath: indexPath)
  }

}
