//
//  LoaderView.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import UIKit

//final class LoaderView {
//    static let shared = LoaderView()
//    private var loaderView: UIView?
//    
//    private init() { }
//
//    func showLoader(on view: UIView) {
//        guard loaderView == nil else { return } // Prevent adding multiple loaders
//        
//        // Create a dimmed background view
//        let backgroundView = UIView(frame: view.bounds)
//        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        backgroundView.isUserInteractionEnabled = true
//        
//        // Create the activity indicator
//        let activityIndicator = UIActivityIndicatorView(style: .large)
//        activityIndicator.center = backgroundView.center
//        activityIndicator.startAnimating()
//        
//        // Add activity indicator to the background view
//        backgroundView.addSubview(activityIndicator)
//        
//        // Add background view to the target view
//        view.addSubview(backgroundView)
//        loaderView = backgroundView
//    }
//
//    func hideLoader() {
//        loaderView?.removeFromSuperview()
//        loaderView = nil
//    }
//}


import UIKit

final class LoaderView: UIView {

    // MARK: - Lazy UI Components
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
    }
    
    // MARK: - Public Methods
    func showLoader(on view: UIView) {
        frame = view.bounds
        backgroundView.frame = bounds
        activityIndicator.center = backgroundView.center

        view.addSubview(self)
        activityIndicator.startAnimating()
    }

    func hideLoader() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }

   
}
