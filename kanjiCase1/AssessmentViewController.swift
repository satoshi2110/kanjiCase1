//
//  AssessmentViewController.swift
//  kanjiCase1
//
//  Created by N S on 2025/03/09.
//

import UIKit
import RealmSwift

class AssessmentViewController: UIViewController {
    // UIコンポーネント
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var correctButton: UIButton! // 正解ボタン
    @IBOutlet weak var incorrectButton: UIButton! // 不正解ボタン
    
    // データセット
    let kanjiSets = [
        ["毛", "母", "風"], // セット1
        ["船", "鳥", "夜"], // セット2
        ["光", "馬", "麦"], // セット3
        ["父", "矢", "海"], // セット4
        ["雪", "魚", "岩"], // セット5
        ["肉", "時", "体"]  // セット6
    ]
    
    // 状態管理
    var assessmentIndex: Int = 0 // アセスメントのインデックス
    var shuffledKanjis: [String] = [] // シャッフルされた漢字のリスト
    var currentIndex: Int = 0 // 現在表示中の漢字のインデックス
    var timer: Timer? // タイマー
    var progress: Float = 0.0 // プログレスの進捗
    let timerDuration: TimeInterval = 10 // タイマーの期間（秒）
    let realm = try! Realm() // Realm インスタンス
    var sessionId: String = UUID().uuidString // セッションIDを生成
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期表示
        prepareShuffledKanjis()
        displayCurrentKanji()
        
        // ボタンの設定
        correctButton.setTitle("正解", for: .normal)
        correctButton.addTarget(self, action: #selector(correctButtonPressed), for: .touchUpInside)
        
        incorrectButton.setTitle("不正解", for: .normal)
        incorrectButton.addTarget(self, action: #selector(incorrectButtonPressed), for: .touchUpInside)
        
        // プログレスビューの設定
        progressView.progress = 0.0 // 初期値
        
        // タイマーを開始
        startTimer()
    }
    
    // 漢字をシャッフルして準備する関数
    func prepareShuffledKanjis() {
        var kanjis: [String] = []
        for _ in 0..<3 { // 各漢字を3回ずつ追加
            kanjis.append(contentsOf: kanjiSets[assessmentIndex]) // assessmentIndexを使用
        }
        shuffledKanjis = kanjis.shuffled() // 漢字をシャッフル
    }
    
    // 現在の漢字を表示する関数
    func displayCurrentKanji() {
        if currentIndex < shuffledKanjis.count {
            label.text = shuffledKanjis[currentIndex]
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 次の漢字を表示する関数
    func displayNextKanji() {
        // 漢字を消して背景色を変更
        label.text = ""
        changeBackgroundColor()
        
        // 1秒後に次の漢字を表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.resetBackgroundColor()
            self.currentIndex += 1
            self.displayCurrentKanji()
        }
    }
    
    // 背景色を変更する関数
    func changeBackgroundColor() {
        if assessmentIndex < 3 {
            self.view.backgroundColor = .lightGray // セット1〜3: 薄い灰色
        } else {
            self.view.backgroundColor = .darkGray // セット4〜6: 濃い灰色
        }
    }
    
    // 背景色を元に戻す関数
    func resetBackgroundColor() {
        self.view.backgroundColor = .white // 背景色を白に戻す
    }
    
    // タイマーを開始する関数
    func startTimer() {
        // 既存のタイマーを停止
        stopTimer()
        
        // プログレスをリセット
        progress = 0.0
        progressView.progress = progress
        
        // 新しいタイマーを開始
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateProgress()
        }
    }
    
    // プログレスを更新する関数
    func updateProgress() {
        progress += Float(0.1 / timerDuration) // 0.1秒ごとに進捗を更新
        progressView.progress = progress
        
        // タイマーが終了したら次の漢字を表示
        if progress >= 1.0 {
            stopTimer()
            saveResult(isCorrect: false) // 不正解として保存
            print("不正解...")
            displayNextKanji()
            startTimer()
        }
    }
    
    // タイマーを停止する関数
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 結果を保存する関数
    func saveResult(isCorrect: Bool) {
        let result = AssessmentResult()
        result.kanji = shuffledKanjis[currentIndex] // 現在表示されている漢字
        result.isCorrect = isCorrect // 正解か不正解か
        result.date = Date() // 現在の日時
        result.sessionId = sessionId // セッションIDを設定
        
        try! realm.write {
            realm.add(result) // Realm に保存
        }
    }
    
    // 正解ボタンが押された時の処理
    @objc func correctButtonPressed() {
        saveResult(isCorrect: true) // 正解として保存
        print("正解！")
        displayNextKanji()
        startTimer()
    }
    
    // 不正解ボタンが押された時の処理
    @objc func incorrectButtonPressed() {
        saveResult(isCorrect: false) // 不正解として保存
        print("不正解...")
        displayNextKanji()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 画面が閉じられる時にタイマーを停止
        stopTimer()
    }
}
