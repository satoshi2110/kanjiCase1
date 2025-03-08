//
//  DisplayViewController.swift
//  kanjiCase1
//
//  Created by N S on 2025/03/08.
//

import UIKit
import AVFoundation

class DisplayViewController: UIViewController {
    
    // UIコンポーネント
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // データセット
    let kanjiSets = [
        ["山", "川", "谷"], // セット1
        ["海", "森", "林"], // セット2
        ["空", "雲", "雨"], // セット3
        ["火", "風", "雷"], // セット4
        ["星", "月", "太陽"], // セット5
        ["花", "草", "木"]  // セット6
    ]
    
    let audioSets = [
        ["a1-1.mp3", "a1-2.mp3", "a1-3.mp3"], // セット1
        ["a2-1.mp3", "a2-2.mp3", "a2-3.mp3"], // セット2
        ["a3-1.mp3", "a3-2.mp3", "a3-3.mp3"], // セット3
        ["a4-1.mp3", "a4-2.mp3", "a4-3.mp3"], // セット4
        ["a5-1.mp3", "a5-2.mp3", "a5-3.mp3"], // セット5
        ["a6-1.mp3", "a6-2.mp3", "a6-3.mp3"]  // セット6
    ]
    
    let imageSets = [
        ["i1-1.png", "i1-2.png", "i1-3.png"], // セット1
        ["i2-1.png", "i2-2.png", "i2-3.png"], // セット2
        ["i3-1.png", "i3-2.png", "i3-3.png"], // セット3
        ["i4-1.png", "i4-2.png", "i4-3.png"], // セット4
        ["i5-1.png", "i5-2.png", "i5-3.png"], // セット5
        ["i6-1.png", "i6-2.png", "i6-3.png"]  // セット6
    ]
    
    // 状態管理
    var selectedSetIndex: Int = 0 // 選択されたセット番号
    var shuffledItems: [[String]] = [] // 漢字、音声、イラストのグループをシャッフルした配列
    var repeatCount: Int = 0 // 繰り返し回数（0～8）
    
    // 音声プレイヤー
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期表示
        prepareShuffledItems()
        
        // スタートボタンの設定
        startButton.setTitle("⚫️", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    // スタートボタンが押された時の処理
    @objc func startButtonPressed() {
        startButton.isHidden = true // スタートボタンを非表示にする
        displayNextItem() // 表示を開始
    }
    
    // 漢字、音声、イラストのグループを準備する関数
    func prepareShuffledItems() {
        var items: [[String]] = []
        for _ in 0..<3 { // 各アイテムを3回ずつ追加
            for i in 0..<kanjiSets[selectedSetIndex].count {
                let item = [
                    kanjiSets[selectedSetIndex][i], // 漢字
                    audioSets[selectedSetIndex][i], // 音声
                    imageSets[selectedSetIndex][i]  // イラスト
                ]
                items.append(item)
            }
        }
        shuffledItems = items.shuffled() // グループをシャッフル
    }
    
    // 次のアイテムを表示する関数
    func displayNextItem() {
        // 9回繰り返したら終了
        if repeatCount >= 9 {
            self.dismiss(animated: true, completion: nil) // プレゼンVCを閉じる
            return
        }
        
        // 現在のアイテムを取得
        let item = shuffledItems[repeatCount]
        
        // 漢字、音声、イラストを表示
        let kanji = item[0]
        let audioFileName = item[1]
        let imageName = item[2]
        
        label.text = kanji
        if selectedSetIndex < 3 {
            // セット1〜3: labelと音声を同時に提示
            playAudio(fileName: audioFileName)
            
            // 2秒後に画像を表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.label.text = ""
                self.displayImage(imageName: imageName)
                
                // 2秒後に画像を消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.imageView.image = nil
                }
            }
        } else {
            // セット4〜6: labelの1秒後に音声を提示
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playAudio(fileName: audioFileName)
                
                // 音声の1秒後に画像を表示
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.label.text = ""
                    self.displayImage(imageName: imageName)
                    
                    // 2秒後に画像を消す
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.imageView.image = nil
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.view.backgroundColor = .lightGray // 背景を黒に変更
            self.imageView.image = nil // imageViewを消す
        }
        
        // 次の表示を1秒後に実行
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.repeatCount += 1
            self.view.backgroundColor = .white // 背景を元に戻す
            self.displayNextItem()
        }
    }
    
    // 音声を再生する関数
    func playAudio(fileName: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("音声再生エラー")
            }
        }
    }
    
    // イラストを表示する関数
    func displayImage(imageName: String) {
        if let image = UIImage(named: imageName) {
            imageView.image = image
        }
    }
}
