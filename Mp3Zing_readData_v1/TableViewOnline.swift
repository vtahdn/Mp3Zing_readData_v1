//
//  TableViewOnline.swift
//  MP3ZING
//
//  Created by Viet Asc on 11/5/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

let DocumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first

class TableViewOnline: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let codeList = ["ZW9DC99A":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=kmcHtZmaJbFRDsStkybHkHTLWzDmblVLZ&sig=759288693586d8e36c9c1ddb3308d30d",
                    "ZW9DFW8O":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=kHcmtZmaxDdisANTZyFmZHykpzFmblzQL&sig=ade2f014b91dddff1c0db9a34bfc8e4a",
                    "ZW9DFW9A":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=ZmJHyLnaJFdiaNHTLtDHZHyZWzFnDlWdQ&sig=ba7e2c686608cd7d2196954bc1cb6f9c",
                    "ZW9E86WA":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LGJHykGaxbNapzCtLyDHZmykWSbHFAQSR&sig=2397b05e13674c715c69b6d47c1d7f70",
                    "ZW9C8FDB":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LHJGyLHNJZScRQWtZTDHZnykQzbGFzpJL&sig=b8729285a856eea615855d70d1acc5de",
                    "ZW9C0WDI":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=ZmxGtLHsxLLbcSRyZTvHZmtkWzbmFzpRA&sig=b206cb599fc5b23525b99861d945c5ac",
                    "ZW9DODFI":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LmcHyZmaJkRBQFZTZTvnZmTZQzFnbzCSS&sig=ae7aa67af3ccd890c5dd6fdda213bb1a",
                    "ZW9DCEE6":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=kncmtkHsJDBmhVGyLTDHZGyZpAFmbzChd&sig=e0e85219815391820af9f8041ee52b6e",
                    "ZW9EAI76":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LmxGykmaJFcAWdztkyDHZGykpSbHvzsHZ&sig=842ba96f6ca970aae63069b1a9644bf8",
                    "ZW9C7FFZ":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=ZmJmykHNxZSSxxpykyFmkmtkpSFHFAaDb&sig=7277e48373befff99967bd578fec5c60",
                    "ZW9A7CEE":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=knxHyLnsJHkdnVxyLtFnkmyZWSbmFAapx&sig=9a495281b103cfea5ac185678a47ffef",
                    "ZW9BAAOF":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=kGJmyLmNxmEHZaptLtFmkmtZWzFmblJni&sig=4742eac2ad93cc79b8ab1ee6930776d6",
                    "ZW9BCU0D":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=knJGykmscHigaJLTLybHLGtkWzFGbSxdu&sig=84b6e8b678d31c72288fb15619c4fce1",
                    "ZW9DIEUI":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=ZGxHtLGacLJpzHRykyFmkGyLWSFnbAuRJ&sig=ac604f0be5fb67f0f086ef4b3d6d34fb",
                    "ZW9CBEEO":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LnJGykGscLhHERWyZybmkntkWSFGFWmFa&sig=2cb000e877a44eb6faf20ad8f15372e4",
                    "ZW8WZ7B9":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LHcGtLHNXSdmhAEtLybHZmyZQzFmFQnXN&sig=06690ccee79390acede9cea0e2e9c8d3",
                    "ZW9DAB0O":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=ZmxHtZmscFvLSzdTkyFmLmtZWzFHFpmJN&sig=d59ffa8eb9f284cf8059118213bc2bb7",
                    "ZW9C0DOU":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=ZnxHykmsJZkWQHxTLybmZHTLWSFHFQLnF&sig=e3eace1abb179b6e927bf66140b1d330",
                    "ZW9C0DWE":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=LmcHtkHNxLkWWmDyLybGkmyLpSFnFWZbJ&sig=60131b2ccf9665f615f73dafae086a18",
                    "ZW9E8U8W":"https://mp3.zing.vn/xhr/media/download-source?type=audio&code=kmxHtLnaJFNskDbTkTFmkHTZQlbnDWZpi&sig=56c6437d230fa20dbf6767261cbb876c",
    ]
    
    var songList = [Song]()
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
    }
    
    func getData()
    {
        let data = try? Data(contentsOf: URL(string: "https://mp3.zing.vn/top100/Nhac-Tre/IWZ9Z088.html")!)
        //        print(String(data: data!, encoding: .utf8)!)
        let doc = TFHpple(htmlData: data!)
        
        //        let path = "//div[@class='e-item']"
        let path = "//ul[@class='fn-list']/li"
        
        // All elements in doc
        if let elements = doc?.search(withXPathQuery: path) as? [TFHppleElement] {
            // Doc elements size
            print("rootElements size:\(elements.count)")
            // Reading elements
            
            // Song number limit
            var count = 0
            
            for element in elements {
                
                DispatchQueue.global(qos: .default).async(execute: {
                    if let id = element.attributes["data-id"] as? String {
                        if let sourceString = self.codeList[id] {
                            if count < 20 {
                                count += 1
                                // title
                                let titlePath = "//h3/a"
                                var titleString = ""
                                if let titles = element.search(withXPathQuery: titlePath) as? [TFHppleElement] {
                                    // Doc children size
                                    titleString = titles[0].content!
                                    
                                }
                                // end: title
                                
                                // artist
                                let artistPath = "//h4[@class='title-sd-item txt-info fn-artist']/a"
                                var artistString = ""
                                if let artists = element.search(withXPathQuery: artistPath) as? [TFHppleElement] {
                                    //                    print("artists size: \(artists.count)")
                                    var artistsCount = 0
                                    for artist in artists {
                                        if artists.count <= 1 {
                                            artistString = artist.content!
                                        } else {
                                            artistString += ", \(artist.content!)"
                                        }
                                        artistsCount += 1
                                    }
                                }
                                // end: artist
                                
                                // thumbnail
                                let thumbnailPath = "//img"
                                var thumbnailString = ""
                                if let thumbnails = element.search(withXPathQuery: thumbnailPath) as? [TFHppleElement] {
                                    //                        print("- thumnail src: \(thumbnails[0].attributes["src"]!)")
                                    thumbnailString = thumbnails[0].attributes["src"] as! String
                                }
                                // end: thumbnail
                                
                                // Start: Add Songs To List
                                self.addSongToList(titleString, artistString, thumbnailString, sourceString)
                                // End: adding songs
                                //                            print(id)
                                //                            print(titleString)
                                
                            }
                        }
                    }
                })
                // end: search element
            }
            // end: reading elements
        }
    }
    
    func addSongToList(_ title: String, _ artist: String, _ thumbnail: String, _ source: String) {
        let currentSong = Song(title: title, artist: artist, thumbnail: thumbnail, source: source)
        songList.append(currentSong)
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = songList[indexPath.row].thumbnail
        cell.textLabel?.text = songList[indexPath.row].title
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Download") { (action, index) in
            DispatchQueue.global().async {
                self.downloadSong(indexPath.row)
            }
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
        
        edit.backgroundColor = UIColor(red: 248/255, green: 55/255, blue: 186/255, alpha: 1.0)
        return [edit]
    }
    
    func downloadSong(_ index: Int) -> Void {
        let urlString = songList[index].sourceOnline
        let songData = try? Data(contentsOf: URL(string: urlString)!)
        if let dir = DocumentDirectoryPath {
            let pathToWriteSong = "\(dir)/\(songList[index].title)"
            //writing
            do {
                try FileManager.default.createDirectory(atPath: pathToWriteSong, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            // Write songs
            if let data = songData {
                writeDataToPath(data as NSData, path: "\(pathToWriteSong)/\(songList[index].title).mp3")
            } else {
                print("dataSong is nil")
            }
            
            writeInfoSong(song: songList[index], path: pathToWriteSong)
        }
    }
    
    func writeDataToPath(_ data: NSObject, path: String) -> Void {
//                data.write(toFile: path, atomically: true)
        if let dataToWrite = data as? Data
        {
            try? dataToWrite.write(to: URL(fileURLWithPath: path), options: [.atomic])
        }
        else if let dataInfo = data as? NSDictionary
        {
            dataInfo.write(toFile: path, atomically: true)
        }
    }
    
    func writeInfoSong(song: Song, path: String) -> Void {
        
        let dictData = NSMutableDictionary()
        dictData.setValue(song.title, forKey: "title")
        dictData.setValue(song.artist, forKey: "artist")
        dictData.setValue("/\(song.title)/thumbnail.png", forKey: "localThumbnail")
        dictData.setValue(song.sourceOnline, forKey: "sourceOnline")
        //writing info
        writeDataToPath(dictData, path: "\(path)/info.plist")
        
        //writing thumbnail
        let dataThumbnail = NSData(data: song.thumbnail.pngData()!) as Data
        writeDataToPath(dataThumbnail as NSObject, path: "\(path)/thumbnail.png")
        
    }
}
