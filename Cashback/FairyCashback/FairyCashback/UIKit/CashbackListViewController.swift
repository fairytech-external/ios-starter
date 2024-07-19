//
//  CashbackListViewController.swift
//  FairyCashback
//
//  Created by junkyu kang on 7/19/24.
//

import Foundation
import UIKit
import SwiftUI
import Moment

struct UIKitCashbackListView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let uiKitVC = CashbackViewController()
        return UINavigationController(rootViewController: uiKitVC)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

class CashbackViewController: UIViewController {
    private let tableView = UITableView()
    private var cashbackPrograms: [CashbackProgram] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCashbackPrograms()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func fetchCashbackPrograms() {
        Task {
            do {
                MomentCashbackService.setUserId("test_user_id")
                cashbackPrograms = try await MomentCashbackService.listCashback()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching cashback programs: \(error)")
            }
        }
    }
}

extension CashbackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cashbackPrograms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let program = cashbackPrograms[indexPath.row]
        cell.textLabel?.text = program.businessName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let program = cashbackPrograms[indexPath.row]
        let detailsVC = MomentCashbackService.goToCashbackViewController(
            cashbackBusinessId: program.businessID,
            cashbackViewDelegate: self
        )
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension CashbackViewController: CashbackViewDelegate {
    func didLinkOpened(businessId: String, url: URL) {
        print("Link opened for business \(businessId): \(url)")
    }

    func didErrorOccurred(businessId: String, error: Error) {
        print("Error occurred for business \(businessId): \(error)")
    }
}
