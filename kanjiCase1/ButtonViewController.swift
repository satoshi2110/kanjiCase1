




import UIKit

class ButtonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面の背景色を設定
        view.backgroundColor = .white
    }
    
    // セット選択ボタンのアクション
    @IBAction func button1Pressed(_ sender: UIButton) {
        presentDisplayViewController(setIndex: 0)
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        presentDisplayViewController(setIndex: 1)
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        presentDisplayViewController(setIndex: 2)
    }
    
    @IBAction func button4Pressed(_ sender: UIButton) {
        presentDisplayViewController(setIndex: 3)
    }
    
    @IBAction func button5Pressed(_ sender: UIButton) {
        presentDisplayViewController(setIndex: 4)
    }
    
    @IBAction func button6Pressed(_ sender: UIButton) {
        presentDisplayViewController(setIndex: 5)
    }
    
    // 新しいボタンのアクション
    @IBAction func assessment1Pressed(_ sender: UIButton) {
        presentAssessmentViewController(assessmentIndex: 0)
    }
    
    @IBAction func assessment2Pressed(_ sender: UIButton) {
        presentAssessmentViewController(assessmentIndex: 1)
    }
    
    @IBAction func assessment3Pressed(_ sender: UIButton) {
        presentAssessmentViewController(assessmentIndex: 2)
    }
    
    @IBAction func assessment4Pressed(_ sender: UIButton) {
        presentAssessmentViewController(assessmentIndex: 3)
    }
    
    @IBAction func assessment5Pressed(_ sender: UIButton) {
        presentAssessmentViewController(assessmentIndex: 4)
    }
    
    @IBAction func assessment6Pressed(_ sender: UIButton) {
        presentAssessmentViewController(assessmentIndex: 5)
    }
    
    // 「結果を表示」ボタンのアクション
    @IBAction func showResultsButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultsVC = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController {
            // ナビゲーションコントローラーが存在するか確認
            if let navigationController = self.navigationController {
                navigationController.pushViewController(resultsVC, animated: true)
            } else {
                print("Error: Navigation controller is nil")
            }
        }
    }
    
    // プレゼンVCを表示する関数
    func presentDisplayViewController(setIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let displayVC = storyboard.instantiateViewController(withIdentifier: "DisplayViewController") as? DisplayViewController {
            displayVC.selectedSetIndex = setIndex
            displayVC.modalPresentationStyle = .fullScreen
            self.present(displayVC, animated: true, completion: nil)
        }
    }
    
    // アセスメントVCを表示する関数
    func presentAssessmentViewController(assessmentIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let assessmentVC = storyboard.instantiateViewController(withIdentifier: "AssessmentViewController") as? AssessmentViewController {
            assessmentVC.assessmentIndex = assessmentIndex // assessmentIndexを渡す
            assessmentVC.modalPresentationStyle = .fullScreen
            self.present(assessmentVC, animated: true, completion: nil)
        }
    }
}
