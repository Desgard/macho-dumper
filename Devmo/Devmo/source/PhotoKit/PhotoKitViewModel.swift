//
//  PhotoKitViewModel.swift
//  Devmo
//
//  Created by 段昊宇 on 2017/7/21.
//  Copyright © 2017年 Desgard_Duan. All rights reserved.
//

import UIKit
import Photos

class AblumModel {
    private(set) var title: String
    private(set) var fetchResult: PHFetchResult<PHAsset>
    
    init(title: String, fetchResult: PHFetchResult<PHAsset>) {
        self.title = title
        self.fetchResult = fetchResult
    }
    
    convenience init(item: AlbumItem) {
        self.init(title: item.title ?? "", fetchResult: item.fetchResult)
    }
    
}
