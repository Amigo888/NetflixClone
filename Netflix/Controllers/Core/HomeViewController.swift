//
//  HomeViewController.swift
//  Netflix
//
//  Created by Дмитрий Процак on 28.11.2022.
//

import UIKit
//create enum(для удобной работы с секциями в тейбл вью)
enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    //name of sections
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    
    
    // create tableView
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        //delegate & datasource
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        //adding custom header on tableView
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderUIView()
        
        configureNavBar()
        
    }
    
    private func configureHeroHeaderUIView() {
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
        
    private func  configureNavBar() {
        //var image = UIImage(named: "Unknown")
        
        //logo 'll be always same as on assets('ll change color accordint to dark/light mode)
        //image = image?.withRenderingMode(.alwaysOriginal)
        //leftBarButtonItem
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        //rightBarButtonItems
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        //color of items
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //dimenssions of tableview
        homeFeedTable.frame = view.bounds
    }
}
    
    
//MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    //number of row in sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //creating cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    //получаем сюда модель тайтел
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        case Sections.TrendingTv.rawValue:
            
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
       
        return cell
    }
    // height For Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    // height For Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    //customize title of header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizerFirstLetter()
    }
    
    //navBar 'll hide when scroll down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaulOffSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaulOffSet

        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    //header of section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

//MARK: - CollectionViewTableViewCellDelegate

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapeCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
       DispatchQueue.main.async { [weak self] in
          let vc = TitlePreviewViewController()
          vc.configure(with: viewModel)
          self?.navigationController?.pushViewController(vc, animated: true)
       }
    }
}



























































//MARK: - Example

//private func fetchData() {
//        APICaller.shared.getTrendingMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
    
//        APICaller.shared.getTrendingTvs { results in
//          //
//        }
    
//        APICaller.shared.getUpcomingMovies { results in
//            //
//        }
    
//        APICaller.shared.getPopular { results in
//            //
//        }
    
//    APICaller.shared.getTopRated { results in
//        //
//    }
//
//}
//}



