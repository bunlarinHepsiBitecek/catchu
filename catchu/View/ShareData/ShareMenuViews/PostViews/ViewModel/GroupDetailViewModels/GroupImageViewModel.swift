//
//  GroupImageViewModel.swift
//  catchu
//
//  Created by Erkut Baş on 12/16/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class GroupImageViewModel: BaseViewModel, CommonViewModel {
    
    var group: Group?
    var groupImageProcessState = CommonDynamic(GroupImageProcess.start)
    
    func handleAwsTaskResponse<AnyModel>(networkResult: ConnectionResult<AnyModel>) {
        print("\(#function)")
    }
    
    
}
