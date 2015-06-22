//
//  Movie.swift
//  Movies
//
//  Created by Vincent Bello on 6/1/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var id : Int = 0
    var title : String = ""
    var year : Int = 2015
    var release_date : String = ""
    var runtime : Int = 0
    var genres : String = ""
    var adult : Int = 0
    var synopsis : String = ""
    var tagline : String = ""
    var director : Int = 0
    var img_link : String = ""
    var image = UIImage(named: "no_image_found")
    var imageState = PhotoRecordState.New
    var language : String = ""
    var mpaa : String = ""
    var revenue : Int = 0
    var imdb_id : String = ""
    var trailer : String = ""
    var popularity : Double = 0
    var backdrop : String = GlobalConstants.DefaultBackdropImage
    
    var linkCount : Int = 0
    
    init(id : Int, title : String, year : Int, release_date : String, runtime : Int, genres : String, adult : Int, synopsis : String, tagline : String, director : Int, img_link : String = GlobalConstants.DefaultMovieImage, language : String, mpaa : String, revenue : Int = 0, imdb_id : String, trailer : String, popularity : Double = 0, backdrop : String = GlobalConstants.DefaultBackdropImage) {
        
        self.id = id
        self.title = title
        self.year = year
        self.release_date = release_date
        self.runtime = runtime
        self.genres = genres
        self.adult = adult
        self.synopsis = synopsis
        self.tagline = tagline
        self.director = director
        self.img_link = img_link
        self.language = language
        self.mpaa = mpaa
        self.revenue = revenue
        self.imdb_id = imdb_id
        self.trailer = trailer
        self.popularity = popularity
        self.backdrop = backdrop
    }
    
    init(JSONDictionary: NSDictionary) {
        super.init()
        
        // loop
        for (key, value) in JSONDictionary {
            let keyName = key as! String
            let keyValue : AnyObject
            if keyName == "linkCount" {
                keyValue = value as! Int
            } else {
                keyValue = value as! String
            }
            
            // if property exists
            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
    init(json: JSON) {
        super.init()
        
        for (keyName: String, subJson: JSON) in json {
            let keyValue : AnyObject
            if keyName == "linkCount" {
                keyValue = subJson.int!
            } else {
                keyValue = subJson.string!
            }
                        
            // if property exists
            if self.respondsToSelector(NSSelectorFromString(keyName)) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
    
    
    // return UIImage based on link
    func movieImageLink() -> String {
        if count(self.img_link) > 0 {
            return "http://image.tmdb.org/t/p/w300\(self.img_link)"
        } else {
            return GlobalConstants.DefaultMovieImage;
        }
    }
    
    // return UIImage based on backdrop
    func backdropImage() -> UIImage {
        
        var urlPath: String
        if count(self.backdrop) > 0 {
            urlPath = "http://image.tmdb.org/t/p/w780\(self.backdrop)"
        } else {
            urlPath = GlobalConstants.DefaultBackdropImage;
        }
        let url = NSURL(string: urlPath)
        let data = NSData(contentsOfURL: url!)
        return UIImage(data: data!)!
    }
    
    func genRuntime() -> String {
        
        if self.runtime < 60 {
            return self.runtime == 0 ? "" : "\(self.runtime) min"
        } else {
            var h = Int(floor(Double(self.runtime/60)))
            var m : Int = self.runtime % 60
            return "\(h)h" + ((m < 10) ? "0\(m)" : "\(m)")
        }
    }
    
    func findMovieInArray(moviesArr: [Movie]) -> Movie {
        for mov in moviesArr {
            if mov.id == self.id {
                return mov
            }
        }
        return self
    }
    
    func genInformation() -> String {
        let runtime = self.genRuntime()
        let genres = self.genres
        let language = self.language
        var str = ""
        var elements = [String]()
        
        if count(runtime) > 0 {
            elements.append(runtime)
        }
        if count(genres) > 0 {
            elements.append(genres)
        }
        if count(language) > 0 {
            elements.append(language)
        }
        
        return " - ".join(elements)
    }
}