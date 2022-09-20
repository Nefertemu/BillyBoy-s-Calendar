//
//  GamesListTableViewController.swift
//  BillyBoy's Calendar
//
//  Created by Bogdan Anishchenkov on 19.09.2022.
//

import UIKit

class GamesListTableViewController: UITableViewController {
    
    private var games: Result = Result(results: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGames()
        self.registerTableViewCells()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentGame = games.results[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "game") as? GameTableViewCell {
            
            cell.gameImage.downloaded(from: currentGame.background_image)
            
            cell.gameTitleLabel.text = currentGame.name
            cell.gameTitleLabel.font = .boldSystemFont(ofSize: 20)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let convertedDate = dateFormatter.date(from: currentGame.released)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let goodDate = dateFormatter.string(from: convertedDate ?? Date.now)
            cell.gameReleaseDateLabel.text = "Release date: \(goodDate)"
            
            cell.gameGenreLabel.text = "Genre: \(currentGame.genres.randomElement()!.name)"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func registerTableViewCells() {
        let gameCell = UINib(nibName: "GameTableViewCell",
                             bundle: nil)
        tableView.register(gameCell, forCellReuseIdentifier: "game")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func fetchGames() {
        let today = Date.now
        let formatterToday = DateFormatter()
        formatterToday.dateFormat = "yyyy-MM-dd"
        
        guard let url = URL(string: "https://api.rawg.io/api/games?key=f07deefc2bc44d598924364d1352b9db&platforms=186&dates=\(formatterToday.string(from: today)),2022-12-30&ordering=released") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(Result.self, from: data)
                    DispatchQueue.main.async {
                        self.games = parsedJSON
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
     /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Extensions

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
