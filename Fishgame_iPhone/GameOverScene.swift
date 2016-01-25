
import Foundation
import SpriteKit


class GameOverScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        let gameOver = SKSpriteNode(imageNamed: "FishGameOver_iPhone")
        
        gameOver.position = CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5)
        gameOver.zPosition = -1
        addChild(gameOver)
        runAction(SKAction.playSoundFileNamed("audio/FishGameOver.wav", waitForCompletion: false))
        }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let reveal = SKTransition.flipHorizontalWithDuration(0)
        let scene = GameScene(size: CGSize(width: 1136, height: 640))
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene, transition: reveal)
        
    }
}
