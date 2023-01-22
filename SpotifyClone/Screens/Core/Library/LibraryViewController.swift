//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by Mehmet Bilir on 2.01.2023.
//

import UIKit
import SnapKit

protocol LibraryViewInterface:AnyObject {
  var selectedIndex:Int{get set}
  func configureTableView()
  func configureSectionButtons()
  func fetchData()
  func reloadData()
  func goToViewControllers(content:ContentType)

}

class LibraryViewController: UIViewController {
  private enum  SectionTabs:String {
      case songs = "Songs"
      case albums = "Albums"


  }

  private var buttons : [UIButton] = ["Songs","Albums"].map { buttonTitle in
    let button = UIButton(type: .system)
    button.configureStyleTitleButton(title: buttonTitle, titleColor: .label)
    button.layer.cornerRadius = 15
    button.clipsToBounds = true
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 0.2
    return button
  }
  private lazy var sectionButtonStack:UIStackView = {
    let stackView = UIStackView(arrangedSubviews: buttons)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 10
    stackView.axis = .horizontal
    stackView.alignment  = .center
    return stackView
  }()

  let tableView = UITableView()
  var selectedIndex = 0 {
    didSet {
      print(selectedIndex)
        for i in 0..<buttons.count {
            UIView.animate(withDuration: 0.6, delay: 0) {
                self.sectionButtonStack.arrangedSubviews[i].backgroundColor = self.selectedIndex == i ? .systemGreen : .systemBackground
            }
        }
    }
  }
  private lazy var viewModel = LibraryViewModel(view: self)
  override func viewDidLoad() {
    super.viewDidLoad()
    selectedIndex = 0
    viewModel.viewDidLoad()


  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.addSubview(sectionButtonStack)
    sectionButtonStack.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(15)
      make.top.equalTo(view.safeAreaInsets.top)
    }

    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.bottom.left.right.equalToSuperview()
      make.top.equalTo(sectionButtonStack.snp.bottom).offset(20)
    }
    for i in buttons {
      i.snp.makeConstraints { make in
        make.height.equalTo(30)
        make.width.equalTo(80)
      }
    }

  }

}

extension LibraryViewController:LibraryViewInterface{

  func fetchData() {
    viewModel.fetchData()
  }
  func configureTableView() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
  }


  func configureSectionButtons(){
   for button in buttons {
     button.addTarget(self, action: #selector(didTapSectionButton(_:)), for: .touchUpInside)
   }
 }

 @objc func didTapSectionButton(_ sender:UIButton) {
     guard let label = sender.titleLabel?.text else {return}
     print(label)
     switch label {
     case SectionTabs.songs.rawValue:
         selectedIndex = 0
       tableView.reloadData()
     case SectionTabs.albums.rawValue:
         selectedIndex = 1
       tableView.reloadData()
     default:
         return selectedIndex = 0
     }
 }

  func reloadData() {
    tableView.reloadData()
  }

  func goToViewControllers(content: ContentType) {
    switch content {
    case .album(let album):
      let vc = ContentDetailsViewController(content: .album(album))
      navigationController?.pushViewController(vc, animated: true)
    case .track(let track):

      let trackID : String = track.id
      NotificationCenter.default.post(name: .trackNotification, object: trackID)

    default:
      break
    }
  }

  
}

extension LibraryViewController:UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsInSection()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    viewModel.cellForRowAt(indexPath, tableView)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectRowAt(indexPath: indexPath)
  }

}
