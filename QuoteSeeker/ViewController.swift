//
//  ViewController.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-07-21.
//  Copyright © 2020 Jason Huang. All rights reserved.
//
/* TODO List:
 * 1. When querying just the author, sometimes there is no genre IE: Bruce Lee
 * 2. No API call that supports author and genre - DONE
 * 3. Sort algorithm
 */




import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var authorTextBox: UITextField!
    @IBOutlet weak var genreTextBox: UITextField!
    
    var authorName = ""
    var genre = ""
    
    //Results from JSON, global variables
    var statusCode = 0
    var totalPages = 0
    var currentPage = 0
    var quotes:Array<quote> = []

    let group = DispatchGroup()
    
    var authorAndGenreInputted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "QuoteSeeker"
    }
    @IBAction func searchButton(_ sender: Any) {
        authorName = authorTextBox.text!
        genre = genreTextBox.text!.lowercased()
        apiCaller(authorName: authorName, genre: genre)
    
        group.notify(queue: .main){
            print ("Finished executing API call function \n\n")
            //Print out API calls
            print ("Status code: \(self.statusCode)")
            print ("Total pages: \(self.totalPages)")
            print ("Current page: \(self.currentPage)")
            
            
            
            //DEBUG PURPOSES
//            for Quotes in self.quotes{
//                print("\(Quotes)\n") //This prints out the quotes and just the quotes
//
//                //Go through all API entries. If author does not exist in authorArray, append it. Do not repeat author names.
//                if self.authorArray.contains(Quotes.quoteAuthor){
//                    continue
//                } else {
//                    self.authorArray.append(Quotes.quoteAuthor)
//                }
//            }
        }
        
        self.group.wait() //Extremely important, need to wait for API to finish or else it will crash
        performSegue(withIdentifier: "searchSegue", sender: self)


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "searchSegue"){
            let vc = segue.destination as! resultsViewController

            vc.quotes = self.quotes
            
            
            if(authorAndGenreInputted){
                //We must santize the quotes based on the user's genre
                for Quotes in self.quotes {
                    if (Quotes.quoteGenre == genre){
                        vc.string2 = vc.string2 + "Author: \(Quotes.quoteAuthor) \n" + "Genre: \(Quotes.quoteGenre) \n" + "Quote: " + Quotes.quoteText + "\n\n"
                    } else {
                        continue
                    }
                }
            } else {
                for Quotes in self.quotes{
                    vc.string2 = vc.string2 + "Author: \(Quotes.quoteAuthor) \n" + "Genre: \(Quotes.quoteGenre) \n" + "Quote: " + Quotes.quoteText + "\n\n"
                }
            }
        }
    }
    
    private func apiCaller(authorName: String, genre: String){
        print("Within apiCaller function\n\n\n")
        self.group.enter()
        var urlString = ""
        //If author's name has a space, in API calls, spaces must be replaced with "%20"
        let authorName = spaceConverter(theString: authorName)
        print("Author's name:\(authorName)")
        print("Genre:\(genre)")
        
        
        
        //Case #1: author's name is inputted and genre is empty
        if(!authorName.isEmpty && genre.isEmpty){
            urlString = "https://quote-garden.herokuapp.com/api/v2/authors/\(authorName)?page=1&limit=200"
            
        }else if(authorName.isEmpty && !genre.isEmpty){
            //TODO: Case #2: author's name is empty and genre is inputted
            urlString = "https://quote-garden.herokuapp.com/api/v2/genre/\(genre)?page=1&limit=200"

        }else{
            print ("Author and Genre inputted")
            //TODO: Case #3: author's name and genre are both inputted
            //API author doesn't have an API that supports this case... guess I have to do it myself
            urlString = "https://quote-garden.herokuapp.com/api/v2/authors/\(authorName)?page=1&limit=200"
            authorAndGenreInputted = true

        }
        
        print ("URL is:\(urlString)")
        
        
        guard let url = URL(string: urlString) else {
            return
            
        }
        let task = URLSession.shared.dataTask (with: url) { (data, res, error) in
            guard let data = data, error == nil else {
                return
            }
            //Have data now, convert to struct (json decoding)
            var result: Response?
            do{
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch{
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }

            //Stores JSON results into global variables
            self.statusCode = json.statusCode
            self.totalPages = json.totalPages
            //self.currentPage = json.currentPage
            self.quotes = json.quotes //json.quotes from struct Response "quotes"
            
            self.group.leave()
        }
        task.resume()
    }
    func spaceConverter(theString: String) -> String {
        return theString.replacingOccurrences(of: " ", with: "%20")
    }
    
    
}

// For API calling, structure of JSON file
struct Response: Codable{
    let statusCode: Int
    let message: String
    let totalPages: Int
    //let currentPage: Int
    let quotes: [quote]

}

//Instead of Array, I'll create a quote struct. Swift is hard
struct quote: Codable{
    let _id: String
    let quoteText: String
    let quoteAuthor: String
    let quoteGenre: String
    let __v: Int

}




