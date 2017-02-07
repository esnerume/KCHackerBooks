//
//  JSONProccessing.swift
//  KCHackerBooks
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import Foundation

/*
 
 {
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
 },*/

func decodeJson() -> [Book] {
    // Descargamos a Local el JSON si es necesario (Si no lo cogemos de caché)
    let json = downloadAndStoreJson()
    
    // Como todos los campos son de tipo String no hacemos sobreingenieria
    // y no preguntamos por el tipo de cada uno de los valores (Así nos evitamos comprobaciones y el parseo de realizará mucho más rápido. Le decimos que a JSONSerialization que nos devuelva en un array de diccionarios siendo tanto la clave como el valor, Strings
    guard let jsonObject = try? JSONSerialization.jsonObject(with: json,
                                                             options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[String: String]],
        let bookList = jsonObject else {
            fatalError("Malformed Json")
        }
    
    return bookList.flatMap({ (jsonBook: [String : String]) -> Book? in
        // Comprobamos que todos los campos del libro vienen rellenos, en caso contrario
        // devolvemos nil
        guard let authors: String = jsonBook["authors"],
            let imageUrl: String = jsonBook["image_url"],
            let url: String = jsonBook["pdf_url"],
            let tags: String = jsonBook["tags"],
            let title: String = jsonBook["title"] else {
                return nil
        }
        
        // Instanciamos un libro con los valores del Json
        let book = Book(title: title,
                        authors: authors,
                        tags: tags,
                        image: imageUrl,
                        url: url)
        
        let userDefaults = UserDefaults.standard
        let isBookFavorite = userDefaults.bool(forKey: String(book.hashValue))
        
        if isBookFavorite {
            book.favorite = true
        }
        
        return book
    })
}

 

func downloadAndStoreJson() -> Data {
    // Descargamos el JSON
    let json : Data
    let sourcePaths = FileManager.default.urls(for: .documentDirectory,
                                               in: .userDomainMask)
    let path = sourcePaths[0]
    let file: URL = URL(fileURLWithPath: "books_readable.json",
                        relativeTo: path)
    
    
    let fm = FileManager.default
    if fm.fileExists(atPath: file.path){
        json = try! Data(contentsOf: file)
        print("Devolvemos json de la carpeta Documents")
        return json
    }
    else {
        guard let url = URL(string: "https://t.co/K9ziV0z3SJ") else {
            fatalError("Wrong Json's url format")
        }
    
        guard let json = try? Data(contentsOf: url) else {
            fatalError("There has been a problem downloading the json file")
        }
    
        let fileManager = FileManager.default
        fileManager.createFile(atPath: file.path,
                               contents: json,
                               attributes: nil)
        return json
        
    }
}
