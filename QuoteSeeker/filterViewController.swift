//
//  filterViewController.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-08-08.
//  Copyright © 2020 Jason Huang. All rights reserved.
//

import UIKit

class filterViewController: UIViewController {

    @IBOutlet weak var authorPickerView: UIPickerView!
    @IBOutlet weak var genrePickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    var quotes:Array<quote> = [] //API results here
    //Empty String author array
    //arrayArray contains all non-duplicate author names
    var authorArray = [String]()
    var genreArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorPickerView.dataSource = self
        authorPickerView.delegate = self
        
        authorPickerView.tag = 0
        
        genrePickerView.dataSource = self
        genrePickerView.delegate = self
        
        genrePickerView.tag = 1
        
        //Non-duplicate author array is built and passed from resultsViewController
        //Build non-duplicate genre array now
        genreArray = genreArrayBuilder(apiResults: quotes)
        
    }
}
extension filterViewController: UIPickerViewDataSource {
    
    //numberOfComponents function is response for displaying the number of columns per row in the UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //pickerView tag = 0 is the author picker view
        if pickerView.tag == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    //pickerView function is response for displaying the number of row in UIPickerView
    //Notice how authorArray and genreArray have different entries!
    //The tags should be able to distinguish which one is which
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return authorArray.count
        } else {
            return genreArray.count
        }
    }
}
/*
 * Items in the list
 */
extension filterViewController: UIPickerViewDelegate {
    //The row is from function pickerView!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //pickerView tag == 0 is the author picker view
        if pickerView.tag == 0 {
            return authorArray[row]
        } else{
            return genreArray[row]
        }
    }
}

/* genreArrayBuilder function
 * PARAMETERS:
 * 1. apiResults : Array<quote> : the API results in struct "quote" format. To check format please visit ViewController.swift
 *
 * RETURNS:
 * 1. String Array: A non-duplicate String array for genre
 *
 */
func genreArrayBuilder (apiResults: Array<quote>) -> [String] {
    var temp = [String]()
    
    for results in apiResults {
        if temp.contains(results.quoteGenre){
            continue
        } else {
            temp.append(results.quoteGenre)
        }
    }
    return temp
}
