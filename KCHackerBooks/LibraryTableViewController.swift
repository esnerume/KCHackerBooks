//
//  LibraryTableViewController.swift
//  KCHackerBooks
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

    //MARK: - Properties
    static let appName = "Hacker Books"
    var library: Library
    weak var delegate: LibraryTableViewControllerDelegate? = nil
    fileprivate var collapseDetailViewController = true
    
    //MARK: - Computed Properties
    
    var defaultBookImageData: Data {
        get {
            let defaultBookUrl = Bundle.main.url(forResource: "defaultbook",
                                                  withExtension: "png")!
            return try! Data(contentsOf: defaultBookUrl)
        }
    }
    
    //MARK: - Initialization
    
    init(library: Library) {
        self.library = library
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        // Activamos esto para no perder la selección de la tabla cuando rotamos
        self.navigationItem.title = LibraryTableViewController.appName
        
        // Cargamos y Registramos la Celda Personalizada
        let bookTableCellNib = UINib(nibName: "BookTableViewCell", bundle: nil)
        tableView.register(bookTableCellNib, forCellReuseIdentifier: BookTableViewCell.cellId)
        
        // Seleccionamos la primera fila de la TableView y Mantenemos la selección al rotar sólo si es un iPad 
        if(UIDevice.current.userInterfaceIdiom == .pad) {
                let rowToSelect:NSIndexPath = NSIndexPath(item: 0, section: 0)
                self.tableView.selectRow(at: rowToSelect as IndexPath,
                                         animated: false,
                                         scrollPosition: UITableViewScrollPosition.top)
            
                self.clearsSelectionOnViewWillAppear = false
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return library.tagCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.bookCount(forTag: tag(inSection: section))
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tagContent = tag(inSection: section).description
        return tagContent.capitalized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = library.book(forTag: tag(inSection: indexPath.section),
                                at: indexPath.row)
        
        let cellId = BookTableViewCell.cellId
                
        
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BookTableViewCell ?? BookTableViewCell()
        
  
        cell.setImageView(with: AsyncData(url: (book?.image)!,
                                              defaultData: defaultBookImageData))
        cell.titleLabel?.text = book?.title
        cell.authorsLabel?.text = book?.listAuthors
        cell.tagsLabel?.text = book?.listTags
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBook = library.book(forTag: tag(inSection: indexPath.section), at: indexPath.row) else {
            return
        }
        
        delegate?.libraryViewController(self, didSelectBook: selectedBook)
        // Notificamos que ha cambiado la selección
        notify(bookDidChange: selectedBook)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    
    //MARK: - Utils
    
    func tag(inSection section: Int) -> Tag {
        return library.tags[section]
    }


}



//MARK: - Protocols

protocol LibraryTableViewControllerDelegate: class {
    func libraryViewController(_ sender: LibraryTableViewController, didSelectBook book: Book)
}


//MARK: - LibraryViewControllerDelegate

extension LibraryTableViewController:UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        // Retornamos true para prevenir que el ViewController secundario se muestre por defecto, si no en iPhone resulta especialmente raro que se cargue por defecto la ficha de un libro. En mi opinión es mejor partir de la lista de libros/Librería en el teléfono.
        return true
    }
}

extension LibraryTableViewController: LibraryTableViewControllerDelegate {
    func libraryViewController(_ sender: LibraryTableViewController, didSelectBook book: Book) {
        let bookController = BookViewController(book: book)
        bookController.delegate = self
        navigationController?.pushViewController(bookController, animated: true)
    }
}


//MARK: - BookViewControllerDelegate

extension LibraryTableViewController: BookViewControllerDelegate {
    func bookDidChangeFavoriteStatus(book: Book, isFavorite: Bool) {
        if (isFavorite) {
            library.addBookToFavorites(book: book)
        } else {
            library.removeBookFromFavorites(book: book)
        }
        
        self.tableView.reloadData()
    }
}

//MARK: - Notifications

extension LibraryTableViewController {
    
    static let notificationName = Notification.Name(rawValue: "LibraryBookDidChange")
    static let key = "book"
    
    func notify(bookDidChange book: Book) {
        let nc = NotificationCenter.default
        let notification = Notification(name: LibraryTableViewController.notificationName,
                                        object: self,
                                        userInfo: [LibraryTableViewController.key : book])
        
        nc.post(notification)
    }
}

