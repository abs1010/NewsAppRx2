//
//  Article.swift
//  NewsAppRx2
//
//  Created by Alan Silva on 07/12/20.
//

import Foundation

struct ArticleResponse: Codable {
    let articles : [Article]
}

struct Article : Codable{
    let title: String
    let description: String?
}
