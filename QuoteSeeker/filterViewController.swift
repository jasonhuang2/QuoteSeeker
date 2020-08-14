//
//  filterViewController.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-08-08.
//  Copyright © 2020 Jason Huang. All rights reserved.
//  GitHub: jasonhuang2
//  RESTful API Quote Garden GitHub: https://pprathameshmore.github.io/QuoteGarden/

/* MODIFICATIONS
 * 08/13/20: Commented and cleaned up code. Submitted to github
 *
 *
 *
 *
 */
import UIKit

class filterViewController: UIViewController {

    //Local Variables
    @IBOutlet weak var authorPickerView: UIPickerView!
    @IBOutlet weak var genrePickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var removeFilterButton: UIButton!
    var genreArray = [String]() //Array containing non-duplicated genres
    var genre = "" //Case where genre and author's name is inputted
    var isDoneButtonPressed = false
    var isRemoveFilterPressed = false
    
    //Filter options, selected genre and author to be sent back to resultsViewController.swift
    var selectedGenre = ""
    var selectedAuthor = ""
    var isFilterUsed = true
    
    //Variables from resultssViewController.swift
    var quotes:Array<quote> = [] //API results in JSON format
    var authorArray = [String]() //arrayArray contains all non-duplicate author names
    var authorAndGenreInputted = false
    var author = ""
    
    
    /* viewDidLoad() function
     * DESCRIPTION: Code is executed once filter view loads
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter Screen"
        
        //Required for the author picker view to work
        authorPickerView.dataSource = self
        authorPickerView.delegate = self
        
        authorPickerView.tag = 0 //Need to distinguish which picker view is which. Let author's pivker view be tag = 0
        
        //Required for the genre picker view to work
        genrePickerView.dataSource = self
        genrePickerView.delegate = self
        
        genrePickerView.tag = 1 //Need to distinguish which picker view is which. Let genre's pivker view be tag = 1
        
        //Non-duplicate author array is built and passed from resultsViewController
        //Build non-duplicate genre array now
        genreArray = genreArrayBuilder(apiResults: quotes)
    }
    
    /* doneButton() function
     * DESCRIPTION: What to do once done button is pressed. set isDoneButtonPressed boolean to true and activate the "unwindToResultsSegue" segue
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    @IBAction func doneButton(_ sender: Any) {
        isDoneButtonPressed = true
//        print ("Selected author name from filter: \(selectedAuthor)")
//        print ("Selected genre from filter: \(selectedGenre)")
        performSegue(withIdentifier: "unwindToResultsSegue", sender: self)
    }
    /* removeFilterButton() function
     * DESCRIPTION: Once remove filer button is pressed. set "isRemoveFilterPressed" boolean to true and perform the "unwindToResultsSegue" segue. 
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    @IBAction func removeFilterButton(_ sender: Any) {
        isRemoveFilterPressed = true
        performSegue(withIdentifier: "unwindToResultsSegue", sender: self)
    }
    
    
    /* prepare() function
     * DESCRIPTION: Responsible for actions when a segue is commenced
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Time to unwind back to resultsViewController.swift
        if(segue.identifier == "unwindToResultsSegue"){
            let vc = segue.destination as! resultsViewController
            if (isDoneButtonPressed) {
                vc.filterSelectedGenre = self.selectedGenre
                vc.filterSelectedAuthor = self.selectedAuthor
                vc.isFilterUsed = self.isFilterUsed
            } else if (isRemoveFilterPressed) {
                vc.isRemoveFilterPressed = self.isRemoveFilterPressed
            }
        }
    }
}

extension filterViewController: UIPickerViewDataSource {
    //numberOfComponents function is response for displaying the NUMBER of COLUMNS IN each row in the UIPickerView
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
            if (authorAndGenreInputted) {
                return 1
            } else {
                return genreArray.count
            }
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
            //So how do I know what item is selected? Line 147. Send selectedAuthor back to resultsViewController.swift to be used
            selectedAuthor = authorArray[row] //Ultra stupid in swift. You serious Apple? Return selected author back to results but we need to store it in a local variable first
            return authorArray[row]
        } else {
            if (authorAndGenreInputted) {
                selectedGenre = genre
                return genre
            } else {
                //selectedGenre to be sent back to resultsViewController.swift
                selectedGenre = genreArray[row]
                return genreArray[row]
            }
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
        if (results.quoteGenre == nil){
            continue
        }
        else if temp.contains(results.quoteGenre!){
            continue
        } else {
            temp.append(results.quoteGenre!)
        }
    }
    return temp
}
