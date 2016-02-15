//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by I-Shiun Kuo on 2/8/16.
//  Copyright © 2016 I-Shiun Kuo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{
            
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
            //
            let smallImageUrl = "https://image.tmdb.org/t/p/w45"
            let largeImageUrl = "https://image.tmdb.org/t/p/original"
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrl + posterPath)!)

            
            //
            
            
            posterImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if smallImageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = smallImage
                        
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                       self.posterImageView.alpha = 1.0
                        //
                            }, completion: { (sucess) -> Void in
                                
                                // The AFNetworking ImageView Category only allows one request to be sent at a time
                                // per ImageView. This code must be in the completion block.
                                self.posterImageView.setImageWithURLRequest(
                                    largeImageRequest,
                                    placeholderImage: smallImage,
                                    success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                        
                                        self.posterImageView.image = largeImage;
                                        
                                    },
                                    failure: { (request, response, error) -> Void in
                                        // do something for the failure condition of the large image request
                                        // possibly setting the ImageView's image to a default image
                                })
                        })
                    }
                    //
                    else {
                        self.posterImageView.setImageWithURLRequest(largeImageRequest,
                            placeholderImage: nil,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            //, failure: )
                        print("Image was cached so just update the image")
                        self.posterImageView.image = largeImage
                    },
                            failure:{(request, response, error) -> Void in
                                print("error")

                    //
                        })}
                },failure: { (request, response, error) -> Void in
                        // do something for the failure condition
                        // possibly try to get the large image
                    }
        
        
        
    )

        // Do any additional setup after loading the view.
    }

    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}