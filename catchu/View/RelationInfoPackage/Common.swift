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

// view model protocols
protocol CommonViewModel {
    
    //func handleAwsTaskResponse<AnyModel>(networkResult : ConnectionResult<AnyModel>)
    //func handleAwsTaskResponse<AnyModel>(networkResult : ConnectionResult<AnyModel>) where AnyModel : AnyObject
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>)
    
}

protocol CommonViewModelItem {}

protocol CommonDesignableCell {
    func initiateCellDesign(item: CommonViewModelItem?)
}

protocol TakasiDenemeProtocol {
    
    func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
    
}

