//
//  GameScene.swift
//  climber
//
//  Created by Shannon Jin on 12/29/18.
//  Copyright © 2018 Shannon Jin. All rights reserved.
//

//https://stackoverflow.com/questions/29779128/how-to-make-a-random-color-with-swift
extension CGFloat{
    static func random() -> CGFloat{
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}

extension UIColor{
    static func random() -> UIColor{
        return UIColor(red: .random(),green: .random(), blue: .random(), alpha: 1.0)
    }
}
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var balls: [SKShapeNode]=[]
    private var gameTimer: Timer!
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
       
       gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addDot), userInfo: nil, repeats: true)

        print(self.frame.width,self.frame.height)
      
        
    }
   
    
   @objc func addDot(){
        
        let radius = arc4random_uniform(200)+30
        let currentBall = SKShapeNode(circleOfRadius: CGFloat(radius))
    
    /*
        let xPos=arc4random_uniform(UInt32(self.frame.width*2))-UInt32(self.frame.width)
        let yPos=arc4random_uniform(UInt32(self.frame.height*2))-UInt32(self.frame.height)
 */

        var xPos=CGFloat(arc4random_uniform(UInt32(self.frame.width-100)))
        var yPos=CGFloat(arc4random_uniform(UInt32(self.frame.height-100)))
    
    
        if arc4random_uniform(2) == 1{
            xPos = xPos * -1
        }
    
        if arc4random_uniform(2) == 1{
            yPos = yPos * -1
        }
    
        let randomPosition = CGPoint(x: xPos, y: yPos)
    
        /*
    
        //https://stackoverflow.com/questions/31896971/creating-a-random-position-for-a-sprite-in-swift
        let height = self.view!.frame.height
        let width = self.view!.frame.width
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
                                 y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height))
        */
    
        currentBall.fillColor = .random()
    
        
        currentBall.position=randomPosition
        balls.append(currentBall)
    
    
    
    self.addChild(currentBall)
        
        //for node in balls{
           // self.addChild(node)
       // }
        
        
        
       // let randomDotPosition= DKRandomDistribution(lowestValue:0, highestValue: 414)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        for b in balls{
            
            if let p = (b as! SKShapeNode).path{
                
                if(p.contains(pos)){
                    b.removeFromParent()
                }
            }
            
            
            //if(b?.path.contains(t.location)){
            //  self.removeChildren(in: balls)
            //}
        }
        
        /*
        if self.currentBall?.position == pos {
            self.currentBall?.removeFromParent()
        }
    
        //currentBall!.removeFromParent()
        
        if pos == currentBall?.position {
            let node=pos
            
        }*/
       // self.removeChildren(in: balls)
        //balls.removeAll()
        
        
       
    }
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        
        for b in balls{
            
            if let p = (b as! SKShapeNode).path{
                
                if(p.contains(pos)){
                    b.removeFromParent()
                }
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
        
        for b in balls{
            
            if let p = (b as! SKShapeNode).path{
                
                if(p.contains(pos)){
                    b.removeFromParent()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            
            self.touchDown(atPoint: t.location(in: self))
        
        }
        
      /*
            if let p = (b as! SKShapeNode).path{
                
            }
 
        }
        
        
        if let p = (node as! SKShapeNode).path {
            if CGPathContainsPoint(p, nil, touchPosition, false) {
                print("you have touched triangle: \(node.name)")
                let triangle = node as! SKShapeNode
                // stuff here
            }
        }
    */
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
