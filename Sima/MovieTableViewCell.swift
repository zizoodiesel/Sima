//
//  MovieTableViewCell.swift
//  Sima
//
//  Created by Zizoo diesel on 10/4/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView?
    var animationGroup: CAAnimationGroup?

    
    var idx: String? {
        
        set {

            indexLabel.text = newValue
        }
        get {
            return indexLabel.text ?? ""
        }
    }
    
    var title: String? {
        
        set {

            titleLabel.text = newValue
        }
        get {
            return titleLabel.text ?? ""
        }
    }
    
    var score: String? {

        set {

            scoreLabel.text = newValue
        }
        get {
            return scoreLabel.text ?? ""
        }
    }
    
    var releaseDate: Date? {

        set {

            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none

            dateLabel.text = dateFormatter.string(from: newValue!)

        }
        get {
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short

            return dateFormatter.date(from: dateLabel?.text ?? "Coming soon")
        }
    }

    var cellImage: UIImage? {

        set {
            
            cellImageView?.image = newValue
            cellImageView?.contentMode = UIView.ContentMode.scaleAspectFit
            
            if newValue != nil {
                cellImageView?.layer.removeAnimation(forKey: "fadeAnimation")
                cellImageView?.backgroundColor = UIColor.clear
            }
            else {
                
                let fromAnim : CABasicAnimation = CABasicAnimation.init(keyPath: "opacity")
                fromAnim.fromValue = 0.2
                fromAnim.toValue = 1.2


                
                animationGroup = CAAnimationGroup()
                animationGroup!.duration = 0.6
                animationGroup!.repeatCount = .infinity
                animationGroup!.autoreverses = true
                animationGroup!.isRemovedOnCompletion = false

                animationGroup!.animations = [fromAnim]
                

                cellImageView?.layer.add(animationGroup!, forKey: "fadeAnimation")
                
                cellImageView?.backgroundColor = UIColor.systemGray4
            }
            
            
        }
        get {
            return cellImageView?.image
        }
    }
    
}
