import Foundation
import UIKit

class CreateNewPostViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var postTextView: PlaceHolderTextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    
    // userNameTextFieldのプレースホルダーの設定
    let attributes: [NSAttributedString.Key : Any] = [
      .font : UIFont.systemFont(ofSize: 19.0), // 文字サイズ
      .foregroundColor : UIColor.lightGray // 文字色
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let postButton = UIBarButtonItem(title: "投稿", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = postButton
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
}

