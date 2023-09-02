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
    @IBOutlet weak var vwLoading: UIView!
    
    //MARK: - Properties
    var viewModel = MovieViewModel()
    var isSearching: Bool = false
    var filteredMovies: [Content] = [] // Filtered movies based on search
    var allMovies: [Content]? {  // All movie list from json response
        didSet {
            self.cvMovieListing.reloadData()
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        observeDataCallbackFromViewModel() // This will observe view models events
        setupUI() // set initial user interface and delegates
    }
    
    // This method will call when user switch orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // This will reset flow layout and reload collection view
        cvMovieListing.collectionViewLayout.invalidateLayout()
        cvMovieListing.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func btnBackTap(_ sender: UIButton) {
        // If there was a navigation, write pop controller code
    }
    
    @IBAction func btnSearchTap(_ sender: UIButton) {
        // Show search bar and hide search button
        if sender.isSelected {
            searching(isStart: false) // Searching stops
        } else {
            searching(isStart: true) // Searching starts
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // It will call loadMovieList function after 2.0 seconds delay so user can see data is being fetched
            self.viewModel.loadMovieList()
        }
    }
    
    func searching(isStart: Bool) {

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: {
            self.btnBack.alpha = isStart ? 0.0 : 1.0
            self.btnBack.isHidden = isStart
            self.lblTitle.alpha = isStart ? 0.0 : 1.0
            self.lblTitle.isHidden = isStart
            self.txtSearch.isHidden = !isStart
            self.btnSearch.isSelected = isStart
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        isStart ? txtSearch.becomeFirstResponder() : txtSearch.resignFirstResponder()
        isSearching = isStart
        isSearching ? Void() : cvMovieListing.reloadCollectionWithAnimation()
        txtSearch.text = ""
        cvMovieListing.setEmptyMessage("")
    }
    
}

//MARK: - APIs
extension MovieListingVC {
    
    func observeDataCallbackFromViewModel() {
        
        // When you get data from api, view model would let you know and give call back and send data, so you can update User interface
        viewModel.movieListCallBack = { [weak self] items in
            guard let self else { return }
            vwLoading.isHidden = true
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
            vwLoading.isHidden = true
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
                // I am giving 1.5 second delay so we can observe data is being load from json file, if i don't do this it will load data instantly from bundle
                vwLoading.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    // If api has more data, increment page count and load more data
                    self.viewModel.currentPage += 1
                    self.viewModel.loadMovieList()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count // this is search result items count
        } else {
            if let allMovies {
                return allMovies.count // when we get dat from api, return data count
            } else {
                return 12 // if api is calling and fetching data from server, we should show skeleton loading
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellID, for: indexPath) as? MovieCell ?? MovieCell()
        
        if isSearching {
            cell.movieData = filteredMovies[indexPath.row]
        } else {
            if let allMovies { // it will give us all movies, so we can show list of movies
                cell.movieData = allMovies[indexPath.row]
                cell.stopCollSkeleton()
            } else { // if we get no movies that means api is calling so we should show skeleton loading until data fetching finishes
                cell.startCollSkeleton()
            }
        }
        return cell
    }
    
}

//MARK: - Collection view flow layout delegate  NOTE:- We can achieve spacing in between cell using storyboard too, but i prefer to do it this way as this is easy for other developer to understand directly from ViewController class without going in to storyboard
extension MovieListingVC: UICollectionViewDelegateFlowLayout {
    
    // Size for Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 0.0
        if UIDevice.current.orientation.isLandscape { // check if the device orientation is portrait or landscape?
            width = (view.layer.frame.size.width - 112) / 6
        } else {
            width = (view.layer.frame.size.width - 64) / 3
        }
        
        let height = width + (width / 1.2)
        return CGSize(width: width, height: height)
    }
    
    // Section spacing around whole collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 40, left: 16, bottom: 26, right: 16)
    }
    
    // Spacing in between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
    // Spacing in between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

//MARK: - Search bar delegate
extension MovieListingVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 || searchText.isEmpty {
            filteredMovies = allMovies?.filter( {$0.name?.localizedCaseInsensitiveContains(searchText) ?? Bool()} ) ?? []
            
            if !(filteredMovies.count > 0) && !searchText.isEmpty {
                cvMovieListing.setEmptyMessage("We found nothing named \"\(txtSearch.text ?? "")\", \nPlease try again with different movie name.", image: "no-results") // This is no data view if user type something that is not in out collection
            } else {
                cvMovieListing.setEmptyMessage("") // pass empty string if there is data to show
            }
            
            cvMovieListing.performBatchUpdates({
                cvMovieListing.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
    }
}
