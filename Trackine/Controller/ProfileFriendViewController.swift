//
//  ProfileFriendViewController.swift
//  Trackine
//
//  Created by Dayton on 23/04/21.
//

import UIKit

class ProfileFriendViewController: UIViewController {
    
    //MARK: - Properties

    var selectedFriend: CDFriends? { didSet { populateToolData() } }
    
    private var modalTransitioningDelegate: InteractiveModalTransitioningDelegate!
    private var borrowedTools = [CDTools]()
    
    private let borrowedTableView = UITableView().with {
        $0.tableFooterView = UIView()
        $0.register(BorrowedToolCell.self, forCellReuseIdentifier: BorrowedToolCell.reuseIdentifier)
    }
    
    //MARK: - LifeCyle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let currenttabBar = self.tabBarController as? TabBarViewController else {return}
        currenttabBar.tabBar.isHidden = true
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        guard let currenttabBar = self.tabBarController as? TabBarViewController else {return}
        currenttabBar.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let friendName = selectedFriend?.name else { return }
        configureNavigationBar(withTitle: friendName, prefersLargeTitles: true)
        
        configureUI()
        configureTable()
    }
    
    //MARK: - Helpers
    
    private func populateToolData() {
        guard let tools = selectedFriend?.tools?.allObjects as? [CDTools] else { return }
        
        if tools.count <= 0 {
            // Back to RootVC
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            //Populate Data
            borrowedTools = tools
            borrowedTableView.reloadData()
        }
    }
    
    private func configureUI() {
        view.addSubview(borrowedTableView)
        borrowedTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    private func configureTable() {
        borrowedTableView.rowHeight = 80
        borrowedTableView.delegate = self
        borrowedTableView.dataSource = self
    }
    
    private func goToReturnPicker(_ tool:CDTools?, _ friend:CDFriends?) {
        let controller = ReturnToolPickerView()
        controller.modalPresentationStyle = .custom
        modalTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.transitioningDelegate = modalTransitioningDelegate
        controller.toolToBeReturned = tool
        controller.toolLender = friend
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
}

    //MARK: - Extensions

extension ProfileFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return borrowedTools.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BorrowedToolCell.reuseIdentifier, for: indexPath) as? BorrowedToolCell else { fatalError("Could not create new cell") }

        let tool = borrowedTools[indexPath.row]
        
        cell.viewModel = ToolsViewModel(tool: tool)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let tool = borrowedTools[indexPath.row]
        goToReturnPicker(tool, selectedFriend)
    }
}

extension ProfileFriendViewController: LoanTransaction {
    func updateResultToCoreData(_ loan: Loan) {
        
        CoreDataHelper.updateTool(loan)
        
        if loan.tools.itemCount == 0 {
            // delete tools
            guard let friendName = loan.byFriend.name,
                  let toolName = loan.tools.name else { return }
            
            CoreDataHelper.deleteToolFromFriend(toolQuery: ToolQuery.transaction, friendName: friendName, toolName: toolName)
        }
        populateToolData()
    }
}
