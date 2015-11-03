//
//  MovieDetailTableViewController+HeaderView.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension MovieDetailTableViewController {

    func setupHeaderView() {
        headerView = tableView.tableHeaderView
        headerMaskLayer =   CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.darkGrayColor().CGColor
        headerView.layer.mask = headerMaskLayer
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top:effectiveHeight, left:0, bottom:0, right:0)
        tableView.contentOffset = CGPoint(x:0,y:-effectiveHeight)
        updateHeaderView()

    }
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        var headerRect = CGRect(x:0,y:-effectiveHeight, width:tableView.bounds.width,height:kTableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
        }
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x:0,y:0))
        path.addLineToPoint(CGPoint(x:headerRect.width, y:0))
        path.addLineToPoint(CGPoint(x:headerRect.width, y:headerRect.height))
        path.addLineToPoint(CGPoint(x:0, y:headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
        
    }
    
    //MARK: - UIScrollView
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
}
