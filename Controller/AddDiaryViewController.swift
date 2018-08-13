//
//  AddDiaryViewController.swift
//  MyGoodDiary
//
//  Created by Bosh on 2018/6/6.
//  Copyright © 2018年 bosh. All rights reserved.
//

import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var articleTextView: UITextView!
    
    var datePicker = UIDatePicker()
    var imagerPicker = UIImagePickerController()
    var selectedImage:UIImage?
    let realm = try! Realm()
    let diary = Diary()
    var diaryData:Diary?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        setupArticleTextView()
        setupImagePicker()
        showSelectedDiary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - View init
    
    func setupArticleTextView() {
        articleTextView.delegate = self
        articleTextView.text = "Article"
        articleTextView.textColor = UIColor.lightGray
    }
    
    func setupImagePicker() {
        imagerPicker.delegate = self
        imagerPicker.sourceType = UIImagePickerControllerSourceType.camera
        imagerPicker.allowsEditing = true
    }
    
    func showSelectedDiary()  {
        if let editdiaryData = diaryData {
            titleTextField.text = editdiaryData.title
            dateTextField.text = editdiaryData.date
            addImageView.image = UIImage(contentsOfFile: NSHomeDirectory().appending("/Documents/\(editdiaryData.image)"))
            articleTextView.text = editdiaryData.article
        }
    }
    
    //MARK: - Save Data
    
    @IBAction func doneBarButtonItem(_ sender: UIBarButtonItem) {
        if let showTitle = titleTextField.text,
            let showDate = dateTextField.text,
            let showArticle = articleTextView.text,
            let selectedImage = selectedImage {
            if let imagePath = saveImageToDocumentDirectory(diaryImage: selectedImage) {
                if diaryData != nil {
                    // Updata Exist Data
                    try! realm.write {
                        diaryData?.title = showTitle
                        diaryData?.date = showDate
                        diaryData?.article = showArticle
                        diaryData?.image = imagePath
                    }
                } else {
                    // Add New Data
                    diary.title = showTitle
                    diary.date = showDate
                    diary.article = showArticle
                    diary.image = imagePath
                    
                    realm.beginWrite()
                    realm.add(diary)
                    try! realm.commitWrite()
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveImageToDocumentDirectory(diaryImage:UIImage) -> String? {
        let directoryPath = NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath){
            do{
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
        
        let timeInterval = Date().timeIntervalSince1970
        let fileName = ("\(timeInterval).jpg")
        let filePath = directoryPath.appending(fileName)
        let url = URL(fileURLWithPath: filePath)
        do{
            try UIImageJPEGRepresentation(diaryImage, 0.7)?.write(to: url, options: .atomic)
            return fileName
        }catch{
            print(error)
            return nil
        }
    }
    
    //MARK: - Camera and image
    
    @IBAction func cameraButton(_ sender: UIButton) {
        self.present(imagerPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagerPicker.dismiss(animated: true, completion: nil)
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        addImageView.image = selectedImage
    }
    
    // MARK: - DatePicker
    
    func createDatePicker(){
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([donebutton], animated: false)
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func dateDonePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: datePicker.date)
        dateTextField.text = dateString
        dateTextField.resignFirstResponder()
    }
    
    //MARK: - KeyBoard
    
    @objc func keyboardDidShow(notification:NSNotification){
        if articleTextView.isFirstResponder {
            if self.view.frame.origin.y == 0 {
                if  let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - ChangeTextViewColor
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  articleTextView.textColor == UIColor.lightGray,
            diaryData?.article != nil {
            articleTextView.text = diaryData?.article
            articleTextView.textColor = UIColor.black
        }else{
            articleTextView.text = nil
            articleTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if articleTextView.text.isEmpty {
            //Display title
            articleTextView.text = "Article"
            //Chagne title color Gray
            articleTextView.textColor = UIColor.lightGray
        }
    }
}
