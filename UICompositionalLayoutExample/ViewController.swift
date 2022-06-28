//
//  ViewController.swift
//  UICompositionalLayoutExample
//
//  Created by Simran Preet Narang on 2022-06-28.
//

import UIKit



class ViewController: UIViewController {

  enum Section {
    case main
  }
  
  var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
  var collectionView: UICollectionView! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureHierarchy()
    configureDataSource()
  }
  
  private func configureHierarchy() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
    view.addSubview(collectionView)
  }
  
  private func createLayout() -> UICollectionViewLayout {
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }

  private func configureDataSource() {
    
    // Create Diffable Data Source and connect to Collection View
    dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else {
        fatalError("Cannot create new cell")
      }
      
      cell.label.text = "\(itemIdentifier)"
      
      return cell
    })
    
    // initial data
    var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    snapshot.appendSections([.main])
    snapshot.appendItems(Array(0..<94))
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}




// MARK: - ListCell: UICollectionViewCell


class ListCell: UICollectionViewCell {
  static let reuseIdentifier = "\(ListCell.self)"
  
  let label = UILabel()
  let accessoryImageView = UIImageView()
  let seperatorView = UIView()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension ListCell {
  func configure() {
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.preferredFont(forTextStyle: .body)
    contentView.addSubview(label)
    
    seperatorView.translatesAutoresizingMaskIntoConstraints = false
    seperatorView.backgroundColor = .lightGray
    contentView.addSubview(seperatorView)
    
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = .lightGray.withAlphaComponent(0.3)
    
    let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
    let chevronImageName = rtl ? "chevron.left" : "chevron.right"
    let chevronImage = UIImage(systemName: chevronImageName)
    accessoryImageView.image = chevronImage
    accessoryImageView.tintColor = .lightGray.withAlphaComponent(0.7)
    accessoryImageView.translatesAutoresizingMaskIntoConstraints  = false
    contentView.addSubview(accessoryImageView)
    
    let inset = CGFloat(10)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
      
      accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      accessoryImageView.widthAnchor.constraint(equalToConstant: 13),
      accessoryImageView.heightAnchor.constraint(equalToConstant: 20),
      accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      
      
      seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
      seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      seperatorView.heightAnchor.constraint(equalToConstant: 0.5),
    ])
  }
}
