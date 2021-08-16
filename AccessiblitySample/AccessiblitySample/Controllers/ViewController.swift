//
//  ViewController.swift
//  AccessiblitySample
//
//  Created by Delma Song on 2021/08/08.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let values: [String] = ["Accessibility Inspector", "UI Test"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.render(text: values[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "ToDoListViewController") as! ToDoListViewController
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let vc = AccessibilityToDoListViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - MainTableViewCell

final class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    func render(text: String) {
        label.text = text
    }
}
