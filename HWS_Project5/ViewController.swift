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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    //すべての文字列から1つのランダムなアイテムを選択
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        //UIAlertActionをUIAlertControllerに追加
        ac.addAction(submitAction)
        present(ac,  animated: true)
        
    }
    
   
    func isPossible(word: String) -> Bool  {
        
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(word: String) -> Bool  {
        //wordがusedWordsに含まれていない → true
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool  {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    
    func submit(answer: String){
        
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage:  String
        
        
        //wordのチェック
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    
                    //usedWords配列の先頭に追加
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                //チェックから外れた場合の処理
                } else { //isReal
                    errorTitle = "word not recogniized"
                    errorMessage = "You can't make them"
                }
                
            } else { //isOriginal
                errorTitle = "word already used"
                errorMessage = "more oriiginal"
            }
        
        } else { //isPossible
            guard let title = title?.lowercased() else { return }
            errorTitle = "word not possible"
            errorMessage = "You can't use \(title)"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
         
        
    }
    

}

