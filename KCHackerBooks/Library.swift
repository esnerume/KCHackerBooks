//
//  Library.swift
//  PruebasPractica1
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import Foundation
import UIKit

class Library {
    // MultiDicccionario con los Libros agrupados por Tags
    var books = MultiDictionary<Tag, Book>()
    
    // Array de tags con todas las distintas temáticas en
    // orden alfabético. No puede bajo ningún concepto haber
    // ninguno repetido
    var tags: [Tag] {
        get {
            var tags: [Tag] = []
            for tag in books.keys.sorted() {
                tags.append(tag)
            }
            return tags
        }
    }
    
    // Número total de Libros
    var booksCount: Int {
        get {
            return books.countUnique
        }
    }
    
    // Número de Tags. Este valor lo necesitaremos para saber el número de secciones de la TableView
    var tagCount: Int {
        get {
            return books.keys.count
        }
    }
    
    //MARK: - Initialization
    
    init(books: [Book]) {
        for book in books {
            for tag in book.tags {
                self.books.insert(value: book, forKey: tag)
            }
            
            // Si el libro está marcado como favorito lo añadimos al
            // Multidiccionario con el Tag Favoritos.
            if book.isFavorite {
                addBookToFavorites(book: book)
            }
            
        }
    }
    
    // Cantidad de libros que hay en una temática.
    // Si el tag no existe, debe devolver cero
    
    func bookCount(forTag tag: Tag) -> Int {
        return books(forTag: tag)?.count ?? 0
    }
    
    // Array de los libros (Instancias de Book) que hay en 
    // una temática.
    // Un libro puede estar en una o más temáticas. Sino hay
    // libros para una tamática, ha de devolver nil
    func books(forTag tag: Tag) -> [Book]? {
        if let bookList = books[tag] {
            return Array(bookList).sorted(by: <)
        } else {
            return nil
        }
    }
    
    // Devolver el libro que está una posición de un Tag determinado.
    // Reutilizamos la función book_forTag que nos da algo de trabajo hecho.
    func book(forTag tag: Tag, at: Int) -> Book? {
        if let bookList = books(forTag: tag) {
            return bookList[at]
        } else {
            return nil
        }
    }
    
    //MARK: - Favorites
    
    func addBookToFavorites(book: Book) {
        books.insert(value: book, forKey: Tag.sharedFavoriteTag)
    }
    
    func removeBookFromFavorites(book: Book) {
        books.remove(value: book, fromKey: Tag.sharedFavoriteTag)
    }
    
}
