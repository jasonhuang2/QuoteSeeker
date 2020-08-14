//
//  ViewController.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-07-21.
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
import Foundation

class ViewController: UIViewController {

    //Declaration of objects from Main.storyboard for the main search screen
    @IBOutlet weak var authorTextBox: UITextField!
    @IBOutlet weak var genreTextBox: UITextField!
    
    //Local variables for main search screen
    var authorName = ""
    var genre = ""
    let group = DispatchGroup() //Require API call to finish first. Swift 5 likes to go ahead!
    var authorAndGenreInputted = false
    
    //Results from JSON parsing
    //RESTful API QuoteGarden created by: https://github.com/pprathameshmore/QuoteGarden
    var statusCode = 0
    var totalPages = 0
    var currentPage = 0
    var quotes:Array<quote> = [] //quotes Array in <quote> struct

    /* viewDidLoad() function
     * DESCRIPTION: Code is executed once main menu search view controller loads for the first time
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QuoteSeeker" //Title for the navigation bar
    }
    
    /* searchButton() function
     * DESCRIPTION: Responsible for anything once the "Search" button is pressed
     * PARAMETERS:
     *  None
     * RETURN:
     *  None
     */
    @IBAction func searchButton(_ sender: Any) {
        //If author text box and genre text box are left empty, do nothing
        if(authorTextBox.text == "" && genreTextBox.text == "") {
            
        } else {
            //Execute RESTful API using author's name and/or genre
            //Parse JSON file and store it into quotes Array with <quote> struct
            authorName = authorTextBox.text!
            genre = genreTextBox.text!.lowercased() //Sanitize genre to lowercase. RESTful API is case sensitive
            
            apiCaller(authorName: authorName, genre: genre)

            //Debug purposes.
//            group.notify(queue: .main){
//                print ("Finished executing API call function \n\n")
//                print ("Status code: \(self.statusCode)")
//                print ("Total pages: \(self.totalPages)")
//                print ("Current page: \(self.currentPage)")
//            }
            self.group.wait() //Extremely important, need to wait for API to finish or else it will crash. Puts thread to sleep, finish executing API function, resume thread
            performSegue(withIdentifier: "searchSegue", sender: self) //Perform "searchSegue" to resultsViewController
        }
    }
    
