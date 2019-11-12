//
//  MetricDataTableCell.swift
//  HGS
//
//  Copyright © 2019 DEFTeam. All rights reserved.
//

import UIKit

class NewsDataTableCell: UITableViewCell {

    @IBOutlet weak var viCell: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgAssign: AsyncImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viCell.layer.borderWidth = 1.0
        //viCell.layer.borderColor = UIColor(named: "bcbcbc")?.cgColor
        viCell.clipsToBounds = true
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.numberOfLines = 3
       lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.numberOfLines = 3
    }
    
    func fillDetails(newsModel: NewsDataModel, index: Int){
       // lblDate.text = metricModel.id
        // imgAssign.imageURL = URL(string: task.assignToImgUrl)
        lblTitle.text = newsModel.title
        lblDescription.text = newsModel.desc
        lblDate.text = newsModel.date
        imgAssign.imageURL = URL(string: newsModel.imgUrl)
    }

  
}
