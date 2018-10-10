//
//  UserListViewController.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var userListTableView: UITableView!

    //MARK: - Variables
    
    var users: [User]?
    var passingUser: User?
    
    lazy var refreshControl = UIRefreshControl()
    
    //MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPullToRefresh()
        self.loadUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FilterOptionsHelper.shared.isUpdateNeeded {
            self.getAllUsers()
        }
    }
    
    //MARK: - Private methods
    
    private func configPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading new random users...")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        userListTableView.addSubview(refreshControl)
    }
    
    private func loadUsers() {
        if let savedUsers = CoreDataManager.shared.fetchAllUsers(), savedUsers.count > 0 {
            var usersArray: [User] = []
            for cdUser in savedUsers {
                let user = User(coreDataUserObject: cdUser)
                usersArray.append(user)
            }
            self.users = usersArray
            self.userListTableView.reloadData()
        } else {
            self.getAllUsers()
        }
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
                    CoreDataManager.shared.saveUsers(users: usersArray)
                    self.userListTableView.reloadData()
                    FilterOptionsHelper.shared.isUpdateNeeded = false
                    self.refreshControl.endRefreshing()
                }
            }
        })
    }
    
    @objc private func refresh() {
        self.getAllUsers()
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
        if let user = self.users?[indexPath.row] {
            self.passingUser = user
            self.performSegue(withIdentifier: "showUserDetailsSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let passingUser = self.passingUser else {
            return
        }
        let userDetailsVC = segue.destination as! UserDetailsViewController
        userDetailsVC.selectedUser = passingUser
    }
}
