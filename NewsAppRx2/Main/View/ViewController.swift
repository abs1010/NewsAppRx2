//
//  ViewController.swift
//  NewsAppRx2
//
//  Created by Alan Silva on 07/12/20.
//

import UIKit
import RxSwift

class ViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var viewModel: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getNews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //MessageUtil.showSuccessMessage(msg: "Teste uuuuhuuu")
        }
    }
    
    private func getNews() {
        
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=br&apiKey=6ace23c5086742ea849174cf7e33169b")
        
        let resource = Resource<ArticleResponse>(url: url!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articlesList in
                
                let articles = articlesList.articles
                self.viewModel = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    
    //MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel == nil ? 0 : viewModel.articlesVM.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCellID", for: indexPath) as! NewsTableViewCell
        
        let article = viewModel.articleAt(indexPath.row)
        
        article.title.asDriver(onErrorJustReturn: "")
            .drive(cell.title.rx.text)
            .disposed(by: disposeBag)
        
        article.description.asDriver(onErrorJustReturn: "")
            .drive(cell.newsDescription.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
}

