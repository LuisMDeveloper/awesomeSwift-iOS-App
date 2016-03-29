//
//  CategoryListViewController.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 28/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: CategoryListDataProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
