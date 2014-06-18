//
//  DetailsViewController.swift
//  Swift iTunes Browser
//
//  Created by Paul Yu on 14/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var albumCover : UIImageView
    @IBOutlet var titleLabel : UILabel
    @IBOutlet var tracksTableView : UITableView
    @IBOutlet var navItem : UINavigationItem
    
    var api: APIController?
    var album: Album?
    var tracks: Track[] = []
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    var indexOfTrackPlaying : NSIndexPath? = nil
    
    let playIcon = "▶️"
    let stoppedIcon = "⬛️"
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = self.album?.title
        navItem.prompt = self.album?.title
        
        // Jump in to a background thread to download the album art
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var imgData = NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL))
            
            // Now come back to the main thread to update the UI
            dispatch_async(dispatch_get_main_queue(), {
                self.albumCover.image = UIImage(data: imgData);
                });
            })
        
        // Load in tracks
        self.api = APIController(delegate: self)
        let api = self.api!
        if self.album?.collectionId? {
            api.lookupAlbum(self.album!.collectionId!)
        }
    }
        
    func didRecieveAPIResults(results: NSDictionary) {
        if let allResults = results["results"] as? NSDictionary[] {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind=="song" {
                        var track = Track(dict: trackInfo)
                        tracks.append(track)
                        println("Track: \(track.title)")
                    }
                }
            }
        }
        
        self.tracksTableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("Track Count: \(tracks.count)")
        return tracks.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        if cell == nil {
            cell = TrackCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TrackCell")
        }
        var track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        if( trackPlaying(indexPath) ) {
            cell.playIcon.text = stoppedIcon
        }
        else {
            cell.playIcon.text = playIcon
        }
        println("TrackCell: \(track.title)")
        return cell
    }
 
//should be functionally equivalent but crashes the app
//    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        var track = tracks[indexPath.row]
//         if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
//            var paths : NSIndexPath[] = [indexPath]
//            var indexPathThatWasPlaying = stopPlayingTrack()
// 
//            if (indexPathThatWasPlaying? != nil)
//            {
//                if (indexPathThatWasPlaying == indexPath)
//                {
//                    cell.playIcon.text = playIcon
//                }
//                else
//                {
//                    cell.playIcon.text = stoppedIcon
//                    mediaPlayer.contentURL = NSURL(string: track.previewUrl)
//                    mediaPlayer.play()
//                    indexOfTrackPlaying = indexPath
//                }
//            }
//            else
//            {
//                cell.playIcon.text = stoppedIcon
//                mediaPlayer.contentURL = NSURL(string: track.previewUrl)
//                mediaPlayer.play()
//                indexOfTrackPlaying = indexPath
//            }
//            
//            if (indexPathThatWasPlaying? != nil)
//            {
//                paths = [indexPath, indexPathThatWasPlaying!]
//            }
//            tableView.reloadRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.None)
//        }
//    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var track = tracks[indexPath.row]
        var indexPathThatWasPlaying : NSIndexPath? = nil
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            if(trackPlaying(indexPath)) {
                cell.playIcon.text = playIcon
                stopPlayingTrack()
            }
            else {
                cell.playIcon.text = stoppedIcon
                indexPathThatWasPlaying = stopPlayingTrack()
                mediaPlayer.contentURL = NSURL(string: track.previewUrl)
                mediaPlayer.play()
                indexOfTrackPlaying = indexPath
            }
            var paths : NSIndexPath[] = [indexPath]
            if (indexPathThatWasPlaying? != nil)
            {
                paths = [indexPath, indexPathThatWasPlaying!]
            }
            tableView.reloadRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func stopPlayingTrack() -> NSIndexPath?
    {
        mediaPlayer.stop()
        var indexPathThatWasPlaying = indexOfTrackPlaying
        indexOfTrackPlaying = nil
        return indexPathThatWasPlaying
    }
    
    func trackPlaying(indexPath: NSIndexPath) -> Bool {
        return (indexOfTrackPlaying? != nil) && (indexOfTrackPlaying! == indexPath)
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
