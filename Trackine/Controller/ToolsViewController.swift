//
//  ViewController.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import UIKit

class ToolsViewController: UIViewController {
    
    //MARK: - Properties
    private var dominicTools = [CDTools]()
    private var modalTransitioningDelegate: InteractiveModalTransitioningDelegate!
    
    private let toolsTableView = UITableView().with {
        $0.tableFooterView = UIView()
        $0.register(ToolsCell.self, forCellReuseIdentifier: ToolsCell.reuseIdentifier)
    }

    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadTools()
        toolsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTable()
        configureNavigationBar(withTitle: "Dominic's Tools", prefersLargeTitles: true)
        
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(toolsTableView)
        toolsTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    private func configureTable() {
        toolsTableView.rowHeight = 80
        toolsTableView.delegate = self
        toolsTableView.dataSource = self
    }
    
    private func loadTools() {
        dominicTools = CoreDataHelper.readTools(queryType: ToolQuery.dominicTools)
    }
    
    private func goToLoanPicker(_ tool:CDTools) {
        let controller = LoanPickerView()
        controller.modalPresentationStyle = .custom
        modalTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.transitioningDelegate = modalTransitioningDelegate
        controller.toolToBeLoaned = tool
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
}

    //MARK: - Extensions

extension ToolsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dominicTools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToolsCell.reuseIdentifier, for: indexPath) as? ToolsCell else { fatalError("Could not create new cell") }

        let tool = dominicTools[indexPath.row]
        let borrower = CoreDataHelper.readTools(queryType: ToolQuery.toolBorrowers, toolName: tool.name)
        
        cell.viewModel = ToolsViewModel(tool: tool, theOtherTools: borrower)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tool = dominicTools[indexPath.row]
        
        if tool.itemCount > 0 {
            // Show Picker
            goToLoanPicker(tool)
            
        } else {
            // Show Alert
            guard let name = tool.name else { return }
            showError(("\(name) have been borrowed out!"))
        }
    }
}

extension ToolsViewController:LoanTransaction {
    func updateResultToCoreData(_ loan: Loan) {
        CoreDataHelper.updateTool(loan)
        toolsTableView.reloadData()
    }
}
