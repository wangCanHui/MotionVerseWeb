//
//  RobotView.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/20.
//

import UIKit

class RobotView: UIView, AlertProtocol {
    enum Action {
        case robot(Int, RobotModel)
    }
    struct State {
        var index: Int
    }
    @Network var baseAPI = BaseAPI()
    var dataSource: [RobotModel] = []
    var currentIndex = 0
    var completion: ((Action) -> Void)?
    var state: State
    // MARK: - Init
    required init(frame: CGRect, intial: State, completion: ((Action) -> Void)? = nil) {
        self.completion = completion
        self.state = intial
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("cannot impletion")
    }
    var view: UIView {
        self
    }
    // MARK: - Views
    private func setupViews() {
        backgroundColor = .white
        _ = titleLabel
        _ = sureButton
        _ = collectionView
        Task {
            do {
                baseAPI.baseUrl = "https://demo.deepscience.cn/poc/StreamingAssets/config.json"
                dataSource = try await $baseAPI.request()
                self.collectionView.reloadData()
                
                collectionView.selectItem(at: IndexPath(item: self.state.index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            } catch {
                print(error)
            }
            
        }
    }
    // MARK: - Button Actions
    @objc private func sureAction(_ sender: UIButton) {
        completion?(.robot(self.currentIndex, self.dataSource[self.currentIndex]))
    }
    // MARK: - Lazy UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 15, width: 120, height: 26))
        label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 28)
        label.text = "数字人更换"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        addSubview(label)
        return label
    }()
    private lazy var sureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 15 - 50, y: 5, width: 50, height: 46)
        button.addTarget(self, action: #selector(sureAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 150)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: CGRect(x: 15, y: CGRectGetMaxY(titleLabel.frame) + 10, width: UIScreen.main.bounds.width - 30, height: 150), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.backgroundColor = .white
        collectionView.register(RobotItemCell.self, forCellWithReuseIdentifier: "cellID")
        addSubview(collectionView)
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
}
extension RobotView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
extension RobotView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! RobotItemCell
        cell.config(dataSource[indexPath.item])
        return cell
    }
}

fileprivate final class RobotItemCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                nameLabel.textColor = .hex(0x69c7eb)
                robotImageView.layer.borderWidth = 1
            } else {
                nameLabel.textColor = .black
                robotImageView.layer.borderWidth = 0
            }
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("cannot impletion")
    }
    // MARK: - Views
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        _ = robotImageView
        _ = nameLabel
    }
    func config(_ model: RobotModel) {
        nameLabel.text = model.name
        robotImageView.downloadedFrom(imageurl: model.img)
    }
    // MARK: - Lazy UI
    private lazy var robotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: 70, height: 120)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.hex(0x69c7eb).cgColor
        imageView.layer.borderWidth = 0
        contentView.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(robotImageView.frame) + 10, width: 70, height: 20))
        label.textAlignment = .center
        label.text = "女青年"
        label.font = .systemFont(ofSize: 14)
        contentView.addSubview(label)
        label.isUserInteractionEnabled = true
        return label
    }()
}


extension UIImageView{
    func downloadedFrom(imageurl : String){
        if imageurl.isEmpty {
            return
        }
        let newUrl = imageurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //创建URL对象
        let url = URL(string: newUrl!)!
        //创建请求对象
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print(error.debugDescription)
            }else{
                //将图片数据赋予UIImage
                let img = UIImage(data:data!)
                
                // 这里需要改UI，需要回到主线程
                DispatchQueue.main.async {
                    self.image = img
                }
                
            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
    
}
