//
//  MainViewController.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var urlMain: String = "https://onlym.ru/api_test/test.json"
    
    // когда меняется основная модель, то мы обновляем баннеры в ячейках и фильтруем по активности
    var mainModel: MainModel? {
        didSet {
            guard oldValue?.banners != mainModel?.banners else { return }
            activeBannerCells = mainModel?.banners.filter { $0.active == true }
        }
    }
    var activeBannerCells: [BannerModel]?
    
    var scrollView = UIScrollView()
    
    func getScroll()  {
        
        let scroll = UIScrollView()
        // translatesAutoresizingMaskIntoConstraints - чтобы можено было не указывать констрейны
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scrollView = scroll
        
    }


    //результат работы замыкания будет помещен в нашу переменную
    var collectionBannersView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       
        let bannersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bannersCollectionView.isPagingEnabled = true //докручивает вью до конца
        bannersCollectionView.backgroundColor = .clear

        return bannersCollectionView
    }()
    
    let articleTableView: AutoSizingUiTableView = {
        
        let articleTableView = AutoSizingUiTableView(frame: .zero, style: .plain)
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        return articleTableView
    }()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getScroll()
        firstStart()
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    
    func firstStart() {
        
        //сохраняем первый запуск
        let tag = "firstStart"
        let isFirstLaunch = UserDefaults.standard.bool(forKey: tag)
        
        let coreData = CoreData()
        
        if isFirstLaunch == false {
            guard let url = URL(string: urlMain) else { return }
            let getData = GetService()
            
            // [self] - захватываем значение
            getData.getData(url: url) { [self] (response: MainModel?, data: Data?) in
                if let response = response {
                    mainModel = response
                    guard let data = data else { return }
                    
                    //UIApplication.delegate должен использоваться только из главного потока
                    DispatchQueue.main.async {
                        coreData.saveCoreData(data: data as NSData)
                    }
                    
                    UserDefaults.standard.set(true, forKey: tag)
                    
                    
                    DispatchQueue.main.async {
                        collectionBannersView.reloadData()
                        articleTableView.reloadData()
                    }
                }
            }
        } else {
            //UIApplication.delegate должен использоваться только из главного потока
            DispatchQueue.main.async {
                let data = coreData.fetchCoreData()
                
                let mainCoreData = try? JSONDecoder().decode(MainModel.self, from: data! as Data)
                guard mainCoreData != nil else { return }
                self.mainModel = mainCoreData
                
                self.collectionBannersView.reloadData()
                self.articleTableView.reloadData()
            }
        }
    }
    
    // функция позволяет скролить статьи (вложенные в скролвью)
    // reduce перебирает элементы, применяет к ним замыкание и записывает новые
    // viewDidLayoutSubviews() может вызываться несколько раз, во время создания иьюконтроллера + при скроле и повороте
    override func viewDidLayoutSubviews() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    // MARK: - setup objects
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(collectionBannersView)
        
        //сами для себя делегаты и датасорсы
        //dataSource вызывает обязательные методы numberOfItemsInSection и cellForRowAt нужное кол-во раз
        //delegate определяем, что функции делегата выполняются self
        collectionBannersView.delegate = self
        collectionBannersView.dataSource = self
        //register надо использовать чтобы сооббщить коллекции как создать новую ячейку перед методом forCellWithReuseIdentifier
        collectionBannersView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "bannersCollectionViewCell")
        
        scrollView.addSubview(articleTableView)
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        articleTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articlesTableViewCell")
    }
    func setupAutoLayout() {
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
      
        collectionBannersView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        collectionBannersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionBannersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionBannersView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        articleTableView.topAnchor.constraint(equalTo: collectionBannersView.bottomAnchor, constant: 10).isActive = true
        articleTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    }
    
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsNavigationBar))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavigationBar))
        
    }
    
    @objc func settingsNavigationBar() {
        
        let settingsViewController = BannerSettingsViewController()
        //modalPresentationStyle - переход модально
        settingsViewController.modalPresentationStyle = .formSheet
        
        guard let banners = mainModel?.banners else { return }
        
        settingsViewController.setData(banners: banners)
        navigationController?.present(UINavigationController(rootViewController: settingsViewController), animated: true)
        
        settingsViewController.closedSettingBanner = { banners in
            
            self.mainModel?.banners = banners
            self.collectionBannersView.reloadData()
            
            DispatchQueue.main.async {
                let coreData = CoreData()
                
                guard let data = try? JSONEncoder().encode(self.mainModel) else { return }
                coreData.saveCoreData(data: NSData(data: data))
            }
        }
    }
    
    @objc func addNavigationBar() {
        let newBannerViewController = NewBannerViewController()
        //modalPresentationStyle - переход модально
        newBannerViewController.modalPresentationStyle = .formSheet
        navigationController?.present(UINavigationController(rootViewController: newBannerViewController), animated: true)
        
        newBannerViewController.closedNewBanner = { banner, index in
            self.mainModel?.banners.insert(banner, at: index)
            self.collectionBannersView.reloadData()
            
            DispatchQueue.main.async {
                let coreData = CoreData()
              
                guard let data = try? JSONEncoder().encode(self.mainModel) else { return }
                coreData.saveCoreData(data: NSData(data: data))
            }
        }
    }
    
    // MARK: - Table and Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let activeBannerCells = activeBannerCells else { return 0 }
        return activeBannerCells.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannersCollectionViewCell", for: indexPath as IndexPath) as! BannerCollectionViewCell
        guard let banner = activeBannerCells?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.settingCellBanner(banner: banner)
        return cell
    }
    // для использования этого метода надо наследоваться у UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionBannersView.bounds.width - 10, height: collectionBannersView.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeModel = mainModel else { return 0 }
        return homeModel.articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlesTableViewCell", for: indexPath as IndexPath) as! ArticleTableViewCell
        guard let article = mainModel?.articles[indexPath.row] else { return UITableViewCell() }
        cell.settingCellArticle(article: article)
        
        return cell
    }
    
    // делаем хидер
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))

        let label = UILabel()
        
        label.font = label.font.withSize(25)

        label.frame = CGRect.init(x:5, y: 5, width: headerView.frame.width, height: headerView.frame.height)
        label.text = "Заголовок"
        headerView.addSubview(label)

        return headerView
    }
    
    // отступ от хедера до первой ячейки
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //переход по нажатию на статью
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let articleVC = ArticleDetailViewController()
        guard let article = mainModel?.articles[indexPath.row] else { return}
        articleVC.setData(article: article, articles: mainModel!.articles, indexPath: indexPath)
        navigationController?.pushViewController(articleVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

