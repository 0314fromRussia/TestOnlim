//
//  ArticleTableViewCell.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var title: String = "" {
        
        didSet {
            titlelabel.text = title
        }
    }
    
    var articleText: String = "" {
        
        didSet {
            articleTextLabel.text = articleText
        }
    }
    
    var stackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 25
        
        return stackView
    }()
    
    var titlelabel: UILabel = {
        
        let titlelabel = UILabel()
        titlelabel.font = titlelabel.font.withSize(30)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        return titlelabel
        
    }()
    
    var articleTextLabel: UILabel = {
        
        let articleTextLabel = UILabel()
        articleTextLabel.numberOfLines = 0
        articleTextLabel.font = articleTextLabel.font.withSize(20)
        
        articleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return articleTextLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupCell() {
        
        stackView.addArrangedSubview(titlelabel)
        stackView.addArrangedSubview(articleTextLabel)
        contentView.addSubview(stackView)
        
        
        stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 0.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 0.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 0.0).isActive = true

    }
    
    func settingCellArticle(article: ArticleModel) {
        
        self.title = "\(article.title)"
        self.articleText = article.text
    }
    
}

