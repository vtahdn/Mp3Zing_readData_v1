//
//  LocalViewController.swift
//  Mp3Zing_readData_v1
//
//  Created by Viet Asc on 11/13/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class LocalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var songList = [Song]()
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
    }
    
    func getData() -> Void {
        songList.removeAll()
        if let dir = DocumentDirectoryPath {
            do {
                let folders = try FileManager.default.contentsOfDirectory(atPath: dir)
                for folder in folders {
                    if folder != ".DS_Store" {
                        let info = NSDictionary(contentsOfFile: dir + "/" + folder + "/" + "info.plist")
                        let title = info!["title"] as! String
                        let artist = info!["artist"] as! String
                        let thumbnailPath = info!["localThumbnail"] as! String
                        let localSource = dir + "/\(title)/\(title).mp3"
                        let localThumnail = dir + thumbnailPath
                        let currentSong = Song(title: title, artist: artist, localThumbnail: localThumnail, localSource: localSource)
                        songList.append(currentSong)
                    }
                }
                myTableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    // UITableView
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
        let edit = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            self.removeSong(indexPath.row)
            self.myTableView.reloadData()
        }
        edit.backgroundColor = UIColor(red: 248/255, green: 55/255, blue: 186/255, alpha: 1.0)
        return [edit]
    }

    func removeSong(_ atIndex: Int) -> Void {
        if let dir = DocumentDirectoryPath {
            do {
                let path = dir + "/\(songList[atIndex].title)"
                try FileManager.default.removeItem(atPath: path)
                songList.remove(at: atIndex)
                self.myTableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
}
