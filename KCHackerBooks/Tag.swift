//
//  Tag.swift
//  PruebasPractica1
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import Foundation


class Tag {
    let name    : String
    private static let favoriteTagName: String = "Favorite"
    
    var isFavoriteTag: Bool {
        get {
            return name == Tag.favoriteTagName
        }
    }
    
    private static var favoriteTag: Tag = Tag(name: Tag.favoriteTagName)
    static var sharedFavoriteTag: Tag {
        get {
            return favoriteTag
        }
    }
    
    //MARK: - Initialization
    init(name: String) {
        self.name = name
    }
    
    //MARK: - Proxies
    func proxyForEquality() -> String{
        return name
    }
    
    func proxyForComparison() -> String{
        return proxyForEquality()
    }
    
    func proxyForHashing() -> Int {
        return name.hashValue
    }
    
}

//MARK: - Protocols

extension Tag : Equatable{
    
    public static func ==(lhs: Tag,
                          rhs: Tag) -> Bool{
        
        // Utilizamos el proxy de String para minimizar el trabajo (Propiedad name)
        return (lhs.proxyForEquality() == rhs.proxyForEquality())
    }
    
}

extension Tag : Comparable{
    
    public static func <(lhs: Tag,
                         rhs: Tag) -> Bool{
        
        ///////////////////////////////////
        // Tratamos el caso de que haya Favoritos de manera que lo ponga el primero de la lista (Si es Favorito siempre le decimos que es menor para que termine siempre como primer elemento de la lista)
        ///////////////////////////////////
        
        if lhs.isFavoriteTag  {
            return true
        }
        
        if rhs.isFavoriteTag {
            return false
        }
        /////////////////////////////////////
        // Utilizamos como proxy la implementación de String para minimizar el trabajo (Propiedad name)
        return (lhs.proxyForComparison() < rhs.proxyForComparison())
    }
    
}



extension Tag : CustomStringConvertible{
    public var description: String{
        get{
            return name
        }
    }
}


extension Tag: Hashable {
    var hashValue: Int {
        return proxyForHashing()
    }
}
