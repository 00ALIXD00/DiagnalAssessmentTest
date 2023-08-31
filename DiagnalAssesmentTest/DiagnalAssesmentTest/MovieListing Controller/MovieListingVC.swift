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
    
    //MARK: - Properties
    var currentPage = 1
    var hasMoreData = false
    
    var movieItems: [Content]? {
        didSet {
            DispatchQueue.main.async {
                self.cvMovieListing.reloadData()
            }
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: - Actions
    @IBAction func btnBackTap(_ sender: UIButton) {
        // If there was a navigation, write pop controller code
    }
    
    @IBAction func btnSearchTap(_ sender: UIButton) {
        // Search screen navigation here
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
        
        // Load Json data
        loadJsonData()
    }
    
}

//MARK: - APIs
extension MovieListingVC {
    
    func loadJsonData() {
        print("LOADING.... CONTENTLISTINGPAGE-PAGE\(currentPage)")
        if let url = Bundle.main.url(forResource: "CONTENTLISTINGPAGE-PAGE\(currentPage)", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let items = try decoder.decode(MovieListingResponse.self, from: data)
                if let _ = movieItems {
                    self.movieItems?.append(contentsOf: items.page?.contentItems?.content ?? [])
                } else {
                    self.movieItems = items.page?.contentItems?.content
                }
                lblTitle.text = items.page?.title
                hasMoreData = (items.page?.pageSize ?? 0) >= 20
            } catch {
                print("DEBUG: Error decoding JSON: \(error)")
            }
        } else {
            // Your json file not found in bundle
            print("DEBUG: Json file not found ")
        }
    }
}

//MARK: - Collections view delegate and data source
extension MovieListingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = (movieItems?.count ?? 0) - 1
        if indexPath.row == lastItem {
            if self.hasMoreData {
                // If api has more data, increment page count and load more data
                currentPage += 1
                loadJsonData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellID, for: indexPath) as? MovieCell ?? MovieCell()
        
        cell.movieData = movieItems?[indexPath.row]
        
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
