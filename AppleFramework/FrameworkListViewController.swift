//
//  FrameworkListViewController.swift
//  AppleFramework
//
//  Created by joonwon lee on 2022/04/24.
//

import UIKit

class FrameworkListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let list: [AppleFramework] = AppleFramework.list
    
//    var dataSource: UICollectionViewDiffableDataSource<Section, AppleFramework>!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    typealias Item = AppleFramework // Item으로 쓰기 위해 typealias를 사용함.
    
    enum Section {
        case main
    }
    
    // 기존 //
    // [section [item]] [section [item]] [section [item]] // 섹션에 대한 구분타입, 아이템에 대한 타입을 정해줘야함.
    
    
    // Diffable //
    // group = [item]
    // section = [group]
    // layout = [section]
    
    
    // Data, Presentation, Layout
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        navigationController?.navigationBar.topItem?.title = "☀️ Apple Frameworks"
        
        // Presentation, Data, Layout -- 새로운 방법으로 사용
        //        diffalble datasource
        //        - presentation
                
        //        snapshot
        //        - Data
                
        //        compositional Layout
        //        - layout
        
        // datasource //
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCell", for: indexPath) as? FrameworkCell else {
                return nil
            }
//            let data = dataList[indexPath.item]
//            let data = item // 위와 동일
            cell.configure(item)
            return cell
        }) 
        
        // Data //
         var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource?.apply(snapshot)
        
        // Layout //
        collectionView.collectionViewLayout = layout()
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        // fractionalWidth(0.33) : 그룹 너비의 1/3,
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // heightDimension: .fractionalWidth(0.33) : 그룹의 높이를 너비의 1/3로 써라.
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3) // 1 2 3 //
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension FrameworkListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let framework = list[indexPath.item]
        print(">>> selected: \(framework.name)")
    }
}
