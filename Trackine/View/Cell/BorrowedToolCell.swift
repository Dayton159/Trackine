//
//  BorrowedToolCell.swift
//  Trackine
//
//  Created by Dayton on 23/04/21.
//

import UIKit

class BorrowedToolCell: UITableViewCell {
    static let reuseIdentifier = "borrowed-table-cell-reuse-identifier"
    
    //MARK: - Properties
    
    var viewModel: ToolsViewModel? {
        didSet { populateCellData() }
    }
    
    private lazy var borrowedToolImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(named: "appColor2")
        $0.clipsToBounds = true
    }
    
    private lazy var borrowedToolName = UILabel().with{
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
    }
    
    private lazy var totalToolBorrowedLabel = UILabel().with{
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
        addSubview(borrowedToolImage)
        borrowedToolImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        borrowedToolImage.setDimensions(height: 60, width: 60)
        borrowedToolImage.roundCorners(corners: .allCorners, radius: 60 / 2)
        
        addSubview(borrowedToolName)
        borrowedToolName.centerY(inView: borrowedToolImage)
        borrowedToolName.anchor(left: borrowedToolImage.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(totalToolBorrowedLabel)
        totalToolBorrowedLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        totalToolBorrowedLabel.centerY(inView: self)
    }
    
    private func populateCellData() {
        guard let viewModel = viewModel else { return }
        
        borrowedToolImage.image = viewModel.toolsIcon
        borrowedToolName.text = viewModel.toolName
        totalToolBorrowedLabel.text = viewModel.totalItem
    }
}

