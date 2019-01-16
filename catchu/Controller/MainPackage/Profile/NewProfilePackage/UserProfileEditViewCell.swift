//
//  UserProfileEditViewCell.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 12/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class UserProfileEditViewCell: BaseTableCell, ConfigurableCell {
    
    var viewModel: UserProfileEditViewModelItem!
    
    var isExpanded = false {
        didSet {
            switch viewModel.type {
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
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
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
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.alignment = .leading
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = false
        titleLabel.text = nil
        textField.text = nil
        textField.placeholder = nil
        textField.isUserInteractionEnabled = true
        
        selectionStyle = .default
        
        pickerView.isHidden = !isExpanded
        datePicker.isHidden = !isExpanded
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModel = viewModelItem as? UserProfileEditViewModelItem else { return }
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        textField.placeholder = viewModel.placeHolder
        textField.text = viewModel.text
        textField.isUserInteractionEnabled = viewModel.isSelectable
        
        selectionStyle = viewModel.isSelectable ? .none : .default
        
        switch viewModel.type {
        case .birthday:
            datePickerConfigure()
        case .gender:
            pickerViewConfigure()
        default:
            break
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        viewModel.text = textField.text ?? ""
    }
    
    @objc func datePickerValueChange(sender: UIDatePicker) {
        viewModel.text = dateFormatter.string(from: (sender.date))
        textField.text = viewModel.text
    }
    
    private func datePickerConfigure() {
        datePicker.date = dateFormatter.date(from: viewModel.text) ?? datePickerFromNow(year: 10)
        datePicker.minimumDate = datePickerMinimumDate(year: 120)
        datePicker.maximumDate =  Date()
    }
    
    private func pickerViewConfigure() {
        
        let currentRow = GenderType.allCases.index(where: {$0.rawValue == viewModel.text}) ?? 0
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
        viewModel.text = GenderType.allCases[row].rawValue
        textField.text = GenderType.allCases[row].toLocalized()
    }
    
}

fileprivate extension Selector {
    static let textFieldDidChange = #selector(UserProfileEditViewCell.textFieldDidChange)
    static let datePickerChangeAction = #selector(UserProfileEditViewCell.datePickerValueChange)
}
