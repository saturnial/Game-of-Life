import UIKit

class WorldSimulatorViewController: UIViewController {
    
    enum State {
        case playing
        case paused
        case stopped
    }
    
    /// The timer object that iterates the world tick-by-tick.
    var timer: Timer?
    
    /// The current state of the world simulator.
    var state: State = .stopped {
        didSet {
            
            switch self.state {
            case .stopped:
                self.timer?.invalidate()
                self.timer = nil
                self.world.reset()
                self.playButton.setImage(UIImage(named: "play"), for: .normal)

            case .paused:
                self.timer?.invalidate()
                self.timer = nil
                self.playButton.setImage(UIImage(named: "play"), for: .normal)
                
            case .playing:
                self.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                                  target: self.world,
                                                  selector: #selector(self.world.tick),
                                                  userInfo: nil,
                                                  repeats: true)
                self.playButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var worldContainerView: UIView!
    
    let world = World()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.worldContainerView.addSubview(self.world.makeView())
    }
    
    @IBAction func handlePlayButtonPress(_ sender: Any) {
        switch self.state {
        case .paused:
            self.state = .playing
            

        case .playing:
            self.state = .paused

        case .stopped:
            self.state = .playing
        }
    }
    
    @IBAction func handleStopButtonPress(_ sender: Any) {
        self.state = .stopped
    }
}
