//
//  LoanPickerView.swift
//  Trackine
//
//  Created by Dayton on 22/04/21.
//

import UIKit

class LoanPickerView: UIViewController {
    
    // MARK: - Properties
    private var lenderPickerView: UIPickerView!
    
    private var friendsToLend: [CDFriends] = []
    private var quantityRange: [Int16] = []
    weak var delegate: LoanTransaction?
    
    var toolToBeLoaned:CDTools?
    
    private lazy var containerView = UIView().with {
        $0.backgroundColor = .clear
    }
    
    private lazy var fifteenHeightView = UIView().with {
        $0.backgroundColor = .white
        $0.setHeight(height: 15)
    }
    
    private lazy var pickerContainerView = UIView().with {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private lazy var headingContainerView = UIView().with {
        $0.backgroundColor = UIColor(named: "appColor1")
    }
    
    private lazy var doneButton = UIButton(type: .system).with {
        $0.setTitle("OK", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    }
    
    private lazy var chevronButton = UIButton(type: .custom).with {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
    }
    
    private lazy var headingLabel = UILabel().with {
        $0.text = "Lend Tools"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        setupPicker()
        loadData()
    }
    
    // MARK: - Helpers
    private func configureController() {
        view.addSubview(containerView)
        containerView.addSubview(fifteenHeightView)
        containerView.addSubview(pickerContainerView)
        pickerContainerView.addSubview(headingContainerView)
        headingContainerView.addSubview(doneButton)
        headingContainerView.addSubview(headingLabel)
        headingContainerView.addSubview(chevronButton)
        
        containerView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        
        fifteenHeightView.anchor(
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor
        )
        
        pickerContainerView.anchor(
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor
        )
        pickerContainerView.setProportionalHeight(equalTo: view, multiplier: 0.4)
                
        headingContainerView.anchor(
            top: pickerContainerView.topAnchor,
            left: pickerContainerView.leftAnchor,
            right: pickerContainerView.rightAnchor
        )
        headingContainerView.setHeight(height: 50)
        
        doneButton.anchor(
            top: headingContainerView.topAnchor,
            bottom: headingContainerView.bottomAnchor,
            right: headingContainerView.rightAnchor,
            paddingRight: 10
        )
        doneButton.setWidth(width: 60)
        
        headingLabel.anchor(
            top: headingContainerView.topAnchor,
            bottom: headingContainerView.bottomAnchor
        )
        headingLabel.centerX(inView: headingContainerView)
        
        chevronButton.anchor(
            top: headingContainerView.topAnchor,
            left: headingContainerView.leftAnchor,
            bottom: headingContainerView.bottomAnchor,
            paddingTop: 5,
            paddingLeft: 10,
            paddingBottom: 5
        )
        
        let aspecRatio = NSLayoutConstraint(item: chevronButton, attribute: .height, relatedBy: .equal, toItem: chevronButton, attribute: .width, multiplier: 1.0/1.0, constant: 0)
        chevronButton.addConstraint(aspecRatio)
    }
    
    private func setupPicker() {
        self.lenderPickerView = UIPickerView(frame: .zero)
       
        pickerContainerView.addSubview(lenderPickerView)
        
        lenderPickerView.anchor(
            top: headingContainerView.bottomAnchor,
            left: pickerContainerView.leftAnchor,
            bottom: pickerContainerView.bottomAnchor,
            right: pickerContainerView.rightAnchor
        )
        lenderPickerView.dataSource = self
        lenderPickerView.delegate = self
       
    }
    
    private func loadData() {
        
        guard let maxRange = toolToBeLoaned?.itemCount else { return }
        friendsToLend.removeAll()
        quantityRange.removeAll()
        
        friendsToLend = CoreDataHelper.readFriends()
        for range in 1...maxRange { quantityRange.append(range)}
        
        refreshPicker()
    }
    
    private func refreshPicker() {
        lenderPickerView.reloadAllComponents()
    }
    
    // MARK: - Selectors
    @objc func donePressed() {
        let selectedFriend = lenderPickerView.selectedRow(inComponent: 0)
        let selectedQuantity = lenderPickerView.selectedRow(inComponent: 1)

        let friendValue = friendsToLend[selectedFriend]
        let quantityValue = quantityRange[selectedQuantity]
        
        guard let tool = toolToBeLoaned else { return }
        let model = Loan(tools: tool, byFriend: friendValue, value: quantityValue, toolQuery: ToolQuery.transaction)
        
        self.delegate?.updateResultToCoreData(model)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func actionDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

    //MARK: - Extensions
extension LoanPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return friendsToLend.count
            
        } else {
            return quantityRange.count
        }
        
    }
}

extension LoanPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if component == 0 {
            label.text = friendsToLend[row].name
            
        } else {
            label.text = String(quantityRange[row])
        }
        
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
    
}
