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

class CommonMoreOptionsTableCell: UITableViewCell {
    
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

class CommonCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
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

protocol CommonDesignableCellForGroupDetail {
    func initiateCellDesign(item: CommonGroupViewModelItem?)
}

protocol CommonDesignableCellForAdvancedCettings {
    func initiateCellDesign(item: CommonMoreOptionsModelItem?)
}

protocol CommonDesignableCell {
    func initiateCellDesign(item: CommonViewModelItem?)
}

protocol TakasiDenemeProtocol {
    
    func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
    
}

