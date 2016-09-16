//
//  Maze.swift
//  Maze
//
//  Created by Marcus Shannon on 7/5/15.
//  Copyright (c) 2015 Marcus Shannon. All rights reserved.
//

import UIKit

class Cell {
    var x: Int
    var y: Int
    var rank: Int
    var parent: Cell!
    var rightWall = true
    var bottomWall = true
    var leftWall = true
    var topWall = true
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.rank = 0
        self.parent = self
    }
    
    func find() -> Cell {
        if !(self === self.parent) {
            self.parent = self.parent.find()
        }
        return self.parent
    }
    
    func setWalls(two: Cell) {
        if (self.x < two.x) {
            self.rightWall = false
        }
        if (self.x > two.x) {
            self.leftWall = false
        }
        if (self.y < two.y) {
            self.bottomWall = false
        }
        if (self.y > two.y) {
            self.topWall = false
        }
    }
}

class Edge {
    var one: Cell
    var two: Cell
    
    init(one: Cell, two: Cell) {
        self.one = one
        self.two = two
    }
}

class Maze {
    var width = 32
    var height = 32
    var cells = [Cell]()
    var hash = [Int:Cell]()
    var cursor: Cell!
    var moves = 0
    var win = false
    
    var startCell: Cell! {
        return hash[self.computeKey(0, y: 0)]
    }
    
    var endCell: Cell! {
        return hash[self.computeKey(width - 1, y: height - 1)]
    }
    
    func computeKey(x: Int, y: Int) -> Int {
        return ((x + y) * (x + y + 1) / 2) + y;
    }
    
    func makeCells() {
        for (var x = 0; x < width; x = x + 1) {
            for (var y = 0; y < height ; y = y + 1) {
                var newCell = Cell(x: x, y: y)
                self.cells.append(newCell)
                hash[self.computeKey(x, y: y)] = newCell
            }
        }
    }
    
    func makeEdgeList() -> [Edge] {
        var edges = [Edge]()
        for cell in cells {
            if let right = hash[self.computeKey(cell.x + 1, y: cell.y)] {
                edges.append(Edge(one: cell, two: right))
            }
            if let bottom = hash[self.computeKey(cell.x, y: cell.y + 1)] {
                edges.append(Edge(one: cell, two: bottom))
            }
        }
        return edges
    }
    
    func kruskal() {
        self.makeCells()
        var edges = self.makeEdgeList()
        while edges.count > 0 {
            var randomNumber = Int(arc4random_uniform(UInt32(edges.count)))
            var edge = edges.removeAtIndex(randomNumber)
            if (edge.one.find() !== edge.two.find()) {
                edge.one.setWalls(edge.two)
                edge.two.setWalls(edge.one)
                self.union(edge.one, two: edge.two)
            }
        }
    }
    
    func union(one: Cell, two: Cell) {
        var rep1 = one.find()
        var rep2 = two.find()
        if (rep1 === rep2) {
            return
        }
        if (rep1.rank > rep2.rank) {
            rep2.parent = rep1
        }
        else {
            rep1.parent = rep2
            if (rep1.rank == rep2.rank) {
                rep2.rank += 1
            }
        }
    }
    
    func moveCursorRight() {
        if let newCell = hash[self.computeKey(cursor.x + 1, y: cursor.y)] {
            if !cursor.rightWall {
                cursor = newCell
                moves += 1
            }
        }
    }
    
    func moveCursorDown() {
        if let newCell = hash[self.computeKey(cursor.x, y: cursor.y + 1)] {
            if !cursor.bottomWall {
                cursor = newCell
                moves += 1
            }
        }
    }
    
    func moveCursorLeft() {
        if let newCell = hash[self.computeKey(cursor.x - 1, y: cursor.y)] {
            if !cursor.leftWall {
                cursor = newCell
                moves += 1
            }
        }
    }
    
    func moveCursorUp() {
        if let newCell = hash[self.computeKey(cursor.x, y: cursor.y - 1)] {
            if !cursor.topWall {
                cursor = newCell
                moves += 1
            }
        }
    }
    
    init() {
        self.kruskal()
        cursor = startCell
    }
}