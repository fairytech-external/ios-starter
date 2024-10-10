//
//  ViewController.swift
//  FairyCashback
//
//  Created by junkyu kang on 10/10/24.
//

import UIKit
import SwiftUI
import Moment

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color
        view.backgroundColor = .white

        // Set the title
        self.title = "Home"

        // Create and configure the button
        let button = UIButton(type: .system)
        button.setTitle("Show Cashback Programs", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8

        // Add action to the button
        button.addTarget(self, action: #selector(showCashbackUI), for: .touchUpInside)

        // Enable Auto Layout
        button.translatesAutoresizingMaskIntoConstraints = false

        // Add the button to the view
        view.addSubview(button)

        // Set up constraints to center the button
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func showCashbackUI() {
        // Set the user ID before launching the CashbackUI
        MomentCashbackService.setUserId("user-id-is-needed")

        // Create the CashbackUI SwiftUI view with the onFinish closure
        let cashbackUI = MomentCashbackService.launchCashbackUI(onFinish: {
            // Pop the view controller when onFinish is called
            self.navigationController?.popViewController(animated: true)
        })

        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: cashbackUI)

        // Ensure the hostingController fills the entire screen
        hostingController.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        // Push the hostingController onto the navigation stack
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}

