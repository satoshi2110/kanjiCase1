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
        ["audio1-1.mp3", "audio1-2.mp3", "audio1-3.mp3"], // セット1
        ["audio2-1.mp3", "audio2-2.mp3", "audio2-3.mp3"], // セット2
        ["audio3-1.mp3", "audio3-2.mp3", "audio3-3.mp3"], // セット3
        ["audio4-1.mp3", "audio4-2.mp3", "audio4-3.mp3"], // セット4
        ["audio5-1.mp3", "audio5-2.mp3", "audio5-3.mp3"], // セット5
        ["audio6-1.mp3", "audio6-2.mp3", "audio6-3.mp3"]  // セット6
    ]
    
    let imageSets = [
        ["image1-1.png", "image1-2.png", "image1-3.png"], // セット1
        ["image2-1.png", "image2-2.png", "image2-3.png"], // セット2
        ["image3-1.png", "image3-2.png", "image3-3.png"], // セット3
        ["image4-1.png", "image4-2.png", "image4-3.png"], // セット4
        ["image5-1.png", "image5-2.png", "image5-3.png"], // セット5
        ["image6-1.png", "image6-2.png", "image6-3.png"]  // セット6
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
        displayNextItem()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playAudio(fileName: audioFileName)
            self.label.text = "" // labelを消す
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.displayImage(imageName: imageName)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.view.backgroundColor = .darkGray // 背景を黒に変更
            self.imageView.image = nil // imageViewを消す
        }
        
        // 次の表示を1秒後に実行
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
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
