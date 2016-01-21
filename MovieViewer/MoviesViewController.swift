//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Archit Rathi on 1/5/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collView: UICollectionView!
    
    var tap : UITapGestureRecognizer!
    
    var refreshControl: UIRefreshControl!
    
    var movies:[NSDictionary]?;
    var filteredResults: [NSDictionary]!;
    
    var endPoint:String!;
    
    override func viewDidLoad() {
        collView.dataSource = self;
        networkLabel.hidden = true;
        searchBar.delegate = self;
        

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collView.insertSubview(refreshControl, atIndex: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary];
                            self.filteredResults = self.movies;
                            self.collView.reloadData();
                    }
                }
                else{
                    self.collView.hidden = true;
                    self.networkLabel.hidden = false;
                }
        });
        task.resume()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        animateCollection();
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredResults = filteredResults {
            return filteredResults.count
        } else {
            return 0
        }
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollCell", forIndexPath: indexPath) as! CollecMovieCell
        
        let movie = filteredResults[indexPath.row];
        let title = movie["title"] as! String;
        let rating = movie["vote_average"] as! Double;
        let baseUrl = "http://image.tmdb.org/t/p/w500";
        
        if let posterPath = movie["poster_path"] as! String!{
            let posterUrl = NSURL(string: baseUrl+posterPath);
            cell.posterView.setImageWithURL(posterUrl!);
            
        }
        
        
        cell.ratingLabel.text = "\(rating)";
        //cell.titleLabel.text = title;
        
        return cell;
    }
    
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        EZLoadingActivity.show("Loading...", disableUI: true);
        delay(2, closure: {
            self.refreshControl.endRefreshing()
            EZLoadingActivity.hide(success: true, animated: true)
        })
        
    }
    
    
    

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredResults = searchText.isEmpty ? movies : movies!.filter({ (movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        self.collView.reloadData()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        tap = UITapGestureRecognizer(target: self, action: "endEditing")
        view.addGestureRecognizer(tap)
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        view.removeGestureRecognizer(tap)
    }
    
    
    func endEditing(){
        view.endEditing(true)
    }
    
    func animateCollection() {
        collView.reloadData()
        
        let cells = collView.visibleCells()
        let collHeight: CGFloat = collView.bounds.size.height
        
        for i in cells {
            let cell: UICollectionViewCell = i as UICollectionViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, collHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UICollectionViewCell = a as UICollectionViewCell
            UIView.animateWithDuration(4, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell;
        let indexPath = collView.indexPathForCell(cell);
        let movie = movies![indexPath!.row];
        
        let detailViewController = segue.destinationViewController as! DetailViewController;
        detailViewController.movie = movie;
    }


}
