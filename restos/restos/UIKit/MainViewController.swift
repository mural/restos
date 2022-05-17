//
//  ViewController.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/17/22.
//

import UIKit
import Combine

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @UsesAutoLayout
    private var tableView = UITableView()
    private var cancellables: Set<AnyCancellable> = []
    private var restaurantViewModel: RestaurantViewModel
    private var restaurantRepository: RestaurantRepositoryProtocol
    
    private let cellId = "cellId"
    private var cellData = [RestaurantRowViewModel]()
    
    required init?(restaurantViewModel: RestaurantViewModel, restaurantRepository: RestaurantRepositoryProtocol) {
        self.restaurantViewModel = restaurantViewModel
        self.restaurantRepository = restaurantRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpNavigation()
        
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        restaurantViewModel.objectWillChange.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.render()
        }.store(in: &cancellables)
        
        restaurantViewModel.fetchRestos()
    }
    
    func setUpNavigation() {
        navigationItem.title = "Restos"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "barColor")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    private func render() {
        switch restaurantViewModel.state {
        case .idle:
            break
            
        case .loading:
            let loadingLabel = UILabel.createTitleLabel(text: "Loading, please wait...")
            loadingLabel.frame = view.bounds
            removeAllSubViewsFromSuperView()
            view.addSubview(loadingLabel)
            break
            
        case .failure:
            let errorLabel = UILabel.createTitleLabel(text: "There was an error, please try again later...")
            errorLabel.frame = view.bounds
            removeAllSubViewsFromSuperView()
            view.addSubview(errorLabel)
            break
            
        case .success(let data):
            cellData = data
            removeAllSubViewsFromSuperView()
            view.addSubview(tableView)
            
            tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 150
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RestaurantCell
        let restaurantRowViewModel = cellData[indexPath.row]
        cell.restaurantRowViewModel = restaurantRowViewModel
        cell.favoriteViewModel = restaurantRowViewModel.createFavoriteViewModel(restaurantRepository: restaurantRepository)
        cell.accessibilityIdentifier = restaurantRowViewModel.name
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onCellClicked(restaurantRowViewModel: cellData[indexPath.row])
    }
    
    func onCellClicked(restaurantRowViewModel: RestaurantRowViewModel) {
        let detailViewController = DetailViewController(restaurantRowViewModel: restaurantRowViewModel)
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
    func removeAllSubViewsFromSuperView() {
        for subUIView in view.subviews as [UIView] {
            subUIView.removeFromSuperview()
        }
    }
    
}
