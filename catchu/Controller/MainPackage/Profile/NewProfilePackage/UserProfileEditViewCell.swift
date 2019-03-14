//
//  UserProfileEditViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileEditViewCell: BaseTableCell, ConfigurableCell {
    
    // MARK: - Variables
    var viewModelItem: UserProfileEditViewModelItem!
    var changePhotoActionBlock: (() -> Void)?
    
    var isExpanded = false {
        didSet {
            switch viewModelItem.type {
            case .gender:
                pickerView.isHidden = !isExpanded
            case .birthday:
                datePicker.isHidden = !isExpanded
            default:
                break
            }
        }
    }
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    let padding: CGFloat = 20
    private let dimension: CGFloat = 100
    
    // MARK: - Views
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: .changePhotoAction)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        // MARK: When use with satackview
        let imageHeightConstraint = imageView.safeHeightAnchor.constraint(equalToConstant: dimension)
        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        imageHeightConstraint.isActive = true
        
        let imageWidthConstraint = imageView.safeWidthAnchor.constraint(equalToConstant: dimension)
        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        imageWidthConstraint.isActive = true
        
        // aspect ratio
        imageView.safeWidthAnchor.constraint(equalTo: imageView.safeHeightAnchor, multiplier: 1).isActive = true
        
        return imageView
    }()
    
    lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedConstants.Profile.ChangePhoto, for: .normal)
        button.addTarget(self, action: .changePhotoAction, for: .touchUpInside)
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.isEnabled = false
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.autocorrectionType = .no
//        textField.keyboardType = .numberPad
        
        textField.font = UIFont.systemFont(ofSize: 14)
        
        textField.addTarget(self, action: .textFieldDidChange, for: .editingChanged)
        
        return textField
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.addTarget(self, action: .datePickerChangeAction, for: .valueChanged)
        return datePicker
    }()
    
    override func setupViews() {
        super.setupViews()
        
        selectionStyle = .none
        
        let layoutMargin = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, profileImageView, changePhotoButton])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = padding
        
        let titleLabelWidthAnchor = titleLabel.safeWidthAnchor.constraint(equalToConstant: 5 * padding)
        titleLabelWidthAnchor.priority = UILayoutPriority(999)
        
        let cellStackView = UIStackView(arrangedSubviews: [stackView, pickerView, datePicker])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .leading
        cellStackView.distribution = .fill
        cellStackView.layoutMargins = layoutMargin
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            titleLabelWidthAnchor,
            
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
        
        pickerView.isHidden = true
        datePicker.isHidden = true
        profileImageView.isHidden = true
        changePhotoButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = false
        titleLabel.text = nil
        textField.text = nil
        textField.placeholder = nil
        textField.isUserInteractionEnabled = true
        
        selectionStyle = .default
        
        pickerView.isHidden = true
        datePicker.isHidden = true
        profileImageView.isHidden = true
        changePhotoButton.isHidden = true
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? UserProfileEditViewModelItem else { return }
        self.viewModelItem = viewModelItem
        
        titleLabel.text = viewModelItem.title
        textField.placeholder = viewModelItem.placeHolder
        textField.text = viewModelItem.text
        textField.isUserInteractionEnabled = viewModelItem.isSelectable
        
        selectionStyle = viewModelItem.isSelectable ? .none : .default
        
        switch viewModelItem.type {
        case .profileImage:
            imageViewConfigure()
        case .birthday:
            datePickerConfigure()
        case .gender:
            pickerViewConfigure()
        default:
            break
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        viewModelItem.text = textField.text ?? ""
    }
    
    @objc func datePickerValueChange(sender: UIDatePicker) {
        viewModelItem.text = dateFormatter.string(from: (sender.date))
        textField.text = viewModelItem.text
    }
    
    @objc func changePhoto() {
        changePhotoActionBlock?()
    }
    
    private func imageViewConfigure() {
        profileImageView.isHidden = false
        changePhotoButton.isHidden = false
        titleLabel.isHidden = true
        textField.isHidden = true
        
        guard let viewModelItem = viewModelItem as? UserProfileEditViewModelItemProfileImage, let profileImageUrl = viewModelItem.user.profilePictureUrl else { return }
        profileImageView.loadAndCacheImage(url: profileImageUrl)
    }
    
    private func datePickerConfigure() {
        datePicker.date = dateFormatter.date(from: viewModelItem.text) ?? datePickerFromNow(year: 10)
        datePicker.minimumDate = datePickerMinimumDate(year: 120)
        datePicker.maximumDate =  Date()
    }
    
    private func pickerViewConfigure() {
        
        let currentRow = GenderType.allCases.index(where: {$0.rawValue == viewModelItem.text}) ?? 0
        textField.text = GenderType.allCases[currentRow].toLocalized()
        pickerView.selectRow(currentRow, inComponent: 0, animated: true)
    }
    
    private func datePickerMinimumDate(year: Int) -> Date? {
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.day = 01
        components.month = 01
        components.year = -year
        return Calendar.current.date(byAdding: components, to: currentDate)
    }
    
    private func datePickerFromNow(year: Int) -> Date {
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -year
        return Calendar.current.date(byAdding: components, to: currentDate) ?? currentDate
    }
    
}


