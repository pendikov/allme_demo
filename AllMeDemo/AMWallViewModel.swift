//
//  AMWallViewModel.swift
//  AllMeDemo
//
//  Created by Daniil Pendikov on 02/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation
import VK_ios_sdk
import ObjectMapper
import RxSwift

class AMWallViewModel {
    static let pageSize: Int = 20
    static let textMaxLength: Int = 50
    
    var currentOffset = BehaviorSubject<Int>(value: 0)
    var wallPosts: Observable<[AMWallPost]>!
    
    init(api: AMVKAPIProtocol) {
        self.wallPosts = self.currentOffset
            .distinctUntilChanged()
            .flatMap { (offset) -> Observable<[AMWallPost]> in
                return api.getWall(offset: offset, count: AMWallViewModel.pageSize)
            }
    }
    
}
