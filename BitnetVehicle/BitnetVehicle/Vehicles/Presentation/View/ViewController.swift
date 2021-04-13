//
//  ViewController.swift
//  BitnetVehicle
//
//  Created by József Jagicza on 2021. 04. 08..
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import SwiftUI
import RxDataSources

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var vehicleList: BehaviorRelay<[Vehicle]> = BehaviorRelay(value: [])
    
    private let tableView = UITableView()
    private let cellIdentifier = "cellIdentifier"
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    private var isDownloaded = false
    @IBOutlet weak var splashView: UIView!
    
    static let startLoadingOffset: CGFloat = 20.0
    private var page = 1
    @IBOutlet weak var listIsEmptyLabel: UILabel!
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for university"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashView.layer.zPosition = 0
        
        tableView.rx.setDelegate(self)
            .disposed(by:disposeBag)
        
        self.removeSplashView()
        
        configureProperties()
        configureLayout()
        fetchData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if (isDownloaded == true) {
            return
        }
        if distanceFromBottom == height {
            print(" you reached end of the table")
            isDownloaded = true
            self.page += 1
            
            fetchData()
        }
    }
    
    func removeSplashView() {
        UIView.animate(withDuration: 2, delay: 3, options: .transitionCurlDown, animations: {
            self.splashView.alpha = 0
        }) { _ in
            self.splashView.removeFromSuperview()
        }
    }
    
    func fetchData() {
        if (self.page > 199) {
            return
        }
        let request =  GeneralRequest(format: "json", page: String(format: "%ld", self.page))
        let result : Observable<[Vehicle]> = self.apiClient.send(apiRequest: request)
        
        self.tableView.dataSource = nil
        isDownloaded = false
        result.subscribe { event in
            self.vehicleList.accept(self.vehicleList.value + event)
        }
        if (vehicleList.value.count == 0) {
            self.tableView.isHidden = true
            self.listIsEmptyLabel.isHidden = false
        }
        else {
            self.tableView.isHidden = false
            self.listIsEmptyLabel.isHidden = true
            vehicleList.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: VehicleCell.self)) { ( row, vehicle, cell) in
                cell.nameLabel?.text = vehicle.mfrCommonName ?? vehicle.mfrName
                cell.typeLabel?.text = self.settingVehicleType(vehicle: vehicle)
                cell.textLabel?.adjustsFontSizeToFitWidth = true

            }
        }
    }
    
    private func configureProperties() {
        tableView.register(UINib(nibName: "VehicleCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        navigationItem.title = "Bitnet Vehicle"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
        tableView.layer.zPosition = -1
    }
    
    private func settingVehicleType (vehicle: Vehicle) -> String {
        var resultStr = ""
        for vehicleType in vehicle.vehicleType ?? [] {
            resultStr.append(", " + vehicleType.name)
        }
        if (resultStr.count > 2) {
            resultStr.removeFirst()
            resultStr.removeFirst()
        }
        return resultStr
    }
}
