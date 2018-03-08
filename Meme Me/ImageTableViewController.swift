//
//  ImageTableViewController.swift
//  Meme Me
//
//  Created by Shailesh Aher on 3/8/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class ImageTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let reuseId = "ListTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: reuseId, bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        title = "List"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeHandler.shared.memeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? ListTableViewCell
        cell?.model = MemeHandler.shared.memeList[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = MemeHandler.shared.memeList[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewImageViewController") as? PreviewImageViewController {
            navigationController?.pushViewController(controller, animated: true)
            controller.model = model
        }
    }
}
