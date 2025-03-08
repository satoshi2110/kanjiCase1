




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

    // プレゼンVCを表示する関数
    func presentDisplayViewController(setIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let displayVC = storyboard.instantiateViewController(withIdentifier: "DisplayViewController") as? DisplayViewController {
            displayVC.selectedSetIndex = setIndex
            displayVC.modalPresentationStyle = .fullScreen
            self.present(displayVC, animated: true, completion: nil)
        }
    }
}
