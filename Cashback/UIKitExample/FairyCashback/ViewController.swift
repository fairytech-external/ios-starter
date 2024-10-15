//
//  ViewController.swift
//  FairyCashback
//
//  Created by junkyu kang on 10/10/24.
//

import UIKit
import Moment

class ViewController: UIViewController {
    private var cashbackView: CashbackView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the user interface
        view.backgroundColor = .white

        // Add a button to present the cashback view
        let showCashbackButton = UIButton(type: .system)
        showCashbackButton.setTitle("Show Cashback", for: .normal)
        showCashbackButton.addTarget(self, action: #selector(showCashback), for: .touchUpInside)

        showCashbackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showCashbackButton)
        NSLayoutConstraint.activate([
            showCashbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showCashbackButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func showCashback() {
        // Set the user ID before using CashbackView
        MomentCashbackService.setUserId("user-id-is-needed")

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Create and configure CashbackView
        let cashbackView = CashbackView(
            onFinish: { [weak self] in
                self?.removeCashbackView()
                print("Cashback finished")
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
            },
            onFailure: { [weak self] error in
                print("Error: \(error.localizedDescription)")
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
            }
        )

        // Store a reference to cashbackView
        self.cashbackView = cashbackView

        // Add CashbackView to the view hierarchy
        self.view.addSubview(cashbackView)

        // Set up constraints
        cashbackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashbackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cashbackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            cashbackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cashbackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func removeCashbackView() {
        if let cashbackView = self.cashbackView {
            cashbackView.removeFromSuperview()
            self.cashbackView = nil
        }
    }
}
