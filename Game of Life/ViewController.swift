import UIKit

class ViewController: UIViewController {
    
    let world = World()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(world.makeView())
        
        Timer.scheduledTimer(timeInterval: 1,
                             target: self.world,
                             selector: #selector(self.world.tick),
                             userInfo: nil,
                             repeats: true)
    }
}
