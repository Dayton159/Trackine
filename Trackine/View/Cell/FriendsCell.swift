//
//  FriendsCell.swift
//  Trackine
//
//  Created by Dayton on 23/04/21.
//

import UIKit

class FriendsCell: UITableViewCell {
    static let reuseIdentifier = "friends-table-cell-reuse-identifier"
    
    //MARK: - Properties
    
    var viewModel: FriendsViewModel? {
        didSet { populateCellData() }
    }
    
    private lazy var friendsImage = UIImageView().with {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var friendsName = UILabel().with{
        $0.font = UIFont.boldSystemFont(ofSize: 18)
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
        addSubview(friendsImage)
        friendsImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        friendsImage.setDimensions(height: 60, width: 60)
        friendsImage.roundCorners(corners: .allCorners, radius: 60 / 2)
        
        addSubview(friendsName)
        friendsName.centerY(inView: friendsImage)
        friendsName.anchor(left: friendsImage.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(totalBorrowedLabel)
        totalBorrowedLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        totalBorrowedLabel.centerY(inView: self)
    }
    
    private func populateCellData() {
        guard let viewModel = viewModel else { return }
        
        friendsImage.image = viewModel.friendPicture
        friendsName.text = viewModel.friendName
        totalBorrowedLabel.text = viewModel.totalItemBorrowed
    }
}
