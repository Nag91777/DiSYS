//
//  NewsDataModel.swift
//  HGS
//
//  Copyright © 2019 DEFTeam. All rights reserved.
//

import Foundation

class NewsDataModel {
    
    var title: String = ""
    var date: String = ""
    var desc: String = ""
    var imgUrl: String = ""
    
    class func getNewsDataModel(dict: [String: Any]) -> NewsDataModel {
        let newsDataModel = NewsDataModel()
        newsDataModel.title = String.giveMeProperString(str: dict["title"])
        newsDataModel.desc = String.giveMeProperString(str: dict["description"])
        newsDataModel.date = String.giveMeProperString(str: dict["date"])
        newsDataModel.imgUrl = String.giveMeProperString(str: dict["image"])
        return newsDataModel
    }
    
    class func getAllNewsModelsData(arr: [[String: Any]]) -> [NewsDataModel] {
        var newsModels = [NewsDataModel]()
        for dict in arr {
            newsModels.append(NewsDataModel.getNewsDataModel(dict: dict))
        }
        return newsModels
    }
    
}
