//
//  FriendsViewController.swift
//  Trackine
//
//  Created by Dayton on 22/04/21.
//

import UIKit

class FriendsViewController: UIViewController {
    
    //MARK: - Properties
    
    private var dominicFriends = [CDFriends]()
    
    private let friendsTableView = UITableView().with {
        $0.tableFooterView = UIView()
        $0.register(FriendsCell.self, forCellReuseIdentifier: FriendsCell.reuseIdentifier)
    }
    //MARK: - LifeCyle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavigationBar(withTitle: "Dominic's Friends", prefersLargeTitles: true)
        loadFriends()
        friendsTableView.reloadData()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTable()
    }
    
    //MARK: - Helpers
    
    private func loadFriends() {
        dominicFriends = CoreDataHelper.readFriends()
    }
    
    private func configureUI() {
        view.addSubview(friendsTableView)
        friendsTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    private func configureTable() {
        friendsTableView.rowHeight = 80
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    private func goToSelectedFriend(friend:CDFriends) {
        let mainInputController = ProfileFriendViewController()
        navigationController?.pushViewController(mainInputController, animated: true)
        mainInputController.selectedFriend = friend
    }
}


extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dominicFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.reuseIdentifier, for: indexPath) as? FriendsCell else { fatalError("Could not create new cell") }

        let friend = dominicFriends[indexPath.row]
        
        cell.viewModel = FriendsViewModel(friend: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend = dominicFriends[indexPath.row]
        let viewModel = FriendsViewModel(friend: friend)
        
        if viewModel.borrowedItem <= 0 {
            // Show Alert
            guard let name = friend.name else { return }
            showError(("\(name) haven't borrowed any tools yet"))
            
        } else {
            goToSelectedFriend(friend: friend)
        }
    }
}
