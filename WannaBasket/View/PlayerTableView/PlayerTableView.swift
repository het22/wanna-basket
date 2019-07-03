//
//  PlayerTableView.swift
//  WannaBasket
//
//  Created by Het Song on 25/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol PlayerTableViewDelegate {
    func didDeletePlayerButtonTap()
    func didPlayerCellTap(at indexPath: IndexPath)
}

class PlayerTableView: UITableView {
    
    var _delegate: PlayerTableViewDelegate?
    
    @IBInspectable var placeholder: String = "팀을 선택하세요"
    @IBInspectable var spacing: CGFloat = 5
    @IBInspectable var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(PlayerTableViewCell.self)
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
    
    private var playerList: [Player]?
    func reloadData(with playerList: [Player]?) {
        placeholderLabel.isHidden = (playerList != nil)
        self.playerList = playerList
        reloadData()
    }
    
    func highlightCell(at indexPath: IndexPath, bool: Bool) {
        if let cell = cellForRow(at: indexPath) as? PlayerTableViewCell {
            cell.isHighlighted = bool
        }
    }
}

extension PlayerTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = cellForRow(at: indexPath) as? PlayerTableViewCell {
            _delegate?.didPlayerCellTap(at: indexPath)
        }
    }
}

extension PlayerTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return playerList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section==0) ? 0 : spacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = bounds.height / 5 - spacing
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(forIndexPath: indexPath) as PlayerTableViewCell
        cell.setup(name: playerList![indexPath.section].name, highlightColor: highlightColor)
        return cell
    }
}