    /* prepare() function
     * DESCRIPTION: Overrides the prepare function. Once any segue is commenced, this function is executed. Basically, if you want to pass any data to another view controller dictated by its segue, you do it here
     * PARAMETERS:
     *      1. segue: Type: UIStoryboardSegue: the segue that is responsible for activating another view controller. The "bridge" between view controllers
     * RETURN:
     *  None
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //If the segue is "searchSegue" that activates the resultsViewController.swift
        if(segue.identifier == "searchSegue"){
            let vc = segue.destination as! resultsViewController //I know have access to all local variables in resultsViewController.swift
            vc.quotes = self.quotes //Variable quotes in resultsViewController.swift now contains all quotes from JSON
            
            

            //Base Case #1: If author and genre are both inputted
            if(authorAndGenreInputted){
                vc.genre = self.genre //Send genre to genre in resultsViewController.swift
                vc.authorAndGenreInputted = self.authorAndGenreInputted //Set boolean variable authorAndGenreInputted in resultsViewController.swift to true
                
                //We must santize the quotes based on the user's genre. Go through quotes JSON and string concatenate. Store results in  variable string2 in resultsViewController.swift. string2 will be printed out onto screen
                for Quotes in self.quotes {
                    //Print out quotes that match the desired genre
                    if (Quotes.quoteGenre == genre){
                        vc.string2 = vc.string2 + "Author: \(Quotes.quoteAuthor) \n" + "Genre: \(Quotes.quoteGenre!) \n" + "Quote: " + Quotes.quoteText + "\n\n"
                    } else {
                        continue
                    }
                }
            //Base Case #2: If only author's name is inputted or genre is inputted, or vise versa
            } else {
                for Quotes in self.quotes{
                    //Extremely annoying. RESTful author screwed up because some quotes don't have a genre while some do! If cases where there is no genre print "UNKNOWN" beside the genre
                    if(Quotes.quoteGenre == nil){
                        vc.string2 = vc.string2 + "Author: \(Quotes.quoteAuthor) \n" + "Genre: UNKNOWN\n" + "Quote: " + Quotes.quoteText + "\n\n"
                    } else {
                        vc.string2 = vc.string2 + "Author: \(Quotes.quoteAuthor) \n" + "Genre: \(Quotes.quoteGenre!)\n" + "Quote: " + Quotes.quoteText + "\n\n"
                    }
                }
            }
        }
    }
    
    /* apiCaller() function
     * DESCRIPTION: Function that calls to RESTful API Quote Garden created by Prathamesh More. Parses JSON file and stores all the results into local variables "statusCode", "totalPages", "currentPage", and "quotes"
     * PARAMETERS:
     *      1. authorName: Type: String: The author's name
     *      2. genre: Type: String: The genre
     * RETURN:
     *      None
     */
    private func apiCaller(authorName: String, genre: String){
        self.group.enter() //Puts thread on hold while this function finishes executing. Swift likes to get ahead of itself. Headache
        var urlString = ""
        let authorName = spaceConverter(theString: authorName) //Spaces must be replaced with "%20", API calling requirements
        
//        print("Author's name:\(authorName)")
//        print("Genre:\(genre)")
        
        //Base Case #1: author's name is inputted and genre is empty
        if(!authorName.isEmpty && genre.isEmpty){
            urlString = "https://quote-garden.herokuapp.com/api/v2/authors/\(authorName)?page=1&limit=200"
            
        }else if(authorName.isEmpty && !genre.isEmpty){
            //Base Case #2: author's name is empty and genre is inputted
            urlString = "https://quote-garden.herokuapp.com/api/v2/genre/\(genre)?page=1&limit=200"

        }else{
            //Base Case #3: author and genre are both inputted
            //API author doesn't have a URL that supports this case, must parse results myself
            authorAndGenreInputted = true
            urlString = "https://quote-garden.herokuapp.com/api/v2/authors/\(authorName)?page=1&limit=200"
        }
//        print ("URL is:\(urlString)")
        
        //Execute urlString, retrieve JSON file and parse through it. Store it into local variables
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask (with: url) { (data, res, error) in
            guard let data = data, error == nil else {
                return
            }
            //Have data now, convert to struct (json decoding)
            //Response is the JSON struct
            var result: Response?
            do{
                result = try JSONDecoder().decode(Response.self, from: data) //JSON parse, store into struct "Response"
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
                print (error)
            }
            guard let json = result else {
                return
            }

            //Stores JSON results into local variables
            self.statusCode = json.statusCode
            self.totalPages = json.totalPages
            //self.currentPage = json.currentPage //Commented out because API author screwed up
            self.quotes = json.quotes //json.quotes from struct Response "quotes"
            self.group.leave() //Stop putting thread on hold
        }
        task.resume()
    }
    
    /* spaceConverter function
     * DESCRIPTION: Function that takes in a string, and replaces all spaces with "%20". Required because RESTful APIs read spaces as "%20"
     * PARAMETERS:
     *      1. theString: Type: String: The string, all spaces will be replaced with "%20"
     * RETURN:
     *      1. Type String: String with all its spaces replaced with "%20"
     */
    func spaceConverter(theString: String) -> String {
        return theString.replacingOccurrences(of: " ", with: "%20")
    }
}

// For API calling, structure of JSON file
struct Response: Codable{
    let statusCode: Int
    let message: String
    let totalPages: Int
    //let currentPage: Int //API author screwed up!
    let quotes: [quote] //quotes are stored in Array type "quote" struct

}
//Instead of Array, I'll create a quote struct. Swift is hard
struct quote: Codable{
   // let _id: String //API author screwed up!
    let quoteText: String
    let quoteAuthor: String
    let quoteGenre: String? //Made optional, API author screwed up
    let __v: Int = 0 //Some quotes contain a __v while some don't... API author's screw up
}
