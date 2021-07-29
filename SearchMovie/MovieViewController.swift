//
//  ViewController.swift
//  SearchMovie
//
//  Created by Felipe Ignacio Zapata Riffo on 28-07-21.
//

import UIKit
import SDWebImage


class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var searchBar:UISearchBar?
    var homeText = "fast"
    var resultSearch: [Search] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        searchBar?.delegate = self
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
       
        tableView?.rowHeight = 250
        fetchMovie(query: homeText)
       
         
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {
            return
        }
        resultSearch = []
        print("\(text)")
        tableView?.reloadData()
        fetchMovie(query: text)
         
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        }
    
    func fetchMovie (query:String){
        let urlString = "http://www.omdbapi.com/?apikey=d7ae49fd&s=\(query)&type=movie"
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            var results:Welcome?
           do{
               let results = try JSONDecoder().decode(Welcome.self, from: data)
               DispatchQueue.main.async {
                self.resultSearch = results.search
                print(results.search.count)
                print(results.totalResults)
                self.tableView?.reloadData()
                 
                
               }
             
           }
           catch {
               print(error)
           }
       }
       task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
    
        
        let data = resultSearch
         
        cell.movieTitleLabel.text = data[indexPath.row].title
        cell.movieYearLabel.text = data[indexPath.row].year
        
        if let dataImg = data[indexPath.row].poster{
        cell.moviePosterImageView.sd_setImage(with: URL(string: dataImg))
        }
        
        
        return cell
    }

}

