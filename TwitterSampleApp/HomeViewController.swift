import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var postDataList: [PostDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // xibを登録
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")
        setPostData()
    }
    
    // 投稿リスト
    func setPostData() {
        for i in 1...5 {
            let postDataModel = PostDataModel(userName: "\(i)番目の人", postText: "HelloこんいちはHelloこんいちはHelloこんいちはHelloこんいちはHelloこんいちはHelloこんいちはHelloこんいちは")
            postDataList.append(postDataModel)
        }
    }
}


extension HomeViewController: UITableViewDataSource {
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
}
