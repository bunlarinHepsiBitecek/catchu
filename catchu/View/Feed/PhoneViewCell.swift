//
//  PhoneViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/18/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

fileprivate extension Selector {
    static let phoneTextFieldDidChange = #selector(PhoneViewPhoneCell.textFieldDidChange(_:))
    static let confirmationTextFieldDidChange = #selector(PhoneViewConfirmationCell.textFieldDidChange(_:))
}

class PhoneViewCountryCell: BaseTableCell {
    
    var item: PhoneViewModelCountryItem?
    
    func configure(item: PhoneViewModelItem) {
        guard let item = item as? PhoneViewModelCountryItem  else { return }
        self.item = item
        
        if let country = item.country {
            textLabel?.text = country.name
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupStyle()
    }
    
    func setupStyle() {
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
        self.accessoryView = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.selectionStyle = .none
        self.accessoryType = .none
        self.accessoryView = nil
        
        self.textLabel?.text = nil
    }
}

class PhoneViewPhoneCell: BaseTableCell {
    
    var item: PhoneViewModelPhoneItem?
    
    let padding: CGFloat = 20
    
    let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.isEnabled = false
        label.numberOfLines = 1
        
        return label
    }()
    
    let countryDialCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.isEnabled = false
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var phoneNumTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = LocalizedConstants.EditableProfile.Phone
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        
        textField.addTarget(self, action: .phoneTextFieldDidChange, for: .editingChanged)
        
        return textField
    }()
    
    
    override func setupViews() {
        
        let layoutMargin = UIEdgeInsets(top: padding/2, left: padding, bottom: padding/2, right: padding)
        
        let countryStackView = UIStackView(arrangedSubviews: [countryCodeLabel, countryDialCodeLabel])
        countryStackView.alignment = .fill
        countryStackView.distribution = .fillProportionally
        countryStackView.spacing = padding
        
        let cellStackView = UIStackView(arrangedSubviews: [countryStackView, phoneNumTextField])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .leading
        cellStackView.distribution = .fill
        cellStackView.spacing = padding
        cellStackView.layoutMargins = layoutMargin
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        self.contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
        
        setupStyle()
    }
    
    func setupStyle() {
        self.selectionStyle = .none
        self.accessoryType = .none
        self.accessoryView = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionStyle = .none
        self.accessoryType = .none
        self.accessoryView = nil
        
        self.item = nil
        self.countryCodeLabel.text = nil
        self.countryDialCodeLabel.text = nil
        self.phoneNumTextField.text = nil
    }
    
    func configure(item: PhoneViewModelItem) {
        guard let item = item as? PhoneViewModelPhoneItem else { return }
        self.item = item
        
        if let country = item.country {
            countryCodeLabel.text = country.countryCode
            countryDialCodeLabel.text = country.phoneExtension
        }
        if let phoneNum = item.phone {
            phoneNumTextField.text = phoneNum
        }
    }
}

extension PhoneViewPhoneCell {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let item = self.item else { return }
        item.phone = textField.text
    }
}

class PhoneViewConfirmationCell: BaseTableCell {
    
    var item: PhoneViewModelConfirmationItem?
    
    let padding: CGFloat = 20
    
    lazy var confirmationNumTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = LocalizedConstants.EditableProfile.ConfirmationCode
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        
        textField.addTarget(self, action: .confirmationTextFieldDidChange, for: .editingChanged)
        
        textField.delegate = self
        
        return textField
    }()
    
    override func setupViews() {
        
        let layoutMargin = UIEdgeInsets(top: padding/2, left: padding, bottom: padding/2, right: padding)
        
        let cellStackView = UIStackView(arrangedSubviews: [confirmationNumTextField])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .leading
        cellStackView.distribution = .fill
        cellStackView.spacing = 10
        cellStackView.layoutMargins = layoutMargin
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        self.contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
        
        setupStyle()
    }
    
    func setupStyle() {
        self.selectionStyle = .none
        self.accessoryType = .none
        self.accessoryView = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.selectionStyle = .none
        self.accessoryType = .none
        self.accessoryView = nil
        
        guard let item = item else { return }
        item.isValidConfirmation.unbind()
        self.item = nil
    }
    
    func configure(item: PhoneViewModelItem) {
        guard let item = item as? PhoneViewModelConfirmationItem else { return }
        self.item = item
    }
}

extension PhoneViewConfirmationCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        
        return count <= Validation.ConfirmationValidationCount
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let item = item else { return }
        
        if let text = textField.text {
            item.confirmationCode = text
            item.isValidConfirmation.value = Validation.shared.isValidConfirmationCode(confirmationCode: text)
        }
    }
    
}
