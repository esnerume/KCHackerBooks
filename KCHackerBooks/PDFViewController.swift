//
//  PDFViewController.swift
//  KCHackerBooks
//
//  Created by Rubén Merino Losada on 5/2/17.
//  Copyright © 2017 Mqc. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    let mimeType: String = "application/pdf"
    let defaultPDF: URL = Bundle.main.url(forResource: "downloadingpdf", withExtension: "pdf")!
    
    //MARK: - Properties

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pdfAsyncData: AsyncData
    
    //MARK: - Initialization
    
    init(book: Book) {
        pdfAsyncData = AsyncData(url: book.url,
                                 defaultData: try! Data(contentsOf: defaultPDF))
        super.init(nibName: nil, bundle: nil)
        pdfAsyncData.delegate = self
        self.title = "\(book.title) - Pdf Document"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Al Aparecer la vista nos suscribimos a las notificaciones
        subscribe()
        // Abrimos el PDF
        openPdfInBrowser()
        // Ponemos el Incicador de Carga a Cargando
        startLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Al desaparecer la vista nos eliminamos la suscripción a las notificaciones
        unsubscribe()
    }
    
    //MARK: - Web View Load Document
    
    func openPdfInBrowser() {
        webView.load(pdfAsyncData.data,
                     mimeType: mimeType,
                     textEncodingName: "",
                     baseURL: Bundle.main.bundleURL)
    }
    
    //MARK: - Activity Indicator LifeCycle
    
    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    //MARK: - AsyncData
    
    func syncPdfData(url: URL) {
        pdfAsyncData = AsyncData(url: url, defaultData: try! Data(contentsOf: defaultPDF))
        pdfAsyncData.delegate = self
        openPdfInBrowser()
    }
    
    
}

//MARK: - AsyncData Delegate

extension PDFViewController: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        openPdfInBrowser()
        stopLoading()
    }
}

//MARK: - Notifications

extension PDFViewController {
    // Si recibimos la notificación de Cambio de libro regargamos el Pdf
    func bookDidChange(_ notification: Notification) {
        let newBook = notification.userInfo?[LibraryTableViewController.key] as! Book
        syncPdfData(url: newBook.url)
    }
    
    func subscribe() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: LibraryTableViewController.notificationName, object: nil, queue: OperationQueue.main, using: { self.bookDidChange($0) })
    }
    
    func unsubscribe() {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
}

