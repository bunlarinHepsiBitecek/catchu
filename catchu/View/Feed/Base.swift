//
//  Base.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 10/11/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

// MARK: - ViewController
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Receive memory warning from \(String(describing: self))")
    }
    
    func setupViews() {
        
    }
}

class BaseTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Receive memory warning from \(String(describing: self))")
    }
    
    func setupViews() {
        
    }
}

class BaseCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Receive memory warning from \(String(describing: self))")
    }
    
    func setupViews() {
        
    }
}

// MARK: - Views
class BaseCollectionReusableView: UICollectionReusableView {
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

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
}

class BaseViewModel: NSObject {
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        
    }
}


protocol ViewModel {}
protocol ViewModelItem {}

protocol SectionViewModel {
    var headerTitle: String? { get }
    var rowViewModels: [ViewModelItem] { set get }
}


protocol ConfigurableController {
    func configure(viewModel: ViewModel)
}

protocol ConfigurableCell {
    func configure(viewModelItem: ViewModelItem)
}

//protocol ReusableCell {
//    static var reuseIdentifier: String { get }
//}
//
//extension ReusableCell {
//    static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}
//
//protocol ConfigurableItem: ReusableCell {
//    func configure(cell: UITableViewCell)
//}
//
//protocol ConfigurableCell {
//    associatedtype T
//    var item: T? { get set }
//    func configure(item: T)
//}
//
//class TableCellConfigurator<CellType: ConfigurableCell & UITableViewCell, T>: ConfigurableItem where CellType.T == T {
//
//    let item: T
//
//    init(item: T) {
//        self.item = item
//    }
//
//    func configure(cell: UITableViewCell) {
//        (cell as! CellType).configure(item: item)
//    }
//}



class BaseTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class BaseTableCellRightDetail: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}


//extension BaseTableCell {
//
//    /** Gets the owner tableView of the cell */
//    var tableView: UITableView? {
//        var view = self.superview
//        while (view != nil && view!.isKind(of: UITableView.self) == false) {
//            view = view!.superview
//        }
//        return view as? UITableView
//    }
//}

class BaseCollectionCell: UICollectionViewCell {
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
