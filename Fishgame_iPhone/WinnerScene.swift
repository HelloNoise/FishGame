
import Foundation
import SpriteKit

class WinnerScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        let WinnerFish = SKSpriteNode(imageNamed: "LuckyFish_iPhone")
        
        WinnerFish.position = CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5)
        addChild(WinnerFish)
        runAction(SKAction.playSoundFileNamed("audio/LuckyFish.wav", waitForCompletion: false))
        
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
