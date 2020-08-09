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
    
    var string2 = ""
    var quotes:Array<quote> = []
    
    //Empty String author array
    //arrayArray contains all non-duplicate author names 
    var authorArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Result"
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: quoteLabel.bottomAnchor).isActive = true

        quoteLabel.text = string2
        
        
        print("From resultsViewController: \n")
        for Quotes in self.quotes {
            //print("\(quotes.quoteAuthor)\n")
            //Go through all API entries. If author does not exist in authorArray, append it. Do not repeat author names.
             if self.authorArray.contains(Quotes.quoteAuthor){
                 continue
             } else {
                 self.authorArray.append(Quotes.quoteAuthor)
             }
        }
        

    }
    
    @IBAction func filterButton(_ sender: Any) {
        performSegue(withIdentifier: "filterSegue", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "filterSegue"){
            let vc = segue.destination as! filterViewController
            vc.authorArray = self.authorArray
            vc.quotes = self.quotes //Pass API calls to quotes in filterViewController.swift

        }
        
    }
    
    


}

