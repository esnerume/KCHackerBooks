//
//  AppDelegate.swift
//  KCHackerBooks
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

/*
     *********************************
     * IMPORTANTE RECORDATORIO
     **********************************
     Es importante activar en el fichero Info.plist el Acceso a la red para conexiones no seguras. De Otra manera no cargarán las imágenes que vayan por http
     
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
 */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let library = Library(books: decodeJson())
        
        let libraryViewController = LibraryTableViewController(library: library)
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        
        
        let firstSelectedBook = getFirstBookFrom(library: library)
        let bookViewController = BookViewController(book: firstSelectedBook)
        let bookNavigationController = UINavigationController(rootViewController: bookViewController)
        
        
        let splitViewController = UISplitViewController(nibName: nil, bundle: nil)
        splitViewController.viewControllers = [libraryNavigationController, bookNavigationController]
        
        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                libraryViewController.delegate = libraryViewController
            case .pad:
                libraryViewController.delegate = bookViewController
                bookViewController.delegate = libraryViewController
            default:
                fatalError("Unknown Device trying to run the App")
        }
        
        self.window?.rootViewController = splitViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    //MARK: - Utils
    
    
    func getFirstBookFrom(library: Library) -> Book {
        // Cogemos el primer libro del primer Tag (Pudiendo ser de Favoritos, si es que hay, o del primer Tag ordenado alfabéticamente
        return library.book(forTag: library.tags.first!, at: 0)!
    }
    
}

