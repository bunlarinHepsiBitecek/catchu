//
//  Common.swift
//  catchu
//
//  Created by Erkut Baş on 12/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class CommonTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCellSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeCellSettings() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class CommonMoreOptionsTableCell: CommonTableCell {
    
    lazy var stackViewAdvancedSettings: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [title, subTitle])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let temp = UISwitch()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isOn = true
        return temp
    }()
    
}

class CommonSlideMenuTableCell: CommonTableCell {
    lazy var slideMenuLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        temp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return temp
    }()
    
    lazy var slideMenuImageView: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var slideMenuBadgeContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        temp.layer.cornerRadius = Constants.StaticViewSize.CorderRadius.cornerRadius_12
        return temp
    }()
    
    lazy var badgeLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.semibold)
        temp.contentMode = .center
        temp.textAlignment = .center
        temp.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return temp
    }()
    
}

class CommonCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class CommonPageItemCell: CommonCollectionCell {
    
    lazy var pageItemStackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: [pageTitle, pageSubTitle])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        return temp
    }()
    
    let pageTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            print("isHighlighted : \(isHighlighted)")
            pageTitle.textColor = isHighlighted ? UIColor.black : UIColor.lightGray
            pageSubTitle.textColor = isHighlighted ? UIColor.black : UIColor.lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            print("isSelected : \(isSelected)")
            pageTitle.textColor = isSelected ? UIColor.black : UIColor.lightGray
            pageSubTitle.textColor = isSelected ? UIColor.black : UIColor.lightGray
        }
    }
}

class CommonSectionHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewSettings()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViewSettings() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class CommonFollowView: UIView {
    lazy var tableView: UITableView = {
        
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        temp.rowHeight = UITableView.automaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(FriendRelationTableViewCell.self, forCellReuseIdentifier: FriendRelationTableViewCell.identifier)
        
        return temp
        
    }()
}

fileprivate extension Selector {
    static let confirm = #selector(CommonFollowTableViewCell.confirmButtonTapped(_:))
    static let delete = #selector(CommonFollowTableViewCell.deleteButtonTapped(_:))
}

class CommonFollowTableViewCell: CommonTableCell {
    
    lazy var userImageView: UIImageView = {
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.StaticViewSize.ViewSize.Width.width_50, height: Constants.StaticViewSize.ViewSize.Width.width_50))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = nil
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mainStackView: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [stackViewForUserInfo, stackViewForProcessButtons])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fillEqually
        
        return temp
    }()
    
    lazy var stackViewForUserInfo: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [name, username])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.alignment = .fill
        temp.axis = .vertical
        temp.distribution = .fillProportionally
        
        return temp
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "YArro "
        
        return label
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "KOKO"
        
        return label
    }()
    
    lazy var stackViewForProcessButtons: UIStackView = {
        
        let temp = UIStackView(arrangedSubviews: [followButton, moreButton])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.spacing = 5
        temp.alignment = .fill
        temp.axis = .horizontal
        temp.distribution = .fill
        
        return temp
    }()
    
    lazy var followButton: UIButton = {
        
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.addTarget(self, action: .confirm, for: UIControl.Event.touchUpInside)
        temp.setTitle("Follow", for: UIControl.State.normal)
        temp.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        temp.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
        temp.layer.cornerRadius = 5
        temp.layer.borderWidth = 0.5

        return temp
        
    }()
    
    lazy var moreButton: UIButton = {
        
        let temp = UIButton(type: UIButton.ButtonType.system)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.addTarget(self, action: .delete, for: UIControl.Event.touchUpInside)
        temp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let image = UIImage(named: "baseline_more_horiz_black_18pt")
        temp.setImage(image, for: UIControl.State.normal)
        temp.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return temp
        
    }()
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        
    }
    
    func configureCellSettings() {
        
    }
    
    func followButtonStatusUpdate() {
        
    }
    
}

// view model protocols
protocol CommonViewModel: class {
    
    //func handleAwsTaskResponse<AnyModel>(networkResult : ConnectionResult<AnyModel>)
    //func handleAwsTaskResponse<AnyModel>(networkResult : ConnectionResult<AnyModel>) where AnyModel : AnyObject
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>)
    func handleAwsTaskResponse<AnyModel>(networkResult: NetworkResult<AnyModel>)
    
}

extension CommonViewModel {
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {}
    func handleAwsTaskResponse<AnyModel>(networkResult: NetworkResult<AnyModel>) {}
}

protocol CommonViewModelItem {}

protocol CommonGroupViewModelItem {
    var type : GroupDetailSectionTypes { get }
    var sectionTitle : String { get }
    //var sectionNumber: Int { get set }
    var rowCount : Int { get }
    
}

protocol CommonMoreOptionsModelItem {
    var type : MoreOptionSectionTypes { get }
    var sectionTitle : String { get }
    var rowCount : Int { get }
    
    func postItemAdvancedSettingsManager()
    
}

protocol CommonSlideMenuTableCellViewModelItem {
    var type : SlideMenuViewTags { get }
    var cellTitle : String { get }
    var cellImage: UIImage { get }
    var rowCount : Int { get }
    
}

protocol PageItems {
    var title : String? { get set }
    var subTitle: String? { get set }
}

protocol CommonDesignableCellForGroupDetail {
    func initiateCellDesign(item: CommonGroupViewModelItem?)
}

protocol CommonDesignableCellForAdvancedCettings {
    func initiateCellDesign(item: CommonMoreOptionsModelItem?)
}

protocol CommonDesignableCellForSlideMenu {
    func initiateCellDesign(item: CommonSlideMenuTableCellViewModelItem?)
}

protocol CommonDesignableCell {
    func initiateCellDesign(item: CommonViewModelItem?)
}

protocol TakasiDenemeProtocol {
    
    func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
    
}

