import Foundation
import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let floatingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    var postDataList: [PostDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postDataList.reverse()
        tableView.delegate = self
        tableView.dataSource = self
        // xibを登録
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")
        setFabLayout(fab: self.floatingButton)
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // データの取得
        setPostData()
        // 取得したデータをtableViewに反映させる
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 70,
                                      y: view.frame.size.height - 100,
                                      width: 60, height: 60)
    }
    
    // 投稿された全データをpostDataListに格納
    func setPostData() {
        let realm = try! Realm()
        let result = realm.objects(PostDataModel.self)
        postDataList = Array(result)
        // 投稿を上から新しい順で表示するために配列を逆順にする
        postDataList.reverse()
    }
    
    // フローティングボタンのレイアウト設定
    func setFabLayout(fab: UIButton) {
        fab.layer.masksToBounds = true
        fab.layer.cornerRadius = 30
        fab.backgroundColor = .systemGreen
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .medium))
        fab.setImage(image, for: .normal)
        fab.tintColor = .white
    }
    
    // フローティングボタンの動き
    @objc private func didTapButton() {
        // MAin.storyboardをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createNewPostViewController = storyboard.instantiateViewController(identifier: "createNewPostView") as! CreateNewPostViewController
        navigationController?.pushViewController(createNewPostViewController, animated: true)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataList.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let postDataMode: PostDataModel = postDataList[indexPath.row]
        cell.userNameLabel.text = postDataMode.userName
        cell.postTextLabel.text = postDataMode.postText
        return cell
    }
    
    // セルが選択された時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // セルをスワイプして削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetPost = postDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetPost)
        }
        postDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
