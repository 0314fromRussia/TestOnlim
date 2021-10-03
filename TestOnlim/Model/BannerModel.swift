//
//  BannerModel.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import Foundation

//Equatable нужен для операции сравнения
struct BannerModel: Codable, Equatable {
    var name: String
    var color: String
    var active: Bool
}
