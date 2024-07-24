//
//  Localizable.swift
//  Movies
//
//  Created by Macbook on 24.07.2024.
//

import Foundation

@propertyWrapper
struct Localizable {
    var wrappedValue: String {
        didSet {
            wrappedValue = NSLocalizedString(wrappedValue, comment: "")
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = NSLocalizedString(wrappedValue, comment: "")
    }
}

enum LocalizedString {
    @Localizable static var rating = "Rating:"
    @Localizable static var notApplicable = "N/A"
    @Localizable static var noResultsForQuery = "There are no results for your search query."
    @Localizable static var popularMovies = "Popular Movies"
    @Localizable static var searchMovies = "Search movies"
    @Localizable static var asc = "Asc"
    @Localizable static var desc = "Desc"
    @Localizable static var none = "None"
    @Localizable static var sortByName = "Sorting by name"
    @Localizable static var warning = "Warning"
    @Localizable static var close = "Close"
    @Localizable static var unnownError = "An unknown error occurred."
    @Localizable static var youAreOffline = "You are offline.\nPlease, enable your Wi-Fi or connect using cellular data."
    @Localizable static var settings = "Settings"
    @Localizable static var language = "Language"
    @Localizable static var darkMode = "Dark Mode"
}
