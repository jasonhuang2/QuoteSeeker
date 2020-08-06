//
//  resultsViewController.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-07-22.
//  Copyright © 2020 Jason Huang. All rights reserved.
//

import UIKit

class resultsViewController: UIViewController {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    var string1 = ""
    var string2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Result"
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: quoteLabel.bottomAnchor).isActive = true

        
        quoteLabel.text = string2
        //resultQuoteBox1.text = string2

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
