//
//  ListViewController.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UIViewController {

  // MARK: - Model & Tableview
    var listData = [ListResponsesub]() // model
    let ListTableView = UITableView() // tableview

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        initTableView()
    }

  // MARK: - Navigation

  func setUpNavigation() {
    navigationItem.title = ListViewModel.shared.titleInformation
    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
  }

  // MARK: - Setup Table

  func initTableView() {
     view.addSubview(ListTableView)
     ListTableView.translatesAutoresizingMaskIntoConstraints = false
     ListTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
     ListTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
     ListTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
     ListTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true

     ListTableView.dataSource = self
     ListTableView.delegate = self
     ListTableView.rowHeight = UITableView.automaticDimension
     ListTableView.estimatedRowHeight = 600
     ListTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
     ListTableView.addSubview(refreshControl)
  }

  // MARK: - Controller lifecycle

  override func viewWillAppear(_ animated: Bool) {

    // MARK: - Api Calling

    getPostData{ (isFinished: Bool) in
      if isFinished {
        debugPrint("Finished!!!")
      }
    }
  }

  // MARK: - Api Method

   func getPostData(isFinished: @escaping(_ status: Bool) -> Void){
      ListViewModel.shared.getPostInformation { (result) in
                 switch result{
                 case .success(true):
                  self.setUpNavigation()
                  self.listData = ListViewModel.shared.postInformation
                  self.ListTableView.reloadData()
                  self.refreshControl.endRefreshing()
                  isFinished(true)
                 case .failure(let error):
                     print(error)
                  isFinished(false)
                 case .success(false):
                     print("flase")
                  isFinished(false)
                 }
          }
  }

  // MARK: - Pull to refrece

  lazy var refreshControl: UIRefreshControl = {
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action:
          #selector(self.refreshList(_:)),
                               for: UIControl.Event.valueChanged)
      refreshControl.tintColor = UIColor.black

      return refreshControl
  }()

  // MARK: - Pull to refresh action

  @objc private func refreshList(_ refreshControl: UIRefreshControl) {
    getPostData{ (isFinished: Bool) in
      if isFinished {
        debugPrint("Finished!!!")
      }
    }
  }

}


// MARK: - Tableview DataSource

extension ListViewController:UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
    cell.postData = listData[indexPath.row]
    cell.layoutIfNeeded()
    return cell
  }

}

// MARK: - Tableview Delegate

extension ListViewController:UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
  }
}
