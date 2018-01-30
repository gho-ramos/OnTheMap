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

    class func instance() -> Self {
        return instance(from: "List", identifier: String(describing: self.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents(shouldForceReload: true)
        configureUI()
    }

    func configureUI() {
        configureLogoutButton()
        configureUIButtons()
    }

    func configureUIButtons() {
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(reloadStudents))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }

    @objc func reloadStudents() {
        loadStudents(shouldForceReload: true)
    }

    func loadStudents(shouldForceReload: Bool = true) {
        Loader.show(on: self)
        if shouldForceReload {
            StudentInformationClient.shared.getStudents(with: [:], success: { _ in
                Loader.hide()
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }, failure: { error in
                Loader.hide()
                Dialog.show(message: error?.localizedDescription, title: "Failed to fetch students")
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
        if let count = StudentInformationClient.shared.all?.count {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if let student = StudentInformationClient.shared.all?[indexPath.row] {
            configure(cell: cell, student: student)
        }
        return cell!
    }
}
