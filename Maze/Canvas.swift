//
//  Canvas.swift
//  Maze
//
//  Created by Marcus Shannon on 7/6/15.
//  Copyright (c) 2015 Marcus Shannon. All rights reserved.
//

import UIKit

protocol CanvasDataSource: class {
    var maze: Maze { get }
}

class Canvas: UIView {
    weak var dataSource: CanvasDataSource?
    
    override func drawRect(rect: CGRect) {
        var maze = dataSource?.maze ?? Maze()
        var size = bounds.width / CGFloat(maze.width)
        for cell in maze.cells {
            var x = CGFloat(cell.x)
            var y = CGFloat(cell.y)
            var tr = CGPoint(x: x * size + size, y: y * size)
            var br = CGPoint(x: x * size + size, y: y * size + size)
            var bl = CGPoint(x: x * size, y: y * size + size)
            
            var edge = UIBezierPath()
            edge.moveToPoint(CGPoint(x: rect.minX, y: rect.minY + 0.5))
            edge.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY + 0.5))
            edge.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY - 0.5))
            edge.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY - 0.5))
            edge.addLineToPoint(CGPoint(x: rect.minX, y: rect.minY))
            edge.lineWidth = 1.0
            edge.stroke()
            if cell.rightWall {
            var path = UIBezierPath()
                path.moveToPoint(tr)
                path.addLineToPoint(br)
                path.stroke()
            }
            if cell.bottomWall {
                var path = UIBezierPath()
                path.moveToPoint(br)
                path.addLineToPoint(bl)
                path.stroke()
            }
        }
    }
}