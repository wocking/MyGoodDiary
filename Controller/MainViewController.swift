//
//  ViewController.swift
//  MyGoodDiary
//
//  Created by Family on 2018/6/4.
//  Copyright © 2018年 bosh. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var myTableView: UITableView!
    var diaryArray = [Diary]()
     let realm = try! Realm()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let result = realm.objects(Diary.self)
        diaryArray = Array(result)
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView dataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowTableViewCell
        let showDiary = diaryArray[indexPath.row]
        
        cell.setShowContent(diary: showDiary)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //delete cell
        if editingStyle == .delete {
            //Updata Exist Data
            try! realm.write {
                realm.delete(diaryArray[indexPath.row])
                diaryArray.remove(at: indexPath.row)
                myTableView.reloadData()
                print("4")
            }
        }
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiary = diaryArray[indexPath.row]
        performSegue(withIdentifier: "goToShowDiaryView", sender:selectedDiary)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToShowDiaryView" {
            if let segue = segue.destination as? ShowDiaryViewController,
                let selectedDiary = sender as? Diary {
                segue.diary = selectedDiary
            }
        }
    }
}

