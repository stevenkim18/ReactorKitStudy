//
//  ViewController.swift
//  GithubSearch
//
//  Created by seungwooKim on 2023/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class GithubSearchViewController: UIViewController, View {
    
    let tableview = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTableview()
//        self.navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setTableview() {
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func bind(reactor: GithubSearchReactor) {
        // Action
        searchController.searchBar.rx.text
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableview.rx.contentOffset
            .filter { [weak self] offset in
                guard let self = self else { return false }
                guard self.tableview.frame.height > 0 else { return false }
                return offset.y + self.tableview.frame.height >= self.tableview.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.repos }
            .bind(to: tableview.rx.items(cellIdentifier: "cell")) { (indexPath, repo, cell) in
                cell.textLabel?.text = repo
            }
            .disposed(by: disposeBag)
        
    }
}

 
