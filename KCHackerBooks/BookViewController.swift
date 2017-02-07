//
//  BookViewController.swift
//  KCHackerBooks
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    let defaultBookUrl = Bundle.main.url(forResource: "defaultbook", withExtension: "png")!
    

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var book: Book
    fileprivate var imageData: AsyncData
    weak var delegate: BookViewControllerDelegate? = nil

    //MARK: - Initialization
    
    init(book: Book) {
        self.book = book
        imageData = AsyncData(url: book.image,
                              defaultData: try! Data(contentsOf: defaultBookUrl))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncViewWithModel()
    }
    

    @IBAction func readPDF(_ sender: Any) {
        let pdfViewController = PDFViewController(book: book)
        // Modificamos el texto del Botón de Back para que no coja el valor de title del BookViewController (Para que no quede demasiado repetitivo)
        /*
        navigationController?.navigationItem.backBarButtonItem?.title = "Back to Book Sheet"
        */
        navigationController?.navigationBar.backItem?.title = "Back"
        navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
    @IBAction func notFavorite(_ sender: Any) {
        book.notFavorite()
        setFavoriteIcon()
        delegate?.bookDidChangeFavoriteStatus(book: book,
                                             isFavorite: book.isFavorite)
        storeFavoriteStatus()
    }
    
    //MARK: - View Synchronization
    
    func syncViewWithModel() {
        self.title = "\(book.title) - Book Sheet"
        syncImageView()
        setFavoriteIcon()
    }
    
    func setFavoriteIcon() {
        // Dependiendo de si es favorito o no le colocamos o no un corazón relleno
        favoriteButton.image = book.isFavorite ? UIImage(named: "favorite_selected.png") : UIImage(named: "favorite.png")
    }
    
    
    //MARK: - Favorite handling
    
    func storeFavoriteStatus() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(book.isFavorite, forKey: String(book.hashValue))
    }
    
    
    //MARK: - AsyncData Handling
    
    func syncImageView() {
        imageData = AsyncData(url: book.image, defaultData: try! Data(contentsOf: defaultBookUrl))
        imageData.delegate = self
        bookImageView.image = UIImage(data: imageData.data)
    }

}



//MARK: - Protocols

// Definimos el protocolo que luego implementará LibraryTableViewController
// Para actualizar la Tabla (En coconcreto la sección de Favoritos), cuando
// un libro cambia su estado de Favorito.
protocol BookViewControllerDelegate: class {
    func bookDidChangeFavoriteStatus(book: Book, isFavorite: Bool)
}


//MARK: - AsyncDataDelegate

extension BookViewController: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        UIView.transition(with: bookImageView,
                          duration: 0.9,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.bookImageView.image = UIImage(data: sender.data)
                            
        }, completion: nil)
    }
}

//MARK: - LibraryViewControllerDelegate

extension BookViewController: LibraryTableViewControllerDelegate {
    func libraryViewController(_ sender: LibraryTableViewController,
                               didSelectBook book: Book) {
        self.book = book
        syncViewWithModel()
    }
}
