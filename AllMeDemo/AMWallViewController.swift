//
//  ViewController.swift
//  AllMeDemo
//
//  Created by Daniil Pendikov on 01/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift
import MBProgressHUD

class AMWallViewController: ASViewController<ASCollectionNode> {
    
    private var disposeBag: DisposeBag! = DisposeBag()
    private var viewModel: AMWallViewModel!
    private var sections: [[AMWallPost]] = []
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        let node = ASCollectionNode(collectionViewLayout: layout)
        self.init(node: node)
        self.navigationItem.title = "All.me"
        node.dataSource = self
        node.delegate = self
        node.batchFetchingDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel = AMWallViewModel(api: AMVKAPI())
        self.viewModel.wallPosts.subscribe(onNext: { (posts) in
            self.sections.append(posts)
            self.node.insertSections(IndexSet(arrayLiteral: self.sections.count - 1))
            MBProgressHUD.hide(for: self.view, animated: true)
        }).disposed(by: self.disposeBag)
    }
}

extension AMWallViewController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return self.sections.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let post = self.sections[indexPath.section][indexPath.row]
        return {
            return AMWallPostCellNode(wallPost: post)
        }
    }
}

extension AMWallViewController: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        context.beginBatchFetching()
        self.viewModel.wallPosts.take(1).subscribe(onNext: { (_) in
            context.completeBatchFetching(true)
        }).disposed(by: self.disposeBag)
        self.viewModel.currentOffset.onNext(collectionNode.numberOfSections * AMWallViewModel.pageSize)
    }
}

extension AMWallViewController: ASBatchFetchingDelegate {
    func shouldFetchBatch(withRemainingTime remainingTime: TimeInterval, hint: Bool) -> Bool {
        return hint
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }
}
