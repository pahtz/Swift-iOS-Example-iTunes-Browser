//
//  SearchViewController.swift
//  Swift iTunes Browser
//
//  Created by Paul Yu on 15/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var searchQuery = "Bob Dylan"
    var searchResultViewController : SearchResultsViewController?
    
    @IBOutlet var textField : UITextField
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.text = searchQuery
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(animated: Bool)
    {
        if (searchResultViewController)
        {
            searchResultViewController!.searchQuery = textField.text
        }
    }
}
