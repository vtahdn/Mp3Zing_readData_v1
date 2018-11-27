//
//  File.swift
//  Mp3Zing_displayData_v1
//
//  Created by Viet Asc on 11/10/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import Foundation
import UIKit
class Song {
    var id = ""
    var title = ""
    var artist = ""
    var thumbnail = UIImage()
    var sourceOnline = ""
    var sourceLocal = ""
    var localThumbnail = ""
    init(){}
    init(id: String, title: String, artist: String, thumbnail: String, source: String) {
        self.id = id
        self.title = title
        self.artist = artist
        let dataImage = try? Data(contentsOf: URL(string: thumbnail)!)
        self.thumbnail = UIImage(data: dataImage!)!
        self.sourceOnline = source
    }
    init(title: String, artist: String, localThumbnail: String, localSource: String) {
        self.title = title
        self.artist = artist
        self.localThumbnail = localThumbnail
        let dataImage = NSData(contentsOfFile: localThumbnail)
        self.thumbnail = UIImage(data: dataImage! as Data)!
        self.sourceLocal = localSource
    }
}
