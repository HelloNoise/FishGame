import SpriteKit
import UIKit
import GameplayKit

let collisionEaterCategory: UInt32  = 0x1 << 0
let collisionGoldCategory: UInt32    = 0x1 << 1
let collisionMonsterCategory: UInt32    = 0x1 << 2


class GameScene: SKScene, SKPhysicsContactDelegate {
    let eaterFish = SKSpriteNode(imageNamed: "EaterFish")
    let fishBackground = SKSpriteNode(imageNamed: "FishBackground_iPhone")
    let backgroundMusic = SKAudioNode(fileNamed: "audio/FishBackground.wav")
    var fishScore=0
    var fishScoreLabel=SKLabelNode(text: "Feasts: 0")
    
    override func didMove(to view: SKView) {
        
        fishBackground.position = CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5)
        fishBackground.zPosition = -1
        addChild(fishBackground)
        
        eaterFish.position = CGPoint(x: frame.size.width*0.9, y: frame.size.height * 0.5)
        eaterFish.physicsBody = SKPhysicsBody(rectangleOf: eaterFish.size)
        eaterFish.physicsBody?.isDynamic=true
        eaterFish.physicsBody?.affectedByGravity=false
        eaterFish.physicsBody?.allowsRotation=false
        eaterFish.physicsBody?.categoryBitMask=collisionEaterCategory
        eaterFish.physicsBody?.contactTestBitMask=collisionMonsterCategory
        eaterFish.physicsBody?.contactTestBitMask=collisionGoldCategory
        eaterFish.physicsBody?.collisionBitMask=0
        addChild(eaterFish)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let goldfishAuto = SKAction.run(addGoldfish)
        let waitTime = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([goldfishAuto, waitTime])
        run(SKAction.repeatForever(sequence))
        
        let monsterfishAuto = SKAction.run(addMonsterfish)
        let waitTimeM = SKAction.wait(forDuration: 1.0)
        let sequenceM = SKAction.sequence([monsterfishAuto, waitTimeM])
        run(SKAction.repeatForever(sequenceM))
       
        addChild(backgroundMusic)
        backgroundMusic.autoplayLooped = true
        
        fishScoreLabel.position = CGPoint(x: frame.size.width*0.1, y: frame.size.height*0.15)
        fishScoreLabel.fontColor=SKColor.yellow
        fishScoreLabel.fontName="Arial"
        fishScoreLabel.fontSize=30
        addChild(fishScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        let moveTo = SKAction.move(to: touchLocation, duration: 0.5)
        eaterFish.run(moveTo)
    }
    
    func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat {
        let random = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return random * (max - min) + min
    }
    
    func addGoldfish() {
        let goldFish = SKSpriteNode(imageNamed: "Goldfish")
        
        goldFish.physicsBody=SKPhysicsBody(rectangleOf: goldFish.size)
        goldFish.physicsBody?.isDynamic=false
        goldFish.physicsBody?.categoryBitMask = collisionGoldCategory
        goldFish.physicsBody?.contactTestBitMask = collisionEaterCategory

        goldFish.position = CGPoint(x: frame.size.width*0.01, y: (frame.size.height+goldFish.size.height)*randomNumber(min: 0, max: 1))
        
        let moveToX = SKAction.moveTo(x: size.width+goldFish.size.width, duration: (5))
        goldFish.run(moveToX)
        
        addChild(goldFish)
    }
    
    func addMonsterfish() {
        let monsterFish = SKSpriteNode(imageNamed: "monsterFish")
        
        monsterFish.physicsBody=SKPhysicsBody(rectangleOf: monsterFish.size)
        monsterFish.physicsBody?.isDynamic=false
        monsterFish.physicsBody?.categoryBitMask = collisionMonsterCategory
        monsterFish.physicsBody?.contactTestBitMask = collisionEaterCategory
        
        monsterFish.position = CGPoint(x: frame.size.width*0.01, y: (frame.size.height+monsterFish.size.height)*randomNumber(min: 0, max: 1))
        
        let moveToX = SKAction.moveTo(x: size.width+monsterFish.size.width, duration: (4))
        monsterFish.run(moveToX)
        
        addChild(monsterFish)
    }
    
    func eatenGoldfish(_ goldfish: SKSpriteNode, eaterfish: SKSpriteNode) {
        goldfish.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == collisionEaterCategory && secondBody.categoryBitMask == collisionGoldCategory {
            fishScore += 1
            if fishScore >= 40 {
                backgroundMusic.removeFromParent()
                let winnerScene: WinnerScene=WinnerScene(size: CGSize(width: 1136, height: 640))
                winnerScene.scaleMode = .aspectFill
                self.view?.presentScene(winnerScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
            }
            self.fishScoreLabel.text=(text: "Feasts: \(fishScore)")
            run(SKAction.playSoundFileNamed("audio/Bling.wav", waitForCompletion: false))
            eatenGoldfish(secondBody.node as! SKSpriteNode, eaterfish: firstBody.node as! SKSpriteNode)
            
        }
        else if firstBody.categoryBitMask == collisionEaterCategory && secondBody.categoryBitMask == collisionMonsterCategory {
            eaterFish.removeFromParent()
            backgroundMusic.removeFromParent()
            let gameOverScene: GameOverScene=GameOverScene(size: CGSize(width: 1136, height: 640))
            self.view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }
}

    
