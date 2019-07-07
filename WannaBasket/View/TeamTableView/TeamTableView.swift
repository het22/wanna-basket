//
//  TeamTableView
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamTableViewDelegate {
    func didDeleteTeamButtonTap()
    func didTeamCellDequeue() -> (home: Int?, away: Int?)
    func didTeamCellTap(at indexPath: IndexPath, onLeft: Bool)
}

class TeamTableView: UITableView {
    
    var _delegate: TeamTableViewDelegate?
    
    @IBInspectable var placeholder: String = "팀을 생성하세요"
    @IBInspectable var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var spacing: CGFloat = 5
    @IBInspectable var cellCount: CGFloat = 4.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: spacing, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(TeamTableViewCell.self)
        dataSource = self
        delegate = self
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = placeholder
        label.textColor = Constants.Color.Silver
        label.font = UIFont(name: "DoHyeon-Regular", size: 20)
        label.textAlignment = .center
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        return label
    }()
    
    private var teamList: [Team] = []
    func reloadData(with teamList: [Team]) {
        placeholderLabel.isHidden = (teamList.count != 0)
        self.teamList = teamList
        reloadData()
    }
    
    func highlightCell(at index: Int, onLeft: Bool, bool: Bool) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: index)) as? TeamTableViewCell {
            if onLeft { cell.highlightOnLeft = bool }
            else { cell.highlightOnRight = bool }
        }
    }
}

extension TeamTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = cellForRow(at: indexPath) as? TeamTableViewCell {
            _delegate?.didTeamCellTap(at: indexPath, onLeft: cell.tapOnLeft)
        }
    }
}

extension TeamTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section==0 ? 0 : spacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = bounds.height / cellCount - spacing
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(forIndexPath: indexPath) as TeamTableViewCell
        cell.setup(name: teamList[indexPath.section].name)
        if let currentTeamIndex = _delegate?.didTeamCellDequeue() {
            if let homeTeamIndex = currentTeamIndex.home {
                cell.highlightOnLeft = (indexPath.section == homeTeamIndex)
            }
            if let awayTeamIndex = currentTeamIndex.away {
                cell.highlightOnRight = (indexPath.section == awayTeamIndex)
            }
        }
        return cell
    }
}
