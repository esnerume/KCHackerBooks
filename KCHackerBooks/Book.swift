//
//  Book.swift
//  PruebasPractica1
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import Foundation
import UIKit


class Book {
    //MARK: - Attributes
    let title   : String
    let authors : [String]
    let tags    : [Tag]
    let image   : URL
    let url     : URL
    var favorite: Bool = false
    
    //MARK: - Initialization
    
    init(title: String, authors: [String],
         tags: [Tag], image: URL,
         url: URL, isFavorite: Bool) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.url = url
        self.favorite = isFavorite
    }
    
    convenience init(title: String, authors: [String],
                     tags: [Tag], image: URL, url: URL) {
        self.init(title: title,
                  authors: authors,
                  tags: tags,
                  image: image,
                  url: url,
                  isFavorite: false)
    }
    
    convenience init(title: String, authors: String,
                     tags: String, image: String, url: String) {
        
        guard let imageUrl = URL(string: image) else {
            fatalError("Error while parsing URL: \(image)")
        }
        
        guard let pdfUrl = URL(string: url) else {
            fatalError("Error while parsing URL: \(url)")
        }
        
        let arrayAuthors = authors.components(separatedBy: ", ").flatMap({ $0 as String })
        let arrayTags = tags.components(separatedBy: ", ").flatMap({ Tag(name: $0.capitalized) })
        
        self.init(
            title: title as String,
            authors: arrayAuthors,
            tags: arrayTags,
            image: imageUrl,
            url: pdfUrl
        )
        
    }
    
    //MARK: - Computed Properties
    var isFavorite: Bool {
        get{
            return favorite
        }
    }
    
    var listAuthors: String {
        // Volvemos a dejar los autores tal cual venian en el json para mostrar en la celda (pero ordenado)
        get {
            let ordered = authors.sorted()
            return ordered.map({ $0 as String }).joined(separator: ", ")
        }
    }
    
    var listTags: String {
        // Volvemos a dejar los tags tal cual venian en el json para mostrar en la celda (pero ordenado)
        get {
            let ordered = tags.sorted()
            return ordered.map({ $0.description }).joined(separator: ", ")
        }
    }
    
    
    //MARK: - Favorites
    func notFavorite() {
        favorite = !favorite
    }
    
    //MARK: - Proxies
    
    // Utilizamos los tres campos fundamentales para ordenar primero por título,
    // despues por autores, y despues por tags
    func proxyForEquality() -> String {
        return "\(title.lowercased())\(listAuthors.lowercased())\(listTags.lowercased())"
        
        
    }
    
    func proxyForComparison() -> String {
        return proxyForEquality()
    }
    
    func proxyForHashing() -> Int {
        return title.hashValue ^ listAuthors.hashValue ^ listTags.hashValue
    }
    
}

//MARK: - Protocols

extension Book : Equatable{
    
    public static func ==(lhs: Book,
                          rhs: Book) -> Bool{
        
        return (lhs.proxyForEquality() == rhs.proxyForEquality())
    }
    
}

extension Book : Comparable{
    
    public static func <(lhs: Book,
                         rhs: Book) -> Bool{
        
        return (lhs.proxyForComparison() < rhs.proxyForComparison())
    }
}



extension Book : CustomStringConvertible{
    
    public var description: String{
        get{
            return "\(title)-\(listAuthors)-\(listTags)"
        }
    }
}



extension Book: Hashable {
    var hashValue: Int {
        return proxyForHashing()
    }
}
