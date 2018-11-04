//
//  AMVKAPI.swift
//  AllMeDemo
//
//  Created by Daniil Pendikov on 02/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import RxSwift
import VK_ios_sdk
import ObjectMapper

protocol AMVKAPIProtocol {
    func getWall(offset: Int, count: Int) -> Observable<[AMWallPost]>
}

class AMVKAPI: AMVKAPIProtocol {
    
    func getWall(offset: Int, count: Int) -> Observable<[AMWallPost]> {
        return Observable<[AMWallPost]>.create({ (observer) -> Disposable in
            let req = VKRequest(method: "wall.get",
                                parameters: [VK_API_OWNER_ID: AMConfig.VK.groupId,
                                             VK_API_ACCESS_TOKEN: AMConfig.VK.accessToken,
                                             VK_API_COUNT: count,
                                             VK_API_OFFSET: offset])
            let error1 = NSError(domain: "alllme", code: 1, userInfo: nil) as Error
            let error2 = NSError(domain: "alllme", code: 2, userInfo: nil) as Error
            req?.execute(resultBlock: { (response) in
                guard let json = response?.json as? [String: Any],
                    let posts = Mapper<AMWallPost>().mapArray(JSONObject: json["items"]) else {
                        observer.onError(error1)
                        return
                }
                observer.onNext(posts)
                observer.onCompleted()
            }, errorBlock: { (_) in
                observer.onError(error2)
            })
            return Disposables.create()
        })
    }
    
    
}
