//
//  ViewController.swift
//  FairyCashback
//
//  Created by junkyu kang on 10/10/24.
//

import UIKit
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
        button.addTarget(self, action: #selector(presentCashback), for: .touchUpInside)

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

    @objc func presentCashback() {
        // 캐시백 UI를 표시하기 전에 사용자 ID 설정
        MomentCashbackService.setUserId("user-id-is-needed")

        // CashbackViewController 인스턴스 생성
        let cashbackVC = CashbackViewController()
        cashbackVC.delegate = self

        // 권장사항에 따라 내비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        // CashbackViewController를 내비게이션 스택에 푸시
        self.navigationController?.pushViewController(cashbackVC, animated: true)
    }
}

// MARK: - CashbackViewControllerDelegate Methods
extension ViewController: CashbackViewControllerDelegate {
    func cashbackViewControllerDidFinish(_ viewController: CashbackViewController) {
        // Handle finish
        navigationController?.popViewController(animated: true)

        // Optionally show the navigation bar again
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func cashbackViewController(_ viewController: CashbackViewController, didFailWithError error: CashbackError) {
        // Handle error - 예시입니다.
        print("Error: \(error.localizedDescription)")
        navigationController?.popViewController(animated: true)

        // Optionally show the navigation bar again
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
