//
//  MovieViewModel.swift
//  StarWebTV
//
//  Created by Ahmed Abbas on 31/08/23.
//

import Foundation

class MovieViewModel {
    
    var currentPage = 1
    var hasMoreData = false
    
    var movieListCallBack: ((MovieListingResponse?) -> ())?
    var errorCallBack: ((Error?) -> ())?
    
    func loadMovieList() {
        print("LOADING.... CONTENTLISTINGPAGE-PAGE\(currentPage)")
        
        if let url = Bundle.main.url(forResource: "CONTENTLISTINGPAGE-PAGE\(currentPage)", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let items = try decoder.decode(MovieListingResponse.self, from: data)
                movieListCallBack?(items)
                hasMoreData = (items.page?.pageSize ?? 0) >= 20
            } catch {
                errorCallBack?(error)
                print("DEBUG: Error decoding JSON: \(error)")
            }
        } else {
            // Your json file not found in bundle
            errorCallBack?(nil)
            print("DEBUG: Json file not found")
        }

        
    }
}
