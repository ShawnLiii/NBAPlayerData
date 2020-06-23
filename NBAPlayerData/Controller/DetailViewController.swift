//
//  DetailViewController.swift
//  NBAPlayerData
//
//  Created by Shawn Li on 5/11/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{

    @IBOutlet weak var playerNameTF: UITextField!
 
    var nameChangeObserver: String?
    var delegate: NBAPlayerNameDelegate?
    var playerName: String?
    {
        didSet(oldValue)
        {
            if let newName = playerName
            {
                nameChangeObserver = "Player \(String(describing: oldValue)) has been changed to \(newName)"
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI()
    {
        playerNameTF.text = playerName
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem)
    {
        playerName = playerNameTF.text
        delegate?.passNameAndObserver(name: playerName!, observer: nameChangeObserver!)
        navigationController?.popViewController(animated: true)
    }
    
}
