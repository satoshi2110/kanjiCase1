//
//  ResultsViewController.swift
//  kanjiCase1
//
//  Created by N S on 2025/03/10.
//

import UIKit
import RealmSwift

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // UIコンポーネント
    @IBOutlet weak var tableView: UITableView!
    
    // Realmの結果を保持する配列
    var results: Results<AssessmentResult>!
    var groupedResults: [String: [AssessmentResult]] = [:] // セッションごとにグループ化
    var sortedSessionIds: [String] = [] // 日時でソートされたセッションID
    
    // パスワード
    let correctPassword = "1234" // 正しいパスワード
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realmからデータを取得
        let realm = try! Realm()
        results = realm.objects(AssessmentResult.self).sorted(byKeyPath: "date", ascending: false)
        
        // セッションごとに結果をグループ化
        groupResultsBySession()
        
        // セッションIDを日時でソート
        sortSessionIdsByDate()
        
        // TableViewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // セッションごとに結果をグループ化する関数
    func groupResultsBySession() {
        for result in results {
            if groupedResults[result.sessionId] == nil {
                groupedResults[result.sessionId] = []
            }
            groupedResults[result.sessionId]?.append(result)
        }
    }
    
    // セッションIDを日時の降順でソートする関数
    func sortSessionIdsByDate() {
        // セッションIDを日時の降順でソート
        sortedSessionIds = groupedResults.keys.sorted { sessionId1, sessionId2 in
            guard let result1 = groupedResults[sessionId1]?.first,
                  let result2 = groupedResults[sessionId2]?.first else {
                return false
            }
            return result1.date > result2.date // 降順でソート
        }
    }
    
    // MARK: - UITableViewDataSource
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedSessionIds.count
    }
    
    // セクションヘッダーのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sessionId = sortedSessionIds[section]
        let results = groupedResults[sessionId]!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if let firstResult = results.first {
            return "セッション: \(dateFormatter.string(from: firstResult.date))"
        }
        return "セッション: \(sessionId)"
    }
    
    // セクションヘッダーのビューを返す
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        
        let titleLabel = UILabel()
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        titleLabel.textColor = .black
        titleLabel.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width - 32, height: 40)
        headerView.addSubview(titleLabel)
        
        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section // セクション番号をタグとして設定
        
        return headerView
    }
    
    // セクションヘッダーの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // セクションごとの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionId = sortedSessionIds[section]
        return groupedResults[sessionId]?.count ?? 0
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sessionId = sortedSessionIds[indexPath.section]
        if let result = groupedResults[sessionId]?[indexPath.row] {
            // セルに表示するテキスト
            let status = result.isCorrect ? "正解" : "不正解"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let dateString = dateFormatter.string(from: result.date)
            
            cell.textLabel?.text = "\(result.kanji) - \(status) (\(dateString))"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // セクションヘッダーがタップされた時の処理
    @objc func handleHeaderTap(_ gesture: UITapGestureRecognizer) {
        guard let headerView = gesture.view else { return }
        let section = headerView.tag // タップされたセクション番号を取得
        
        // セッションIDを取得
        let sessionId = sortedSessionIds[section]
        
        // パスワード入力アラートを表示
        showPasswordAlert { [weak self] in
            // パスワードが正しい場合、セッションを削除
            self?.deleteSession(sessionId: sessionId)
        }
    }
    
    // パスワード入力アラートを表示する関数
    func showPasswordAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "パスワード入力", message: "削除するにはパスワードを入力してください", preferredStyle: .alert)
        
        // パスワード入力フィールド
        alert.addTextField { textField in
            textField.placeholder = "入力してください"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true // 入力内容を隠す
        }
        
        // 確認ボタン
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { _ in
            if let password = alert.textFields?.first?.text, password == self.correctPassword {
                // パスワードが正しい場合
                completion()
            } else {
                // パスワードが間違っている場合
                self.showErrorAlert(message: "パスワードが間違っています")
            }
        }))
        
        // キャンセルボタン
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        // アラートを表示
        self.present(alert, animated: true, completion: nil)
    }
    
    // エラーアラートを表示する関数
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // セッションIDに関連するデータを削除する関数
    func deleteSession(sessionId: String) {
        let realm = try! Realm()
        
        // 該当セッションIDのデータを検索
        let resultsToDelete = realm.objects(AssessmentResult.self).filter("sessionId == %@", sessionId)
        
        // データを削除
        try! realm.write {
            realm.delete(resultsToDelete)
        }
        
        // グループ化された結果からも削除
        groupedResults.removeValue(forKey: sessionId)
        
        // セッションIDを再ソート
        sortSessionIdsByDate()
        
        // TableView を更新
        tableView.reloadData()
    }
}
