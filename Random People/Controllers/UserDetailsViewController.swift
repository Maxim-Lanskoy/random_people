//
//  UserDetailsViewController.swift
//  Random People
//
//  Created by Maxim Lanskoy on 10.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var registrationDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //MARK: - Variables

    var selectedUser: User!

    //MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUIWithSelectedUser()
    }
    
    //MARK: - Interface Builder actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Private methods
    
    private func configureUIWithSelectedUser() {
        self.userAvatarImageView.image = UIImage(named: "avatarPlaceholder")
        self.userNameLabel.text = selectedUser.title.capitalized + " " + selectedUser.firstName.capitalized + " " + selectedUser.lastName.capitalized
        self.genderLabel.text   = "Gender: " + selectedUser.gender
        self.phoneLabel.text    = "Phone: " + selectedUser.phone
        
        self.birthDateLabel.text        = "Birth Date: " + selectedUser.dateOfBirth.components(separatedBy: "T")[0]
        self.registrationDateLabel.text = "Reg.  Date: " + selectedUser.dateOfRegistration.components(separatedBy: "T")[0]
        self.locationLabel.text         = selectedUser.getLocationString()
        
        if let imageURLString = selectedUser.userAvatar {
            self.userAvatarImageView.loadImageWith(url: imageURLString)
        }
    }
}
