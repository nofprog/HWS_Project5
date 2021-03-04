//
//  ViewController.swift
//  HWS_Project5
//
//  Created by J on 2021/03/04.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start.txtの場所を指定
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            //startWordsURLに格納されたファイルをString型にキャスト
            //try? → エラーが投げられたらnilを返す
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                //改行(\"n")が見つかったら文字列を分割して配列に入れる
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()


    }
    
    //すべての文字列から1つのランダムなアイテムを選択
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }


}

