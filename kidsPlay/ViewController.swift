//
//  ViewController.swift
//  kidsPlay
//
//  Created by JITENDRAAQ33 on 9/23/19.
//  Copyright © 2019 JITENDRA SOFTWARE(8961712201). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let collectionViewDragIdentifier = "CollectionViewDragCell"
    let collectionViewDropIdentifier = "CollectionViewDropCell"
    @IBOutlet weak var dragCollectionView: UICollectionView!
    @IBOutlet weak var dropCollectionView: UICollectionView!
    fileprivate var items: [String] = ["1","2","3"]
//    fileprivate let collctionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView( frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        return cv
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        dragCollectionView.delegate = self
        dropCollectionView.delegate = self
        
        dragCollectionView.dataSource  = self
        dropCollectionView.dataSource = self
        
        dragCollectionView.dragDelegate = self
        dropCollectionView.dropDelegate = self
        print("Swift5 Study")
        
        //hi


    }
    fileprivate func reorderItems(coordinater: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
        if let item = coordinater.items.first, let sourceIndexPath = item.sourceIndexPath{
            collectionView.performBatchUpdates({
                self.items.remove(at: sourceIndexPath.item)
                self.items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
            }, completion: nil)
            coordinater.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }

}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dragCollectionView {
            return items.count
        }else{
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.dragCollectionView {
            let  dragCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewDragIdentifier, for: indexPath) as! DragCollectionViewCell
            // Set up cell
            dragCell.dragNumberLabel.text = items[indexPath.row]
            return dragCell
        }

        else {
            let dropCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewDropIdentifier, for: indexPath) as! DropCollectionViewCell
            // ...Set up cell
            dropCell.dropNumnerLabel.text = items[indexPath.row]

            return dropCell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.dragCollectionView {
//            return CGSize(width: 50, height: 50)
//        }else{
//            return CGSize(width: 60, height: 60)
//        }
//    }
    
}

extension ViewController:UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
}

extension ViewController: UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if  let indexpath = coordinator.destinationIndexPath {
            destinationIndexPath = indexpath
        }else{
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinater : coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
}
