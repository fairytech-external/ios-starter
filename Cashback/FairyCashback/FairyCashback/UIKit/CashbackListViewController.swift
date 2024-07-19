/*
 Fairy Technologies CONFIDENTIAL
 __________________
  
 Copyright (C) Fairy Technologies, Inc - All Rights Reserved
 
 NOTICE:  All information contained herein is, and remains
 the property of Fairy Technologies Incorporated and its suppliers,
 if any.  The intellectual and technical concepts contained
 herein are proprietary to Fairy Technologies Incorporated
 and its suppliers and may be covered by U.S. and Foreign Patents,
 patents in process, and are protected by trade secret or copyright law.
 Dissemination of this information, or reproduction or modification of this material
 is strictly forbidden unless prior written permission is obtained
 from Fairy Technologies Incorporated.
*/

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
        tableView.register(CashbackTableViewCell.self, forCellReuseIdentifier: CashbackTableViewCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CashbackTableViewCell.identifier, for: indexPath) as? CashbackTableViewCell else {
            fatalError("Failed to dequeue CashbackTableViewCell")
        }
        let program = cashbackPrograms[indexPath.row]
        cell.configure(with: program)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 
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
