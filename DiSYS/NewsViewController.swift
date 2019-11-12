//
//  NewsViewController.swift
//  DiSYS
//
//  Created by MNRAO on 12/11/19.
//  Copyright © 2019 Defteam. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let refreshControl = UIRefreshControl()
    var newsDataModel = [NewsDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize(){
       // self.navigationController?.navigationBar.setColor()
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        tableView.separatorStyle = .none
        getNewsDetails()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        getNewsDetails()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TOAST_DURATION, execute: {
//            self.refreshControl.endRefreshing()
//        })
    }
    
    
    @IBAction func addpostApi(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyBoard.instantiateViewController(withIdentifier: "AddApiViewController") as! AddApiViewController
        self.present(addViewController, animated: true, completion: nil)
    }
    
//    let consumerkey = "mobile_dev"
//    let consumersecret = "20891a1b4504ddc33d42501f9c8d2215fbe85008"
 //   let append = "/iskan/v1/certificates/towhomitmayconcern"

    
    func getNewsDetails(){
        BaseClass.shared.strUrl = "https://api.qa.mrhe.gov.ae/mrhecloud/v1.4/api"
        let append = "/public/v1/news?local=en"
        
        APIManager.shared.request(urlAppend: append, httpMethod: Constants.GET, contentType: Constants.CONTENT_TYPE_ENCODING, params: nil, bodyStr: nil, delegate: self) { [weak self] (result, error) in
            if let response = result as? [String: Any] {
                let status = String.giveMeProperString(str: response["success"])
                if status == "1"{
                    self?.refreshControl.endRefreshing()
                    if let arr = response["payload"] as? [[String: Any]], arr.count > 0{
                        self?.newsDataModel = NewsDataModel.getAllNewsModelsData(arr: arr)
                        self?.tableView.reloadData()
                    }
                }
               
            }
            if let error = error {
                self?.view.makeToast(error, duration: Constants.TOAST_DURATION, position: .bottom)
            }
        }
    }
    

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(newsDataModel.count)
      return newsDataModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDataTableCell", for: indexPath) as! NewsDataTableCell
        cell.fillDetails(newsModel: newsDataModel[indexPath.row], index: indexPath.row)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
