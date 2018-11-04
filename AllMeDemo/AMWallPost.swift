//
//  AMWallPost.swift
//  AllMeDemo
//
//  Created by Daniil Pendikov on 01/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation
import ObjectMapper
import VK_ios_sdk

struct AMWallPostPhoto {
    var photo604: URL!
    var photo807: URL!
}

extension AMWallPostPhoto: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.photo604 <- (map["photo.photo_604"], URLTransform())
        self.photo807 <- (map["photo.photo_807"], URLTransform())
    }
}

struct AMWallPost {
    var text: String!
    var photos: [AMWallPostPhoto]!
}

extension AMWallPost: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.text <- map["text"]
        self.photos <- (map["attachments"], AMWallPostAttachmentsTransform())
    }
}

class AMWallPostAttachmentsTransform: TransformType {
    
    typealias JSON = [[String: Any]]
    typealias Object = [AMWallPostPhoto]
    
    func transformFromJSON(_ value: Any?) -> AMWallPostAttachmentsTransform.Object? {
        if let attachments = value as? [[String: Any]] {
            var resultAttachments = [AMWallPostPhoto]()
            for attachment in attachments {
                let type = attachment["type"] as? String ?? ""
                if type == "photo" {
                    if let photo = AMWallPostPhoto(JSON: attachment) {
                        resultAttachments.append(photo)
                    }
                }
            }
            return resultAttachments
        }
        return []
    }
    
    func transformToJSON(_ value: [AMWallPostPhoto]?) -> [[String : Any]]? {
        assertionFailure("transformToJSON is not implemented")
        return nil
    }
}
