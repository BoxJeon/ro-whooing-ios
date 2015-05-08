//
//  RWBalanceSheetViewController.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import UIKit

class RWBalanceSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sections: Array<RWMSection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        
        RWRestApiManager.getSections { (error, sections) -> Void in
            if error == nil {
                self.sections = sections
            } else {
                // TODO: 에러처리
            }
        }
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // Mark: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RWDataCell") as! UITableViewCell
        cell.textLabel?.text = "으아아"
        return cell
    }

}

