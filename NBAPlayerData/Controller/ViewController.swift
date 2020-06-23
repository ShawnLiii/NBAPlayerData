//
//  ViewController.swift
//  NBAPlayerData
//
//  Created by Shawn Li on 5/11/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NBAPlayerNameDelegate
{
    @IBOutlet weak var playerDisplayTV: UITableView!
    @IBOutlet weak var dataObserverTextView: UITextView!
    
    var playerDic:[String:String]?
    var row = 0
    var cellId = "player"
    var reminder = "Plist has been changed!\n"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        fetchDataFromPlist()
    }

    //MARK: - Table View Setting
    func setupTableView()
    {
        playerDisplayTV.delegate = self
        playerDisplayTV.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return playerDic!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = playerDisplayTV.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlayerTableViewCell
        
        cell.playerNameLabel.text = playerDic![String(indexPath.row)]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Preparing and Fetching
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! DetailViewController
        vc.delegate = self
        let cell = sender as! PlayerTableViewCell
        row = playerDisplayTV.indexPath(for: cell)!.row
        vc.playerName = playerDic![String(row)]
    }
    
    func fetchDataFromPlist()
    {
        if let url = Bundle.main.url(forResource: "NBAPlayer", withExtension: "plist")
        {
            do
            {
                let data = try Data(contentsOf: url)
                
                if let nsDic = try (PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)) as? [String : String]
                {
                    playerDic = nsDic
                }
            }
            catch
            {
                print(error)
            }
        }
    }
    //MARK: - Delegate Method
    
    func passNameAndObserver(name: String, observer: String)
    {
        //Update Data
        playerDic![String(row)] = name
        //Write to plist
//        if let url = Bundle.main.url(forResource: "NBAPlayer", withExtension: "plist")
        if let path = Bundle.main.path(forResource: "NBAPlayer", ofType: "plist")
        {
//            do
//            {
//                let data = try PropertyListSerialization.data(fromPropertyList: playerDic!, format: .xml, options: .zero)
                let dataOfDic = NSMutableDictionary(dictionary: playerDic!)
                
                //MARK: - Unsolved Problem. Can't write data into plist
//                try data.write(to: url, options: .atomic)
                dataOfDic.setValue("Value", forKey: "Key")
//                dataOfDic.write(to: url, atomically: true)
                dataOfDic.write(toFile: path, atomically: true)
                dataObserverTextView.text.append(reminder)
//        }
//            catch
//            {
//                print(error)
//            }
        
        //Update View
        playerDisplayTV.reloadData()
        dataObserverTextView.text.append(observer)
        }
    }
}
