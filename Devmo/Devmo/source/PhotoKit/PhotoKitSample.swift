//
//  PhotoKitSample.swift
//  Devmo
//
//  Created by 段昊宇 on 2017/7/19.
//  Copyright © 2017年 Desgard_Duan. All rights reserved.
//

import UIKit
import Photos

class AlbumItem {
    // Album 名称
    public var title: String?
    // Album 内资源
    public var fetchResult: PHFetchResult<PHAsset>
    
    init(title: String?, fetchResult: PHFetchResult<PHAsset>) {
        self.title = title
        self.fetchResult = fetchResult
    }
}

class AlbumManager {
    static let shared = AlbumManager()
    
    var items: [AlbumItem] = []
    var assetsFetchResults: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager!
    
    public func getAlbumItems(callback: @escaping ([AlbumItem]) -> ()) {
        if items.count > 0 {
            callback(self.items)
            return
        }
        
        // 权限申请
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                return
            }
            
            // 列出所有系统相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            // 列出所有用户相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
            
            // 相册按照包含的照片数量排序（降序）
            self.items.sort { return $0.fetchResult.count > $1.fetchResult.count }
            
            DispatchQueue.main.async {
                callback(self.items)
            }
        }
    }
    
    public func getPhotosItems() {
        
    }
    
    
    // 转化处理获取到的 Album
    private func convertCollection(collection: PHFetchResult<PHAssetCollection>) {
        for i in 0 ..< collection.count {
            // 或去除当前 Album 的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType=%d", PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c, options: resultsOptions)
            
            // 没有图片的相册不显示
            if assetsFetchResult.count > 0 {
                let title = c.localizedTitle
                items.append(AlbumItem(title: title, fetchResult: assetsFetchResult))
            }
        }
    }
}

