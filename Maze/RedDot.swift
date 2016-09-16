//
//  RedDot.swift
//  Maze
//
//  Created by Marcus Shannon on 7/13/15.
//  Copyright (c) 2015 Marcus Shannon. All rights reserved.
//

import UIKit

class RedDot: UIView {
    weak var dataSource: CanvasDataSource!
    
    override func drawRect(rect: CGRect) {
        var size = rect.width / CGFloat(dataSource.maze.width)
        var cursorPosition = CGRect(x: CGFloat(dataSource.maze.cursor.x) * size, y: CGFloat(dataSource.maze.cursor.y) * size, width: size, height: size)
        var circle = UIBezierPath(ovalInRect: cursorPosition)
        UIColor.redColor().setFill()
        circle.fill()
    }
}
