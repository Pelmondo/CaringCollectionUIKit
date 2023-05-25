//
//  ViewController.swift
//  СaringСollectionUIKit
//
//  Created by Сергей Прокопьев on 25.05.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    enum Section {
        case main
    }

    private lazy var collection: UICollectionView = {
        var layout = CastomFlouLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()

    var dataSource: UICollectionViewDiffableDataSource<Section, String>!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collection)

        collection.decelerationRate = .fast

        dataSource = UICollectionViewDiffableDataSource(collectionView: collection) { (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.layer.cornerRadius = 10
            cell.accessibilityIdentifier = item
            cell.backgroundColor = .systemGray6
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collection.frame = view.frame
        let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.sectionInset = UIEdgeInsets(top: 100, left: view.layoutMargins.left, bottom: 0, right: 0)
    }
}

class CastomFlouLayout: UICollectionViewFlowLayout {
    private let cellWidth = 250.0

    var itemsCount: CGFloat {
        CGFloat(collectionView?.numberOfItems(inSection: 0) ?? 0)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func prepare() {
        super.prepare()

        itemSize = CGSize(width: cellWidth, height: 400)
        scrollDirection = .horizontal
        minimumLineSpacing = 8
        minimumInteritemSpacing = 0
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collection = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }
        let cellWithSpacing = itemSize.width + 8
        let relative = (proposedContentOffset.x + collection.contentInset.left) / cellWithSpacing
        let leftIndex = max(0, floor(relative))
        let rightIndex = min(ceil(relative), itemsCount)
        let leftCenter = leftIndex * cellWithSpacing - collection.contentInset.left
        let rightCenter = rightIndex * cellWithSpacing - collection.contentInset.left

        if abs(leftCenter - proposedContentOffset.x) < abs(rightCenter - proposedContentOffset.x) {
            return CGPoint(x: leftCenter, y: proposedContentOffset.y)
        } else {
            return CGPoint(x: rightCenter, y: proposedContentOffset.y)
        }
    }
}


