//
//  MovieDetailsViewController.swift
//  Sima
//
//  Created by Zizoo diesel on 11/4/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    
    @IBOutlet private weak var backdropImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView?
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    var movieItem: MovieItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = movieItem.title
        titleLabel.text = movieItem.title
        
        
        
        if movieItem.overview != nil {
            descriptionLabel.text = movieItem.overview!
        }
        else {
            descriptionLabel.text = ""
        }
        
        scoreLabel.text = String(movieItem.vote_average)

        if movieItem.release_date != nil {
            
            let dateFormatter1: DateFormatter = DateFormatter()
            dateFormatter1.dateFormat = "YYYY-MM-DD"
            
            var date : Date! = dateFormatter1.date(from: movieItem.release_date!)
            
            
            let dateFormatter2: DateFormatter = DateFormatter()
            dateFormatter2.dateStyle = .long
            dateFormatter2.timeStyle = .none
            
            releaseDateLabel.text = dateFormatter2.string(from: date)
        }
        else {
            releaseDateLabel.text = "Coming soon"
        }
        
        if movieItem.backdrop_path != nil {

            let fromAnim : CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
            fromAnim.fromValue = 0.2
            fromAnim.toValue = 1.2


            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.6
            animationGroup.repeatCount = .infinity
            animationGroup.autoreverses = true
            animationGroup.isRemovedOnCompletion = false

            animationGroup.animations = [fromAnim]

            backdropImageView?.layer.add(animationGroup, forKey: "fadeAnimation")
            backdropImageView?.backgroundColor = UIColor.systemGray4
            
            ImageCache.publicCache.load(url: NSURL(string: "https://image.tmdb.org/t/p/original/" + movieItem.backdrop_path!)!, indexPath: nil) { (fetchedCell ,image) in
               
                if let img = image {
                    
                    
                    self.backdropImageView?.image = img

                    self.backdropImageView?.layer.removeAnimation(forKey: "fadeAnimation")
                    
                    self.backdropImageView?.backgroundColor = UIColor.clear
                    

                    

                }
            }

        
        }
        else {
            backdropImageView?.removeFromSuperview()
        }
        
        if movieItem.poster_path != nil {

            let fromAnim : CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
            fromAnim.fromValue = 0.2
            fromAnim.toValue = 1.2


            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.6
            animationGroup.repeatCount = .infinity
            animationGroup.autoreverses = true
            animationGroup.isRemovedOnCompletion = false

            animationGroup.animations = [fromAnim]

            posterImageView?.layer.add(animationGroup, forKey: "fadeAnimation")
            posterImageView?.backgroundColor = UIColor.systemGray4
            
            ImageCache.publicCache.load(url: NSURL(string: "https://image.tmdb.org/t/p/original/" + movieItem.poster_path!)!, indexPath: nil) { (fetchedCell ,image) in
               
                if let img = image {
                    
                    
                    self.posterImageView?.image = img

                    self.posterImageView?.layer.removeAnimation(forKey: "fadeAnimation")
                    
                    self.posterImageView?.backgroundColor = UIColor.clear
                    

                    

                }
            }

        
        }
        else {
            posterImageView?.removeFromSuperview()
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
