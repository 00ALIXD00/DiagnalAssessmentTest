//
//  MovieCell.swift
//  DiagnalAssesmentTest
//
//  Created by Ahmed Abbas on 31/08/23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    //MARK: - Cell ID
    static let cellID = "MovieCell"
    
    //MARK: - Outlets
    @IBOutlet weak var imgMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieName: UILabel!
    
    //MARK: - Properties
    var movieData: Content? {
        didSet {
            lblMovieName.text = movieData?.name
            
            if let posterImage = UIImage(named: movieData?.posterImage ?? "") {
                // Image exists
                imgMoviePoster.image = posterImage
            } else {
                // Image does not exist, Handle the case where the image is missing
                imgMoviePoster.image = UIImage(named: "placeholder_for_missing_posters")
            }
            
            // Check if label is truncated
            if lblMovieName.isTruncated {
                // Start marquee animation if label is truncated
                lblMovieName.startMarqueeAnimation()
            } else {
                // Stop marquee animation if label is not truncated
                lblMovieName.stopMarqueeAnimation()
            }
        }
    }
    
    //MARK: - Awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMoviePoster.layer.cornerRadius = 2 // giving slight corner radius for better looks
    }
}
