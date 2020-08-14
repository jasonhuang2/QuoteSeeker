//
//  resultsViewController.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-07-22.
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

class resultsViewController: UIViewController {
    
    //Variables from ViewController.swift
    var string2 = "" //string2 contains the quotes from ViewController.swift
    var quotes:Array<quote> = []
    var genre = ""
    var authorAndGenreInputted = false
    
    //Variables from filterViewController.swift
    var filterSelectedGenre = ""
    var filterSelectedAuthor = ""
    var isFilterUsed = false
    var isRemoveFilterPressed = false

    //Local variables
    var authorArray = [String]()     //arrayArray contains all non-duplicate author names
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    /* viewDidLoad() function
     * DESCRIPTION: Code is executed once main menu search view controller loads for the first time
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Result"
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: quoteLabel.bottomAnchor).isActive = true // Required so anything within scrollView is scrollable
        
        quoteLabel.text = string2 //string2 are quotes created from ViewController.swift

        //Creation of authorArray. Go through all API entries. If author does not exist in authorArray, append it. Do not repeat author names.
        for Quotes in self.quotes {
             if self.authorArray.contains(Quotes.quoteAuthor){
                 continue
             } else {
                 self.authorArray.append(Quotes.quoteAuthor)
             }
        }
    }
    /* We will need to go back to the pervious view controller
     *  Implement unwind segues CREDIT: https://medium.com/flawless-app-stories/unwind-segues-in-swift-5-e392134c65fd
     * This function is part of the unwind segue from filter to result
     * Link filterViewCOntroller.swift to its EXIT and select this function in Main.storyboard
     */
    /* unwindToResultsController() function
     * DESCRIPTION: Once unwind is finished, this function is responsble for actions after unwinding. Apply filtered settings from filterViewController.swift to resultsViewController.swift
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    @IBAction func unwindToResultsController( _ seg: UIStoryboardSegue) {
        //If remove filter button is pressed in filterViewController.swift
        if(isRemoveFilterPressed) {
            quoteLabel.text = "" //Set to empty to clear whatever is perviously stored in it
            string2 = "" //Set to empty to clear whatever is perviously stored in it
            //Parse through every quote in JSON
            for quotes in self.quotes {
                //Some quotes contain a genre while some don't! This is a RESTful author's fault. Quotes that don't have a genre, print out "UNKNOWN"
                if(quotes.quoteGenre == nil){
                    string2 = string2 + "Author: \(quotes.quoteAuthor) \n" + "Genre: UNKNOWN\n" + "Quote: " + quotes.quoteText + "\n\n"
                } else {
                    string2 = string2 + "Author: \(quotes.quoteAuthor) \n" + "Genre: \(quotes.quoteGenre!) \n" + "Quote: " + quotes.quoteText + "\n\n"
                }
            }
            quoteLabel.text = string2
            isRemoveFilterPressed = false //Must reset boolean variable in case user presses it again. Annoying Swift problem!
        } else if (isFilterUsed) {
            //Filter settings are applied!
            
//            print ("isFilterUsed boolean value:\(isFilterUsed)")
//            print("filterSelectedAuthor is:\(filterSelectedAuthor)")
//            print ("filterSelectedGenre is:\(filterSelectedGenre)")
            
            quoteLabel.text = ""
            string2 = ""
            //Go through all quotes in JSON file. Only print out the quotes that meet the selected author and genre
            for Quotes in self.quotes {
                if (Quotes.quoteAuthor == filterSelectedAuthor && Quotes.quoteGenre == filterSelectedGenre) {
                    string2 = string2 + "Author: \(Quotes.quoteAuthor) \n" + "Genre: \(Quotes.quoteGenre!) \n" + "Quote: " + Quotes.quoteText + "\n\n"
                } else {
                    continue
                }
            }
            quoteLabel.text = string2
            isFilterUsed = false //Must reset boolean variable in case user presses it again. Annoying Swift problem!
//            print string2
        } else {
            quoteLabel.text = string2
        }
    }
    /* filterButton() function
     * DESCRIPTION: Once the filter button is pressed. If I delete this function Swift would throw an error at me... I'll leave it here
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    @IBAction func filterButton(_ sender: Any) {
        //performSegue(withIdentifier: "filterSegue", sender: self)
    }
    
    /* prepare() function
     * DESCRIPTION: Responsible for actions when a certain segue is executed
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //filter segue is commenced. Pass authorArray, quotes, genre, and authorAndGenreInputted boolean to filterVIewController.swift
        if(segue.identifier == "filterSegue"){
            let vc = segue.destination as! filterViewController
            vc.authorArray = self.authorArray
            vc.quotes = self.quotes //Pass API calls to quotes in filterViewController.swift in JSON format 
            vc.genre = self.genre
            vc.authorAndGenreInputted = authorAndGenreInputted
        }
    }
}

