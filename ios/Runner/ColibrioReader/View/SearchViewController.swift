//
//  SearchViewController.swift
//  SCOOP
//
//  Created by Gramedia on 24/02/23.
//

import UIKit
import ColibrioReader

protocol SearchDelegateController:AnyObject{
    func setSearch(query:ColibrioReader.ReaderDocumentSearchQuery,annotation:ReaderViewAnnotationLayer)
    func isEmpty(value:Bool)
}

class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    lazy var SearchBar: UISearchController = {
           let sb = UISearchController()
           sb.searchBar.placeholder = "Enter the movie name"
           sb.searchBar.searchBarStyle = .minimal
           return sb
       }()
    
    private var  tableView:UITableView = {
        let tableView = UITableView()

        return tableView
    }()
    
    var dataResult:[ColibrioReader.SearchResultItem] = [ColibrioReader.SearchResultItem]()
    var delegate:SearchDelegateController?
    var readingSystemEngine:ReadingSystemEngine
    var isFirsttime:Bool = true
    init(readingSystemEngine: ReadingSystemEngine) {
        self.readingSystemEngine = readingSystemEngine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let valueSearch = UserDefaults.standard.value(forKey: "keywordSearch") as? String ?? ""
        search(query: valueSearch)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    private func setupView(){
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        
        let textField = UITextField()
        textField.bordersWidth = 1.0
        textField.bordersColor = .black
        textField.cornersRadius = 12
        textField.placeholder = "Search text"
        textField.clearButtonMode = .always
        textField.setPadding(left: 16)
        textField.textColor = .black
        view.backgroundColor = .white
        
        textField.delegate = self
        //self.navigationController?.navigationItem.titleView = textField
        view.addSubview(textField)
        textField.snp.makeConstraints{ make in
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            make.top.equalTo(view.snp.top).offset(12)
            make.height.equalTo(48)
        }
        
        var verticalStackview = UIStackView()
        verticalStackview.axis = .vertical
        verticalStackview.alignment = .center
        verticalStackview.spacing = 8
        //verticalStackview.distribution
        view.addSubview(verticalStackview)
        
        verticalStackview.snp.makeConstraints{ make in
            make.top.equalTo(textField.snp.bottom).offset(UIScreen.maxHeight * 0.175)
            make.centerX.equalTo(view.snp.centerX)
            
        }
        
        let imageViewData = UIImageView()
        let imageCleaarConfiguration = UIImage.SymbolConfiguration(pointSize: 56, weight: .bold, scale: .medium)
        imageViewData.image = UIImage(systemName: "doc.text.magnifyingglass",withConfiguration: imageCleaarConfiguration)
        imageViewData.tintColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
        imageViewData.snp.makeConstraints{ make in
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        verticalStackview.addArrangedSubview(imageViewData)

        let textLabel = UILabel()
        textLabel.text = "Hasil pencarian tidak ditemukan"
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: "Nunito", size: 16)
        verticalStackview.addArrangedSubview(textLabel)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(textField.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        
    }

}

extension SearchViewController:UISearchBarDelegate{
}

extension SearchViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(query: textField.text ?? "")
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        search(query: textField.text ?? "")
//    }
    
    private func search(query:String){
        deleteAnnotationSearch()
        var annotationLayer = readingSystemEngine.readerView.createAnnotationLayer()
         annotationLayer.options = ReaderViewAnnotationLayerOptions(layerStyle: ["mix-blend-mode": "multiply"])
         annotationLayer.defaultAnnotationOptions = ReaderViewAnnotationOptions(rangeStyle: ["background-color": "lightblue"])
        
         let readerDocumentSearch = readingSystemEngine.readerDocumentSearch
        
         // Create the query
         let textQuery = readerDocumentSearch.createTextQuery(queryString: query)
        
         // Create a search agent that will highlight all matches using the annotation layer.
         let searchAgent = readerDocumentSearch.createReaderViewSearchAgent(annotationLayer: annotationLayer)
         UserDefaults.standard.setValue(query, forKey: "keywordSearch")
         searchAgent.setSearchQuery(query: textQuery)
        delegate?.setSearch(query: textQuery, annotation: annotationLayer)
        let dataArray = textQuery.execute(readerDocuments: readingSystemEngine.readerView.readerDocuments)
        dataArray.takeRemaining{ result in
            switch result{
            case .success(let data):
                self.isFirsttime = false
                if data.isEmpty {
                    self.delegate?.isEmpty(value:true)
                    self.tableView.isHidden = true
                } else {
                    self.delegate?.isEmpty(value:false)
                    self.tableView.isHidden = false
                    self.dataResult = data
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        do{
            try readingSystemEngine.readerView.annotationLayers?.forEach{ annotationLayer in
               try readingSystemEngine.readerView.destroyAnnotationLayer(annotationLayer)
            }
            self.delegate?.isEmpty(value: true)
            return true
        } catch {
            return false
        }
        
        
    }
    
    func deleteAnnotationSearch(){
        do{
            try readingSystemEngine.readerView.annotationLayers?.forEach{ annotationLayer in
               try readingSystemEngine.readerView.destroyAnnotationLayer(annotationLayer)
            }
            
        } catch {
            
        }
    }
}
extension SearchViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFirsttime {
            return 0
        } else {
            if dataResult.isEmpty {
                return 1
            } else {
                return dataResult.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataResult.isEmpty {
            
            let tableCell:UITableViewCell = UITableViewCell()
            
            let imageCleaarConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .bold, scale: .medium)
            
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "list.bullet.clipboard.fill",withConfiguration: imageCleaarConfiguration)
            tableCell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints{ make in
                make.centerX.equalTo(tableCell.contentView)
                make.top.equalTo(tableCell.contentView.snp.top).offset(12)
            }
            let textLabel = UILabel()
            textLabel.text = "Hasil pencarian kosong"
            textLabel.textAlignment = .center
            textLabel.font = UIFont(name: "Nunito", size: 16)
            tableCell.contentView.addSubview(textLabel)
            textLabel.snp.makeConstraints{ make in
                make.leading.equalTo(tableCell.contentView.snp.leading).offset(32)
                make.trailing.equalTo(tableCell.contentView.snp.trailing).offset(-32)
                make.top.equalTo(imageView.snp.bottom).offset(12)
                make.bottom.equalTo(tableCell.contentView.snp.bottom)
            }
            return tableCell
        } else {
            if (indexPath.row % 2) == 0 {
                var tableCell:UITableViewCell = UITableViewCell()
                tableCell.textLabel?.text = "\(dataResult[indexPath.row].textBefore) \(dataResult[indexPath.row].matchingText)"
                tableCell.textLabel?.numberOfLines = 2
                tableCell.textLabel?.textColor = .black
                tableCell.contentView.backgroundColor = .init(red: 245/256, green: 245/256, blue: 245/256, alpha: 1)
                return tableCell
            } else {
                var tableCell:UITableViewCell = UITableViewCell()
                tableCell.textLabel?.text = "\(dataResult[indexPath.row].textBefore) \(dataResult[indexPath.row].matchingText)"
                tableCell.textLabel?.textColor = .black
                tableCell.contentView.backgroundColor = .white
                tableCell.textLabel?.numberOfLines = 2
                return tableCell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !dataResult.isEmpty{
            readingSystemEngine.readerView.goTo(locator: dataResult[indexPath.row].locator){ result in
                switch result{
                case .success(_):
                    
                    print("Success")
                    //self.dismiss(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
}
