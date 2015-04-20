//
//  ViewController.swift
//  iOS_4-4
//
//  Created by 松下慶大 on 2015/04/01.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    let backgroundView = UIView()
    let textField = UITextField()
    let textView = UITextView()
    let headerBackView = UIView()
    
    var tweetArray:Array<Dictionary<String, String>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        headerScrollView.delegate = self
        headerScrollView.contentSize = CGSize(width: self.view.frame.width*2, height: headerScrollView.frame.height)
        headerScrollView.pagingEnabled = true
        
        setProfileImageView()
        let profileLabel = makeProfileLabel()
        headerScrollView.addSubview(profileLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//==================================テーブルビュ===========================================
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell") as UITableViewCell
        
        var nameLabel = cell.viewWithTag(1) as UILabel
        nameLabel.text = tweetArray[indexPath.row]["name"]
        nameLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        
        var textLabel = cell.viewWithTag(2) as UILabel
        textLabel.text = tweetArray[indexPath.row]["text"]
        textLabel.font = UIFont(name: "HirakakuProN-W6", size: 18)
        textLabel.numberOfLines = 0
        
        var timeLabel = cell.viewWithTag(3) as UILabel
        timeLabel.text = tweetArray[indexPath.row]["time"]
        timeLabel.font = UIFont(name: "HirakakuProN-W3", size: 10)
        timeLabel.textColor = UIColor.grayColor()
        
        var myImageView = cell.viewWithTag(4) as UIImageView
        myImageView.image = UIImage(named: "pug")
        myImageView.layer.cornerRadius = 3
        myImageView.layer.masksToBounds = true
        
        println("セルの内容設定")
        
        return cell
    }
    
    
//=================================ヘッダーの作成=====================================
    
    func setProfileImageView() {
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func makeProfileLabel() -> UILabel {
        let profileLabel = UILabel()
        profileLabel.frame.size = CGSizeMake(200, 100)
        profileLabel.center.x = self.view.frame.width*3/2
        profileLabel.center.y = headerScrollView.center.y-64
        profileLabel.text = "🍄だよ。好きなきのこはしめじで、嫌いなきのこはアミウダケです。よろしくね。"
        profileLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        profileLabel.textColor = UIColor.whiteColor()
        profileLabel.textAlignment = NSTextAlignment.Center
        profileLabel.numberOfLines = 0
        return profileLabel
    }
    
    
    //スクロールビュー
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headerScrollView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: headerScrollView.contentOffset.x * 0.6 / 375)
        println("contentOffset: \(headerScrollView.contentOffset)")
    }
    
    
//================================投稿画面の作成========================================
    
    //-------------------投稿画面表示のボタンが押された時の処理---------------------
    @IBAction func tapTweetBtn(sender: UIButton) {
        
        let backgroundView = makeBackgroundView()
        self.view.addSubview(backgroundView)
        
        let tweetView = makeTweetView()
        backgroundView.addSubview(tweetView)
        
        let textFiled = makeTextField()
        tweetView.addSubview(textFiled)
        
        let textView = makeTextView()
        tweetView.addSubview(textView)
        
        let nameLabel = makeLabel("名前", y: 5)
        tweetView.addSubview(nameLabel)
        
        let tweetLabel = makeLabel("ツイート内容", y: 85)
        tweetView.addSubview(tweetLabel)
        
        let submitBtn = makeSubmitBtn()
        tweetView.addSubview(submitBtn)
        
        let cancelBtn = makeCancelBtn(tweetView)
        tweetView.addSubview(cancelBtn)
        
    }
    
    //------------------------イベント---------------------------
    
    func tappedCancelBtn(sender :AnyObject){
        backgroundView.removeFromSuperview()
    }
    
    func tappedSubmitBtn(sender :AnyObject){
        
        if textField.text.isEmpty || textView.text.isEmpty{
            var alertController = UIAlertController(title: "Error", message: "'name' or 'text' is empty", preferredStyle: UIAlertControllerStyle.Alert)
            var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            var name = textField.text
            var tweet = textView.text
            println("名前:\(name)、ツイート内容:\(tweet)")
            
            var tweetDic:Dictionary<String, String> = [:]
            tweetDic["name"] = textField.text
            tweetDic["text"] = textView.text
            tweetDic["time"] = getCurrentTime()
            tweetArray.insert(tweetDic, atIndex: 0)
            
            backgroundView.removeFromSuperview()
            textField.text = ""
            textView.text = ""
            tableView.reloadData()
        }
    }
    
    //------------------------------現在時間取得---------------------------------
    func getCurrentTime() -> String{
        var now = NSDate() // 現在日時の取得
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .LongStyle
        var currentTime = dateFormatter.stringFromDate(now)
        return currentTime
    }
    
    //---------------------------投稿画面で使用する部品の生成-----------------------
    func makeBackgroundView() -> UIView {
        backgroundView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backgroundView
    }
    
    func makeTweetView() -> UIView {
        let tweetView = UIView()
        tweetView.frame.size = CGSizeMake(300, 300)
        tweetView.center.x = self.view.center.x
        tweetView.center.y = 250
        tweetView.backgroundColor = UIColor.whiteColor()
        tweetView.layer.shadowOpacity = 1.0
        tweetView.layer.cornerRadius = 3
        return tweetView
    }
    
    func makeTextField() -> UITextField {
        textField.frame = CGRectMake(10, 40, 280, 40)
        textField.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        return textField
    }
    
    func makeTextView() ->UITextView{
        textView.frame = CGRectMake(10, 120, 280, 110)
        textView.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).CGColor
        textView.layer.borderWidth = 1
        return textView
    }
    
    func makeLabel(text:String, y:CGFloat)->UILabel{
        var label = UILabel(frame: CGRectMake(10, y, 280, 40))
        label.text = text
        label.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        return label
    }
    
    func makeCancelBtn(tweetView:UIView) -> UIButton{
        let cancelBtn = UIButton()
        cancelBtn.frame.size = CGSizeMake(20, 20)
        cancelBtn.center.x = tweetView.frame.width-15
        cancelBtn.center.y = 15
        cancelBtn.setBackgroundImage(UIImage(named: "cancel.png"), forState: .Normal)
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.width/2
        cancelBtn.addTarget(self, action: "tappedCancelBtn:", forControlEvents:.TouchUpInside)
        return cancelBtn
    }
    
    func makeSubmitBtn()->UIButton{
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(10, 250, 280, 40)
        submitBtn.setTitle("送信", forState: .Normal)
        submitBtn.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        submitBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        submitBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        submitBtn.layer.cornerRadius = 7
        submitBtn.addTarget(self, action: "tappedSubmitBtn:", forControlEvents:.TouchUpInside)
        return submitBtn
    }

}