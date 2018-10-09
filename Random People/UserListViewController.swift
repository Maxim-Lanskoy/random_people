//
//  UserListViewController.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    var users: [User]?

    @IBOutlet weak var userListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllUsers()
    }
    
    private func getAllUsers() {
        HTTPClient.getUsers(completion: { (response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let usersArray = response {
                    self.users = usersArray
                    self.userListTableView.reloadData()
                }
            }
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserListViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListTableViewCell", for: indexPath)
        if let user = self.users?[indexPath.row] {
            cell.textLabel?.text = user.title + " " + user.firstName.capitalized + " " + user.lastName.capitalized
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


