//
//  ShowTableViewCell.swift
//  MyGoodDiary
//
//  Created by Family on 2018/6/4.
//  Copyright © 2018年 bosh. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setShowContent(diary:Diary) {
        titleLabel.text = diary.title
        dateLabel.text = diary.date
        
        let directoryPath = NSHomeDirectory().appending("/Documents/\(diary.image)")
        let image = UIImage(contentsOfFile: directoryPath)
        myImageView.image = image
    }
}
