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
        configureRootUI()
        loadStudents()
    }

    func loadStudents() {
        Loader.show(on: self)
        StudentInformationClient.shared.getStudents(with: [:], success: { _ in
            Loader.hide()
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }, failure: { error in
            Loader.hide()
            Dialog.show(message: error?.localizedDescription, title: "Failed to fetch students")
        })
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
        if let count = StudentInformationClient.shared.students?.count {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if let student = StudentInformationClient.shared.students?[indexPath.row] {
            configure(cell: cell, student: student)
        }
        return cell!
    }
}
