//
//  MovieListingVC.swift
//  DiagnalAssesmentTest
//
//  Created by Ahmed Abbas on 31/08/23.
//

import UIKit

class MovieListingVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var cvMovieListing: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtSearch: UISearchBar!
    
    //MARK: - Properties
    var viewModel = MovieViewModel()
    var isSearching: Bool = false
    var filteredMovies: [Content] = [] // Filtered movies based on search
    var allMovies: [Content]?  // Your json response movie list
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        observeDataCallbackFromViewModel() // This will observe view models events
        setupUI() // set initial user interface and delegates
    }
    
    //MARK: - Actions
    @IBAction func btnBackTap(_ sender: UIButton) {
        // If there was a navigation, write pop controller code
    }
    
    @IBAction func btnSearchTap(_ sender: UIButton) {
        // Show search bar and hide search button
        if sender.isSelected {
            searchBar(makeItVisible: false)
        } else {
            searchBar(makeItVisible: true)
        }
    }
    
}

//MARK: - Setup user interface
extension MovieListingVC {
    
    private func setupUI() {
        // Assign collection view's delegate to self
        cvMovieListing.delegate = self
        cvMovieListing.dataSource = self
        // Register Xib file with collection view
        cvMovieListing.register(UINib(nibName: MovieCell.cellID, bundle: nil), forCellWithReuseIdentifier: MovieCell.cellID)
        
        // Search Delegate assign to self
        txtSearch.delegate = self
        
        // Load Json data
        viewModel.loadMovieList()
    }
    
    func searchBar(makeItVisible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.lblTitle.isHidden = makeItVisible
            self.btnBack.isHidden = makeItVisible
            self.txtSearch.isHidden = !makeItVisible
            self.btnSearch.isSelected = makeItVisible
            self.view.layoutIfNeeded()
        }
        makeItVisible ? txtSearch.becomeFirstResponder() : txtSearch.resignFirstResponder()
        isSearching = makeItVisible
        isSearching ? Void() : cvMovieListing.reloadData()
        txtSearch.text = ""
        
    }
    
}

//MARK: - APIs
extension MovieListingVC {
    
    func observeDataCallbackFromViewModel() {
        
        // When you get data from api, view model would let you know and give call back and send data, so you can update User interface
        viewModel.movieListCallBack = { [weak self] items in
            guard let self else { return }
            
            if let _ = allMovies {
                self.allMovies?.append(contentsOf: items?.page?.contentItems?.content ?? [])
            } else {
                self.allMovies = items?.page?.contentItems?.content
            }
            lblTitle.text = items?.page?.title
        }
        
        viewModel.errorCallBack = { [weak self] error in
            guard let self else { return }
            
            // we should not show such messages to user, i am just showing these toast messages for your understanding and for sake of error handling, we should rather show user appropriate error messages.
            if let error { // Decode fail
                self.showToast(message: "Json decode fail with errors \(error.localizedDescription)")
            } else { // Json file not found
                self.showToast(message: "Json file not found.")
            }
        }
        
    }
}

//MARK: - Collections view delegate and data source
extension MovieListingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isSearching {
            return // if user is searching, return from here no need to execute below code
        }
        let lastItem = (allMovies?.count ?? 0) - 1
        if indexPath.row == lastItem {
            if viewModel.hasMoreData {
                // If api has more data, increment page count and load more data
                viewModel.currentPage += 1
                viewModel.loadMovieList()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredMovies.count : allMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellID, for: indexPath) as? MovieCell ?? MovieCell()
        
        cell.movieData = isSearching ? filteredMovies[indexPath.row] : allMovies?[indexPath.row]
        
        return cell
    }
    
}

//MARK: - Collection view flow layout delegate  NOTE:- We can achieve spacing in between cell using storyboard too, but i prefer to do it this way as this is easy for other developer to understand directly from ViewController class without going in to storyboard
extension MovieListingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.layer.frame.size.width - 64) / 3
        let height = width + (width / 1.2)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 40, left: 16, bottom: 26, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

//MARK: - Search bar delegate
extension MovieListingVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 || searchText.isEmpty {
            filteredMovies = allMovies?.filter( {$0.name?.localizedCaseInsensitiveContains(searchText) ?? Bool()} ) ?? []
            
            cvMovieListing.performBatchUpdates({
                cvMovieListing.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
    }
}
