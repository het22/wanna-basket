//
//  PlayerTableView.swift
//  WannaBasket
//
//  Created by Het Song on 25/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerTableView: UITableView {
    
    var _delegate: PlayerTableViewDelegate?
    
    let placeholder = "팀을 선택하세요"
    let padding: CGFloat = 10
    let buttonHeight: CGFloat = 30
    @IBInspectable var color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(PlayerTableViewCell.self)
        register(AddButtonCell.self)
        dataSource = self
        delegate = self
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.text = placeholder
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.font = UIFont(name: "DoHyeon-Regular", size: 20)
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    
    private var players: [Player]?
    func reloadData(with players: [Player]?) {
        self.players = players
        placeholderLabel.isHidden = (players != nil)
        reloadData()
    }
}

extension PlayerTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (players?.count ?? -1) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section==0 ? 0 : padding
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 0) { return buttonHeight }
        else {
            let cellHeight = (bounds.height - buttonHeight) / 5 - padding
            return cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = dequeueReusableCell(forIndexPath: indexPath) as AddButtonCell
            cell.setup(color: color)
            return cell
        } else {
            let cell = dequeueReusableCell(forIndexPath: indexPath) as PlayerTableViewCell
            cell.setup(name: players![indexPath.section - 1].name)
            return cell
        }
    }
}

protocol PlayerTableViewDelegate {
    func didAddPlayerButtonTap(id: ObjectIdentifier)
    func didDeletePlayerButtonTap()
}

extension PlayerTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            _delegate?.didAddPlayerButtonTap(id: ObjectIdentifier(self))
        }
    }
}
