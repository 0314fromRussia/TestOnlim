//
//  ArticleViewController.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit
import Foundation

class ArticleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var articles: [ArticleModel]?
    
    var indexPath: IndexPath?
    
    var photoImageView: UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.image = UIImage(systemName: "swift")
        
        return image
    }()
    
    var stackView: UIStackView = {
        
        let globalStackView = UIStackView()
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        globalStackView.axis = .vertical
        
        return globalStackView
    }()
    
    var titlelabel: UILabel = {
        
        let titlelabel = UILabel()
        titlelabel.font = titlelabel.font.withSize(25)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        return titlelabel
    }()
    
    var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
        
    }()
    
    var scrollStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        
        return stackView
    }()
    
    var textlabel: UILabel = {
        
        let textlabel = UILabel()
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        textlabel.numberOfLines = 0
        textlabel.font = textlabel.font.withSize(20)
        
        return textlabel
        
    }()
    
    var tableView: AutoSizingUiTableView = {
        let tableView = AutoSizingUiTableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupViews()
        setupAutoLayout()
    }
    
    // viewDidLayoutSubviews() может вызываться несколько раз, во время создания иьюконтроллера + при скроле и повороте
    override func viewDidLayoutSubviews() {
        let contentRect: CGRect = scrollStackView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: contentRect.size.width, height: contentRect.size.height + tableView.contentSize.height)
    }
    
    func setupViews() {
        
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(scrollView)
        
        scrollStackView.addArrangedSubview(titlelabel)
        scrollStackView.addArrangedSubview(textlabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articlesTableViewCell")
        
        scrollView.addSubview(scrollStackView)
        scrollView.addSubview(tableView)
        
        view.addSubview(stackView)
    }
    
    func setupAutoLayout() {
        
        photoImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35).isActive = true
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        
        scrollStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        scrollStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        
        tableView.leadingAnchor.constraint(equalTo: scrollStackView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: scrollStackView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: textlabel.bottomAnchor).isActive = true

    }
    func setData(article: ArticleModel, articles: [ArticleModel], indexPath: IndexPath) {
        
//
        var aString = article.title

        aString = aString.filter { $0 != "t" }
        aString = aString.filter { $0 != "e" }
        aString = aString.filter { $0 != "x" }
        
        titlelabel.text = "Заголовок \(aString)"
        
        textlabel.text = article.text
        var othersArticles = articles
        othersArticles.remove(at: indexPath.row)
        
        self.articles = othersArticles
       
    }
    
    // MARK: - Table and Collection view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let otherArticles = articles else { return 0 }
        return otherArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlesTableViewCell", for: indexPath as IndexPath) as! ArticleTableViewCell
        guard let article = articles?[indexPath.row] else { return UITableViewCell() }
        cell.settingCellArticle(article: article)
        
        return cell
    }
    
}

