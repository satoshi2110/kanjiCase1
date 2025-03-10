//
//  AssessmentResult.swift
//  kanjiCase1
//
//  Created by N S on 2025/03/10.
//

import Foundation
import RealmSwift

import RealmSwift

class AssessmentResult: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString // 一意のID
    @Persisted var sessionId: String = "" // セッションID
    @Persisted var kanji: String = "" // 表示された漢字
    @Persisted var isCorrect: Bool = false // 正解かどうか
    @Persisted var date: Date = Date() // 回答日時
}
