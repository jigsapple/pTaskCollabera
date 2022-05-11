//
//  DashboardViewController.swift
//  pTaskCollabera
//
//  Created by Jignesh on 11/05/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import EventKit

class DashboardViewController: UIViewController {

    private var viewModel = DashboardViewModel()
    private var bag = DisposeBag()
    lazy var tableView : UITableView = {
        let tblView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tblView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
        self.navigationItem.hidesBackButton = true
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        let clearAll = UIBarButtonItem(title: "ClearAll", style: .done, target: self, action: #selector(onTapClearAll))
        self.navigationItem.rightBarButtonItems = [clearAll, add]
        self.view.addSubview(tableView)
        
        viewModel.fetchEvents()
        bindTableView()
    }
    
    @objc func onTapAdd() {
        //let user = User(userID: 48954, id: 4534, title: "Jignesh", body: "RxSwift")
        //self.viewModel.addUser(user: user)
        
        CalendarHelperManager.shared.createEvent { [weak self] (event) in
            guard let event = event, let self = self else { return }
            
            event.title = "Meeting with Mr.\(Int(arc4random_uniform(2000)))"
            event.startDate = Date()
            event.endDate = event.startDate.addingTimeInterval(Double(arc4random_uniform(24)) * 60 * 60)
            
            //other options
            event.notes = "Don't forget to bring the meeting memos"
            event.location = "Room \(Int(arc4random_uniform(100)))"
            event.availability = .free
            self.viewModel.addEvent(event: event)
        }
    }
    
    @objc func onTapClearAll() {
        self.viewModel.clearAll()
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,EKEvent>> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.location ?? "")"
            return cell
        } titleForHeaderInSection: { dataSorce, sectionIndex in
            return dataSorce[sectionIndex].model
        }

        self.viewModel.events.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext:{ [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteEvent(indexPath: indexPath)
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Edit Event", message: "", preferredStyle: .alert)
            alert.addTextField { texfield in
                texfield.placeholder = "Enter Title"
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                guard let newTitle = textField.text else { return }
                self.viewModel.editEvent(title: newTitle, indexPath: indexPath)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
}

extension DashboardViewController : UITableViewDelegate {}