extension UserProfileEditViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenderType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GenderType.allCases[row].toLocalized()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModelItem.text = GenderType.allCases[row].rawValue
        textField.text = GenderType.allCases[row].toLocalized()
    }
    
}

fileprivate extension Selector {
    static let textFieldDidChange = #selector(UserProfileEditViewCell.textFieldDidChange)
    static let datePickerChangeAction = #selector(UserProfileEditViewCell.datePickerValueChange)
    static let changePhotoAction = #selector(UserProfileEditViewCell.changePhoto)
}

//fileprivate extension Selector {
//    static let changePhotoAction = #selector(UserProfileEditHeaderView.changePhoto)
//}
//
//class UserProfileEditHeaderView: BaseView {
//    
//    private let padding = Constants.Profile.Padding
//    private let dimension: CGFloat = 80
//    
//    lazy var profileImageView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.image = nil
//        imageView.layer.borderWidth = 0.5
//        imageView.layer.borderColor = UIColor.lightGray.cgColor
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//        imageView.clipsToBounds = true
//        
//        // MARK: When use with satackview
//        let imageHeightConstraint = imageView.safeHeightAnchor.constraint(equalToConstant: dimension)
//        imageHeightConstraint.priority = UILayoutPriority(rawValue: 999)
//        imageHeightConstraint.isActive = true
//        
//        let imageWidthConstraint = imageView.safeWidthAnchor.constraint(equalToConstant: dimension)
//        imageWidthConstraint.priority = UILayoutPriority(rawValue: 999)
//        imageWidthConstraint.isActive = true
//        
//        // aspect ratio
//        imageView.safeWidthAnchor.constraint(equalTo: imageView.safeHeightAnchor, multiplier: 1).isActive = true
//        
//        return imageView
//    }()
//    
//    lazy var changePhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle(LocalizedConstants.Profile.ChangePhoto, for: .normal)
//        button.addTarget(self, action: .changePhotoAction, for: .touchUpInside)
//        
//        return button
//    }()
//    
//    override func setupView() {
//        super.setupView()
//        
//        let layoutMargin = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
//        
//        let stackView = UIStackView(arrangedSubviews: [profileImageView, changePhotoButton])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        stackView.spacing = padding
//        stackView.layoutMargins = layoutMargin
//        stackView.isLayoutMarginsRelativeArrangement = true
//        
//        
//        addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.safeTopAnchor.constraint(equalTo: safeTopAnchor),
//            stackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor),
//            stackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor),
//            stackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
//            ])
//    }
//    
//    @objc func changePhoto() {
//        print("change photo")
//        
//    }
//    
//}
