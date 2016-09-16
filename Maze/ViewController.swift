//
//  ViewController.swift
//  Maze
//
//  Created by Marcus Shannon on 7/5/15.
//  Copyright (c) 2015 Marcus Shannon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CanvasDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var maze = Maze()
    
    @IBOutlet weak var canvasView: Canvas! {
        didSet {
            canvasView.dataSource = self
        }
    }
    
    @IBOutlet weak var redDot: RedDot! {
        didSet {
            redDot.dataSource = self
        }
    }
    
    @IBOutlet weak var highScore: UILabel!
    
    @IBOutlet weak var moves: UILabel!
    
    func move() {
        moves.text = "Moves: \(maze.moves)"
    }
    
    @IBAction func tapUp(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            var location = sender.locationInView(canvasView)
            if location.y <= canvasView.bounds.maxY * 0.25 {
                maze.moveCursorUp()
            }
            else if location.y >= canvasView.bounds.maxY * 0.75 {
                maze.moveCursorDown()
            }
            else if location.x < canvasView.bounds.maxX * 0.25 {
                maze.moveCursorLeft()
            }
            else if location.x >= canvasView.bounds.maxX * 0.75 {
                maze.moveCursorRight()
            }
            redDot.setNeedsDisplay()
            move()
            if maze.cursor === maze.endCell {
                var score = defaults.integerForKey("highScore")
                if maze.moves < score || score == 0 {
                    defaults.setInteger(maze.moves, forKey: "highScore")
                    highScore.text = "High Score: \(maze.moves)"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var score = defaults.integerForKey("highScore")
        highScore.text = "High Score: \(score)"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}