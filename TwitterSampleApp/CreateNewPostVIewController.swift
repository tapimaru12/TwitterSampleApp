import Foundation
import UIKit
import RealmSwift

class CreateNewPostViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var postTextView: PlaceHolderTextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    
    var postButton = UIBarButtonItem()
    
    var postData = PostDataModel()
    
    // 文字が入力されているか
    var userNameHasText: Bool = false
    var postTextHasText: Bool = false
    
    private let maxLength = 140
    
    // userNameTextFieldのプレースホルダーの設定
    let attributes: [NSAttributedString.Key : Any] = [
      .font : UIFont.systemFont(ofSize: 19.0), // 文字サイズ
      .foregroundColor : UIColor.lightGray // 文字色
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        postTextView.delegate = self
        
        setUseNameLayout()
        setPostTextLayout()
        setWordCountLayout()
        setNavigationBarButton()
        setCloseButton()
        postTextView.placeHolder = "いまどうしてる？" // postTextViewにプレースホルダーを追加
    }
    
    // userNameTextFieldのレイアウト
    func setUseNameLayout() {
        userNameTextField.layer.borderColor = UIColor.gray.cgColor
        userNameTextField.layer.borderWidth = 1
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: attributes)
    }
    
    // PostTextViewのレイアウト
    func setPostTextLayout() {
        postTextView.layer.borderColor = UIColor.gray.cgColor
        postTextView.layer.borderWidth = 1
        postTextView.layer.cornerRadius = 1
        
    }
    
    // wordCountLabelのレイアウト
    func setWordCountLayout() {
        wordCountLabel.textColor = .white
        wordCountLabel.backgroundColor = .systemGreen
        wordCountLabel.layer.cornerRadius = 15
        wordCountLabel.clipsToBounds = true
    }
    
    // ナビゲーションバーに投稿ボタンを追加
    func setNavigationBarButton() {
        postButton = UIBarButtonItem(title: "投稿", style: .plain, target: self, action: #selector(saveData))
        navigationItem.rightBarButtonItem = postButton
        // 遷移直後は文字が入力されていないため投稿ボタンを無効化
        postButton.isEnabled = false
    }
    
    // 投稿ボタンの有効/無効を切り替える
    func switchPostButton() {
        // ユーザー名と投稿文の両方が空欄じゃない場合に、投稿ボタンを有効にする
        if userNameHasText == true && postTextHasText == true {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
    
    // キーボードにCloseボタンを追加
    func setCloseButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(tapCloseButton))
        toolBar.items = [closeButton]
        userNameTextField.inputAccessoryView = toolBar
        postTextView.inputAccessoryView = toolBar
    }
    
    // キーボードのCloseボタンの動き
    @objc func tapCloseButton() {
        view.endEditing(true)
    }
    
    // Realmにデータを保存する
    @objc func saveData() {
        if checkTextCount(count: postTextView.text.count) {
            // 140文字以上入力されて投稿ボタンが押された場合にエラー表示する
            let alert = UIAlertController(title: "文字数オーバー！", message: "140文字以下にしてください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else {
            let realm = try! Realm()
            // 下記2行、どちらか一つでも空欄の場合は投稿ボタンが無効になるため強制アンラップ
            postData.userName = userNameTextField.text!
            postData.postText = postTextView.text!
            try! realm.write {
                realm.add(postData)
            }
            // 投稿が完了したらホーム画面に戻る
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 投稿文が140文字以上かチェック
    func checkTextCount(count: Int) -> Bool {
        return count > 140
    }
}



extension CreateNewPostViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // ユーザー名が空欄じゃない場合＝true、空欄の場合＝false (スペースと改行が空欄と見做す)
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            userNameHasText = true
        } else {
            userNameHasText = false
        }
        
        switchPostButton()
    }
}

extension CreateNewPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.wordCountLabel.text = "\(maxLength - postTextView.text.count)"
        
        if let count = Int(wordCountLabel.text!) {
            if count <= 0 {
                wordCountLabel.backgroundColor = .systemRed
            } else if count <= 10 {
                wordCountLabel.backgroundColor = .systemYellow
            } else {
                wordCountLabel.backgroundColor = .systemGreen
            }
        }
        
        // 投稿文が空欄じゃない場合＝true、空欄の場合＝false (スペースと改行が空欄と見做す)
        if postTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            postTextHasText = true
        } else {
            postTextHasText = false
        }
        
        switchPostButton()
    }
}
