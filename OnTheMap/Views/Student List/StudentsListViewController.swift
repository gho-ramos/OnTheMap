//
//  StudentsListViewController.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 24/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class StudentsListViewController: UIViewController {
    let cellIdentifier: String = "studentCell"

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents(shouldForceReload: true)
        configureUI()
    }

    func configureUI() {
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(reloadStudents))
        navigationItem.rightBarButtonItems?.append(refreshButton)
    }

    @objc func reloadStudents() {
        loadStudents(shouldForceReload: true)
    }

    func loadStudents(shouldForceReload: Bool = true) {
        Loader.show(on: self)
        if shouldForceReload {
            let parameters = ["order": "-updatedAt"]
            StudentInformationClient.shared.getStudents(with: parameters as [String: AnyObject], success: { _ in
                Loader.hide()
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }, failure: { error in
                Loader.hide()
                Dialog.show(message: error?.localizedDescription, title: "Failed to download the list of students")
            })
        } else {
            Loader.hide()
            self.tableView.reloadData()
        }
    }

    func configure(cell: UITableViewCell?, student: StudentLocation?) {
        if let cell = cell, let student = student {
            cell.textLabel?.text = student.fullName()
            cell.detailTextLabel?.text = student.mediaURL ?? ""
        }
    }
}

extension StudentsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationClient.shared.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let student = StudentInformationClient.shared.all[indexPath.row]

        configure(cell: cell, student: student)

        return cell!
    }
}

extension StudentsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentInformationClient.shared.all[indexPath.row]

        UIApplication.shared.open(url: student.mediaURL)
    }
}
