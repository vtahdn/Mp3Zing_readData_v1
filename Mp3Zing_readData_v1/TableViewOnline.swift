//
//  TableViewOnline.swift
//  MP3ZING
//
//  Created by Viet Asc on 11/5/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit
import WebKit

let DocumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first

class TableViewOnline: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    
    
    var songList = [Song]()
    //    var resultList = [String:String]()
    var threadCount = [Int:Bool]()
    var timerLimit = [String:Int]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
        //        getDownloadLink()
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
            
            // Finishing Thread Handle
            
            // Reading elements
            // Song number limit
            let threadNumber = 0
            for element in elements {
                threadCount[threadNumber] = false
                //                DispatchQueue.main.async {
                DispatchQueue.global(qos: .default).async(execute: {
                    if let id = element.attributes["data-id"] as? String {
                        print("id: \(id)")
                        
                        //                        self.resultList[id] = ""
                        // title
                        let titlePath = "//h3/a"
                        var titleString = ""
                        while titleString == "" {
                            if let titles = element.search(withXPathQuery: titlePath) as? [TFHppleElement] {
                                // Doc children size
                                titleString = titles[0].content!
                            } else {
                                print("id: \(id) - titleString is emplty")
                            }
                        }
                        
                        // end: title
                        
                        // artist
                        let artistPath = "//h4[@class='title-sd-item txt-info fn-artist']/a"
                        var artistString = ""
                        while artistString == "" {
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
                            } else {
                                print("id: \(id) - artistString is empty.")
                            }
                        }
                        // end: artist
                        
                        // thumbnail
                        let thumbnailPath = "//img"
                        var thumbnailString = ""
                        while thumbnailString == "" {
                            if let thumbnails = element.search(withXPathQuery: thumbnailPath) as? [TFHppleElement] {
                                thumbnailString = thumbnails[0].attributes["src"] as! String
                            } else {
                                print("id: \(id) - thumbnailString is empty.")
                            }
                        }
                        
                        // end: thumbnail
                        
                        // Start: Add Songs To List
                        self.addSongToList(id, titleString, artistString, thumbnailString, "")
                        // End: adding songs
                        //                            print(id)
                        //                            print(titleString)
                    }
                    self.threadCount[threadNumber] = true
                })
                //                }
                // end: search element
            }
            
            
            //            let timeCount = Count(count: 0)
            //            let data = [timeCount] as [Any]
            
            
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForCount(sender:)), userInfo: data, repeats: true)
            // end: reading elements
        }
    }
    
    @objc func timerForCount(sender: Timer) -> Void {
        //        let data = sender.userInfo as! [Any]
        //        let timerCount = data[0] as! Count
        //        print("count: \(timerCount.count)")
        //        timerCount.count += 1
        //        print("in \(timerCount.count), result list: \(resultList.count)")
        var threadFinishRuning = true
        for element in threadCount {
            if element.value == false {
                threadFinishRuning = false
                print("The thread at \(element.value) is not finished.")
                break
            }
        }
        if threadFinishRuning {
            print("[song].count: \(songList.count)")
            
            for song in songList {
                //                 print("song id: \(song.id)")
                initWeb(id: song.id)
            }
            sender.invalidate()
        }
        //        if timerCount.count <= 30 {
        //            for item in resultList {
        //                print("didSelectedID count: \(didSelectedID.count)")
        //                if didSelectedID.count == 0 {
        //                    didSelectedID.append(item.key)
        //                    initWeb(id: item.key)
        //                } else if didSelectedID.contains(item.key) {
        //                    continue
        //                } else {
        //                    didSelectedID.append(item.key)
        //                    initWeb(id: item.key)
        //                }
        //
        //            }
        //            sender.invalidate()
        //        }
    }
    
    func initWeb(id: String) -> Void {
        let web = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        web.load(URLRequest(url: URL(string: "https://mp3.zing.vn/bai-hat/\(id).html")!))
        web.navigationDelegate = self as WKNavigationDelegate
        web.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/605.1.12 (KHTML, like Gecko) Version/11.1 Safari/605.1.12"
        web.backgroundColor = .black
        view.addSubview(web)
        let selector = #selector(updateTimer(sender:))
        let count = Count(count: 0)
        let index = 1 + 1/Float(songList.count)
        //        print("index: \(index)")
        //        print("id: \(id) - index: \(index)")
        let data = [web, count, id] as [Any]
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(index), target: self, selector: selector, userInfo: data, repeats: true)
    }
    
    class Count {
        var count: Int
        init(count: Int) {
            self.count = count
        }
    }
    
    @objc func updateTimer(sender: Timer) -> Void {
        let data = sender.userInfo as! [Any]
        let web = data[0] as! WKWebView
        let count = data[1] as! Count
        let id = data[2] as! String
        //        print("id: \(id)")
        var song = Song()
        for s in songList {
            if s.id == id {
                song = s
                break
            }
        }
        print("id: \(id) , count: \(count.count)")
        count.count += 1
        if count.count < 60 && song.sourceOnline == "" {
            web.evaluateJavaScript("document.getElementById('tabService').getAttribute('id')") {
                (value, error) in
                if value != nil {
                    web.evaluateJavaScript("document.getElementsByClassName('fn-128')[2].getAttribute('href') == null", completionHandler: { (value, error) in
                        if let empty = value as? Bool {
                            if empty {
                                web.evaluateJavaScript("document.getElementById('tabService').click()", completionHandler: { (value, error) in
                                })
                            } else {
                                web.evaluateJavaScript("document.getElementsByClassName('fn-128')[2].getAttribute('href')", completionHandler: { (value, error) in
                                    //                                result[id] = "\(value)"
                                    //                                    print("value: \(String(describing: value))")
                                    if value != nil {
                                        //                                        self.resultList[id] = String(describing: value)
                                        //                                        print("id: \(id) , result: \(self.resultList)")
                                        song.sourceOnline = "https://mp3.zing.vn\(value as! String)"
                                        let alert = UIAlertController(title: "Download Alert", message: "\(song.title) download link is ready.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                            switch action.style {
                                            case .default:
                                                alert.dismiss(animated: true, completion: nil)
                                                break
                                            case .cancel:
                                                print("cancel")
                                                break
                                            case .destructive:
                                                print("destructive")
                                                break
                                            }
                                            
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        //                                        let delay = 5000 * Double(NSEC_PER_SEC)
                                        //                                        let time = DispatchTime.init(uptimeNanoseconds: UInt64(delay))
                                        //                                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                        //                                            alert.dismiss(animated: true, completion: nil)
                                        //                                        })
                                        self.closeWeb(sender,web)
                                    }
                                })
                            }
                        }
                    })
                }
            }
        } else {
            closeWeb(sender,web)
        }
        for song in songList {
            if song.sourceOnline != "" {
                print("id: \(song.id) \n- sourceOnline: \(song.sourceOnline)")
            }
        }
    }
    
    func closeWeb(_ sender: Timer,_ web: WKWebView) -> Void {
        sender.invalidate()
        web.stopLoading()
        web.removeFromSuperview()
    }
    
    func addSongToList(_ id: String, _ title: String, _ artist: String, _ thumbnail: String, _ source: String) {
        let currentSong = Song(id: id, title: title, artist: artist, thumbnail: thumbnail, source: source)
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
