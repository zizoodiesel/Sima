//
//  MoviesTableViewController.swift
//  Sima
//
//  Created by Zizoo diesel on 10/4/2023.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var pending: UIAlertController = UIAlertController()
    var movies = [MovieItem]()
    var currentPage : Int = 1
    var totalPages : Int = 1
    var loadingMore : Bool = false

    func loadData(page: Int) {
                                             
        let feedProv = MoviesProvider()
        
        Task {
            
            
//            (movies, currentPage, totalPages) = try await feedProv.fetch(page: page)
            let response = try await feedProv.fetch(page: page)
            if response.currentPage == 1 {
                (movies, currentPage, totalPages) = response
            }
            else {
                movies = movies + response.movies
                currentPage = response.currentPage
                totalPages = response.totalPages
            }
            
            pending.dismiss(animated: true)
            tableView.reloadData()
            
            OperationQueue.main.addOperation { [self] in
                loadingMore = false
            }
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        pending = UIAlertController(title: "Loading", message: "\n\n\n\n", preferredStyle: .alert)

        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()

        self.present(pending, animated: true, completion: nil)
        
        
        loadData(page: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return currentPage == totalPages ? movies.count : movies.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if indexPath.row < movies.count {
            
            
            
            cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
            
            // Configure the cell...
            
            (cell as! MovieTableViewCell).idx = String(indexPath.row + 1)
            (cell as! MovieTableViewCell).title = movies[indexPath.row].title
            (cell as! MovieTableViewCell).score = String(movies[indexPath.row].vote_average)
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"

            if movies[indexPath.row].release_date != nil {
                (cell as! MovieTableViewCell).releaseDate = dateFormatter.date(from: movies[indexPath.row].release_date!)
            }
            
            if movies[indexPath.row].poster_path != nil {
                
                (cell as! MovieTableViewCell).cellImageView?.isHidden = false
                (cell as! MovieTableViewCell).cellImage = nil
                
                // This method is fetching and caching images if needed otherwise it returns an image from cache
                
                ImageCache.publicCache.load(url: NSURL(string: "https://image.tmdb.org/t/p/w500/" + movies[indexPath.row].poster_path!)!, indexPath: indexPath) { (fetchedIndex, image) in
                    
                    if let img = image {
                        
                        if let cachedCell = tableView.cellForRow(at: fetchedIndex!) as? MovieTableViewCell {
                            
                            cachedCell.cellImage = img
                            
                        }
                    }
                }
                
                
            }
            else {
                (cell as! MovieTableViewCell).cellImageView?.isHidden = true
                
            }
            
        }
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "loadMoreCell", for: indexPath) as! MovieTableViewCell
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "loadMoreCell" {

            if !loadingMore {

                OperationQueue.main.addOperation { [self] in
                    loadData(page: currentPage + 1)
                }

                loadingMore = true
            }
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            (segue.destination as! MovieDetailsViewController).movieItem = movies[selectedIndex.row]
        }
        
    }
    


}
