//
//  ListViewController.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

  // MARK: - Model & Tableview
    var listData = [ListResponsesub]() // model
    var listTitle = String() // navigation title
    let ListTableView = UITableView() // tableview
    private let reuseIdentifier = "ListTableViewCell" // tableviewcell

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        initTableView()
    }

  // MARK: - Navigation

  func setUpNavigation() {
    navigationItem.title = listTitle
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
     ListTableView.estimatedRowHeight = 90
     ListTableView.register(ListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
    ListViewWorker().getPost(onSuccess: { (result) in
      self.listData = result.rows
      self.listTitle = result.title ?? ""
      self.setUpNavigation()
      self.ListTableView.reloadData()
      self.refreshControl.endRefreshing()
    }, onFail: { (error) in
      print(error ?? "No Error");
    }, currentView: self.view)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ListTableViewCell
    cell.postData = listData[indexPath.row]
    cell.layoutIfNeeded()
    return cell
  }

}

