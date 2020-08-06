//
//  quoteModel.swift
//  QuoteSeeker
//
//  Created by Jason Huang on 2020-07-25.
//  Copyright © 2020 Jason Huang. All rights reserved.
//

import Foundation

// For API calling, structure of JSON file
struct Response: Codable{
    let statusCode: Int
    let totalPages: Int
    let currentPage: Int
    let quotes: [quote]
}

//Instead of Array, I'll create a quote struct. Swift is hard
struct quote: Codable{
    let _id: Int
    let quoteText: String
    let quoteAuthor: String
    let quoteGenre: String
    let __v: Int
}
