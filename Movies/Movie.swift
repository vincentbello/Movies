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
        
        for (keyName, subJson): (String, JSON) in json {
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
    func movieImageLink(width: Int = 185) -> String {
        if self.img_link.characters.count > 0 {
            return "http://image.tmdb.org/t/p/w\(width)\(self.img_link)"
        } else {
            return GlobalConstants.DefaultMovieImage;
        }
    }
    
    func backdropImageLink(width: Int = 396) -> String {
        if self.backdrop.characters.count > 0 {
            return "http://image.tmdb.org/t/p/w\(width)\(self.backdrop)"
        } else {
            return GlobalConstants.DefaultBackdropImage
        }
    }
    
    func genRuntime() -> String {
        
        if self.runtime < 60 {
            return self.runtime == 0 ? "" : "\(self.runtime) min"
        } else {
            let h = Int(floor(Double(self.runtime/60)))
            let m : Int = self.runtime % 60
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
        var elements = [String]()
        
        if runtime.characters.count > 0 {
            elements.append(runtime)
        }
        if genres.characters.count > 0 {
            elements.append(genres)
        }
        if language.characters.count > 0 {
            elements.append(language)
        }
        
        return " - ".join(elements)
    }
        
    func titleAttributedString() -> NSMutableAttributedString {
        let titleAttrs = [NSFontAttributeName: UIFont(name: ".SFUIText-Semibold", size: 17)!]
        let attributedString = NSMutableAttributedString(string: "\(self.title) ", attributes: titleAttrs)
        let yearAttrs = [NSFontAttributeName: UIFont.systemFontOfSize(13), NSForegroundColorAttributeName: GlobalConstants.Colors.DarkGrayColor]
        let yearString = NSMutableAttributedString(string: String(self.year), attributes: yearAttrs)
        attributedString.appendAttributedString(yearString)
        attributedString.appendAttributedString(NSAttributedString(string: "\n"))
        let genresAttr = [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.grayColor()]
        let genresString = NSMutableAttributedString(string: self.genres, attributes: genresAttr)
        attributedString.appendAttributedString(genresString)
        return attributedString
    }
    
    func titleDetailAttributedString() -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping

        
        
        let attributedString = NSMutableAttributedString(string: "\(self.title) ", attributes: [NSParagraphStyleAttributeName: paragraphStyle])
        let yearAttrs = [NSFontAttributeName: UIFont(name: GlobalConstants.Fonts.Main.Regular, size: 13.0)!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        let yearString = NSMutableAttributedString(string: " (\(self.year)) ", attributes: yearAttrs)
        attributedString.appendAttributedString(yearString)
        let ratingAttrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(11.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        let ratingString = NSMutableAttributedString(string: " \(self.mpaa)", attributes: ratingAttrs)
        attributedString.appendAttributedString(ratingString)

        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        
        return attributedString
    }
    
    
    func mpaaToSprite(rating: String) -> UIImage {
        var frame = 0
        switch rating {
        case "R":
            frame = 1
        case "PG":
            frame = 2
        case "PG-13":
            frame = 1
        case "NC-17":
            frame = 2
        default:
            break
        }
    
        print(frame)
    
        return UIImage()
    }
    
    
    
    
    
    
    
    
    
}