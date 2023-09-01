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
    @IBOutlet weak var lblMovieName: MarqueeLabel!
    
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
            
            if lblMovieName.intrinsicContentSize.width > lblMovieName.frame.width {
                lblMovieName.startMarqueeAnimation()
//                startMarqueeAnimation()
            } else {
                lblMovieName.stopMarqueeAnimation()
            }
        }
    }
    
    //MARK: - Awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMoviePoster.layer.cornerRadius = 2 // giving slight corner radius for better looks
    }
    
    func startMarqueeAnimation() {
        let animationDuration: TimeInterval = 10.0
        let marqueeWidth = contentView.frame.size.width + lblMovieName.frame.size.width

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveLinear, animations: {
            self.lblMovieName.frame.origin.x = -self.lblMovieName.frame.size.width
        }) { _ in
            self.lblMovieName.frame.origin.x = self.contentView.frame.size.width
            self.startMarqueeAnimation()
        }
    }
}
