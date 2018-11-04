//
//  AMWallPostCellNode.swift
//  AllMeDemo
//
//  Created by Daniil Pendikov on 02/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import AsyncDisplayKit

class AMWallPostCellNode: ASCellNode {
    
    private static let textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16),
        .foregroundColor: UIColor.black
    ]
    
    var textNode: ASTextNode!
    var imageNode: ASNetworkImageNode!
    
    convenience init(wallPost: AMWallPost) {
        self.init()
        
        let fixedText: String = wallPost.text.count < 50 ? wallPost.text :
            (wallPost.text.prefix(50) + "...")
        let text = NSAttributedString(string: fixedText,
                                      attributes: AMWallPostCellNode.textAttributes)
        
        self.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        self.textNode = ASTextNode()
        self.textNode.attributedText = text
        
        self.imageNode = ASNetworkImageNode()
        
        self.imageNode.backgroundColor = UIColor.darkGray
        self.imageNode.url = wallPost.photos?.first?.photo604
        
        self.addSubnode(self.textNode)
        self.addSubnode(self.imageNode)
        
        self.style.width = ASDimension(unit: .points, value: UIScreen.main.bounds.width)
        if self.imageNode.url != nil {
            self.imageNode.style.height = ASDimension(unit: .points, value: 100)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing: CGFloat = self.imageNode.url == nil ? 0 : 10
        let stack = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical,
                                      spacing: spacing,
                                      justifyContent: ASStackLayoutJustifyContent.center,
                                      alignItems: ASStackLayoutAlignItems.stretch,
                                      children: [self.textNode, self.imageNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: stack)
    }
    
}
