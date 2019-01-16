//
//  Common.swift
//  catchu
//
//  Created by Erkut Baş on 12/2/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

class CommonTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        
        let temp = UITableView(frame: .zero, style: UITableViewStyle.plain)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.isScrollEnabled = true
        
        temp.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        temp.rowHeight = UITableViewAutomaticDimension
        temp.tableFooterView = UIView()
        
        temp.register(FriendRelationTableViewCell.self, forCellReuseIdentifier: FriendRelationTableViewCell.identifier)
        
        return temp
        
    }()
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
    var title : String { get set }
    var subTitle: String { get set }
    var active: Bool { get set }
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

