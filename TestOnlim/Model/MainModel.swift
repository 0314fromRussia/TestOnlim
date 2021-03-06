//
//  MainModel.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import Foundation

struct MainModel: Codable {
    var banners: [BannerModel]
    var articles: [ArticleModel]
}
