//
//  ViewController.swift
//  Meal
//
//  Created by almond on 2016. 12. 26..
//  Copyright © 2016년 almond. All rights reserved.
//

import UIKit
import Alamofire

class MealListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let schoolSelectButtonItem = UIBarButtonItem(
        title: "학교 선택",
        style: .plain,
        target: nil,
        action: #selector(schoolSelectButtonItemDidSelect)
    )
    let tableView = UITableView()
    var meals: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolSelectButtonItem.target = self
        self.navigationItem.rightBarButtonItem = self.schoolSelectButtonItem
        self.tableView.register(MealCell.self, forCellReuseIdentifier: "mealCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.loadMeals()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.meals.count
    }
    
    func loadMeals() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let baseURLString = "https://schoool.herokuapp.com"
        let schoolCode = "B100000658"
        let path = "/school/\(schoolCode)/meals"
        let urlString = baseURLString + path
        
        Alamofire.request(urlString).responseJSON { response in
            guard let json = response.result.value as? [String: [[String: Any]]],
                let dicts = json["data"]
                else { return }
            
            self.meals = dicts.flatMap {
                return Meal(dictionary: $0)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
        
    }
    
    func schoolSelectButtonItemDidSelect() {
        let schoolSearchViewController = SchoolSearchViewController()
        let navigationController = UINavigationController(rootViewController: schoolSearchViewController)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let meal = self.meals[section]
        
        return meal.date
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
        let meal = self.meals[indexPath.section]
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "점심"
            cell.contentLabel.text = meal.lunch.joined(separator: ", ")
        }
        
        else {
            cell.titleLabel.text = "저녁"
            cell.contentLabel.text = meal.dinner.joined(separator: ", ")
        }

        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let meal = self.meals[indexPath.section]
        
        if indexPath.row == 0 {
            return MealCell.height(
                width: tableView.frame.size.width,
                title: "점심",
                content: meal.lunch.joined(separator: ", ")
            )
        }
            
        else {
            return MealCell.height(
                width: tableView.frame.size.width,
                title: "저녁",
                content: meal.dinner.joined(separator: ", ")
            )
        }

    }

}

