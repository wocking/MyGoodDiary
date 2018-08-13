//
//  ShowDiaryViewController.swift
//  MyGoodDiary
//
//  Created by Bosh on 2018/6/15.
//  Copyright © 2018年 bosh. All rights reserved.
//

import UIKit

class ShowDiaryViewController: UIViewController {
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showDateLabel: UILabel!
    @IBOutlet weak var showArticleLabel: UILabel!
    var diary:Diary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDiary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func showDiary()  {
        if let diaryData = diary {
            showTitleLabel.text = diaryData.title
            showDateLabel.text = diaryData.date
            showArticleLabel.text = diaryData.article
            showImageView.image = UIImage(contentsOfFile: NSHomeDirectory().appending("/Documents/\(diaryData.image)"))
        }
    }
    
    //MARK: - Pass Data
    
    @IBAction func editBarButtonItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEdit" {
            if let segue = segue.destination as? AddDiaryViewController{
                segue.diaryData = diary
            }
        }
    }
}
