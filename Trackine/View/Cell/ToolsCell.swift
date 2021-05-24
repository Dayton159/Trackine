//
//  ToolsCell.swift
//  Trackine
//
//  Created by Dayton on 22/04/21.
//

import UIKit

class ToolsCell: UITableViewCell {
    static let reuseIdentifier = "tools-table-cell-reuse-identifier"
    
    //MARK: - Properties
    
    var viewModel: ToolsViewModel? {
        didSet { populateCellData() }
    }
    
    private lazy var toolsImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(named: "appColor2")
    }
    
    private lazy var toolsName = UILabel().with{
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
    }
    
    private lazy var totalToolLabel = UILabel().with{
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private lazy var totalBorrowedLabel = UILabel().with{
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureCell() {
        addSubview(toolsImage)
        toolsImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        toolsImage.setDimensions(height: 60, width: 60)
        toolsImage.roundCorners(corners: .allCorners, radius: 60 / 2)
        
        let stack = UIStackView(arrangedSubviews: [toolsName, totalToolLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: toolsImage)
        stack.anchor(left: toolsImage.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(totalBorrowedLabel)
        totalBorrowedLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
    }
    
    private func populateCellData() {
        guard let viewModel = viewModel else { return }
        toolsImage.image = viewModel.toolsIcon
        toolsName.text = viewModel.toolName
        totalToolLabel.text = viewModel.totalItem
        totalBorrowedLabel.text = viewModel.totalBorrowed
    }
}
