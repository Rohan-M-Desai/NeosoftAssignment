//
//  ViewController.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 08/04/25.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var floatingActionButton: UIButton!
    
    private var headerView: TableHeaderView!
    private var viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        viewModel.loadData()
        setupHeaderView()
        setupTableView()
        setupCarouselLayout()
        setupFloatingActionButton()
        headerView.carouselCollectionView.reloadData()
        tableView.reloadData()
        viewModel.onSectionsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupHeaderView() {
        headerView = TableHeaderView.loadFromNib()
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.searchBar.delegate = self
        headerView.carouselCollectionView.delegate = self
        headerView.carouselCollectionView.dataSource = self
        headerView.carouselCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        headerView.carouselCollectionView.isPagingEnabled = true
        headerView.carouselCollectionView.showsHorizontalScrollIndicator = false
        headerView.carouselCollectionView.contentInset = .zero
        headerView.carouselCollectionView.contentInsetAdjustmentBehavior = .never
        headerView.imagesPageControl.numberOfPages = viewModel.sections.count
        headerView.imagesPageControl.currentPage = 0
        headerView.imagesPageControl.currentPageIndicatorTintColor = .systemBlue
        headerView.imagesPageControl.pageIndicatorTintColor = .lightGray

        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        tableView.tableHeaderView = headerView
       
        headerView.searchBar.searchBarStyle = .minimal

    }
    
    func setupFloatingActionButton() {
        floatingActionButton.layer.cornerRadius = floatingActionButton.frame.height / 2
        floatingActionButton.backgroundColor = UIColor.systemBlue
        floatingActionButton.tintColor = .white
        floatingActionButton.layer.shadowColor = UIColor.black.cgColor
        floatingActionButton.layer.shadowOpacity = 0.3
        floatingActionButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        floatingActionButton.layer.shadowRadius = 6
        floatingActionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        floatingActionButton.imageView?.contentMode = .scaleAspectFit
        floatingActionButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    
    @IBAction func floatingActionButtonClicked(_ sender: Any) {
        let vc = ActionSheetViewController(nibName: "ActionSheetViewController", bundle: nil)
           // vc.items = viewModel.sections
        let selectedSectionItems = viewModel.sections[viewModel.selectedIndex].data
        vc.items = selectedSectionItems
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }

            present(vc, animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ListTableViewCell")
    }

    private func setupCarouselLayout() {
        if let layout = headerView.carouselCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
       
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listItemsForSelectedCarousel().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }

        let item = viewModel.listItemsForSelectedCarousel()[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let imageName = viewModel.sections[indexPath.item].imageName
        cell.configure(with: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - 20) , height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.item
        tableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterSections(with: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == headerView.carouselCollectionView else { return }

        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        headerView.imagesPageControl.currentPage = page
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == headerView.carouselCollectionView{
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            viewModel.selectedIndex = page
            tableView.reloadData()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == headerView.carouselCollectionView {
            if !decelerate {
                let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
                viewModel.selectedIndex = page
                tableView.reloadData()
            }
        }
    }
    
}
