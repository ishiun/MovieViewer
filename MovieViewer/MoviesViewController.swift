//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by I-Shiun Kuo on 2/1/16.
//  Copyright © 2016 I-Shiun Kuo. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
extension MoviesViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        }else {
            return 0
        }
    }}
class MoviesViewController: UIViewController{
    
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.dataSource = self
 
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        //
        
        //
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                self.collectionView.reloadData()
                
                refreshControl.endRefreshing()
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            print("response: \(responseDictionary)")
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.collectionView.reloadData()
                    }
                }
                if let data = error{
                        self.collectionView.hidden = true
                    }
        })
        task.resume()
        // Do any additional setup after loading the view.
        
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        //
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        //
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                self.collectionView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }
    
    //
       func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCells", forIndexPath: indexPath) as! CollectionViewMovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        //
        let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
        
        
        cell.postersView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in

                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.postersView.alpha = 0.0
                    cell.postersView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.postersView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.postersView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                print("failed")
                // do something for the failure condition
        })
        //
        
        
        cell.movieLabel.text = title
   
        print("row \(indexPath.row)")
        return cell

        
    }

    //
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}