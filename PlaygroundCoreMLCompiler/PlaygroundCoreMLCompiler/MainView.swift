import UIKit

public class MainView: UIView {
    
    //VIEW COMPONENTS
    var buttonLeft: UIButton?
    var buttonRight: UIButton?
    var instrumentImageView: UIImageView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewWidth = frame.width
        let viewHeight = frame.height
        
        let backgroundImageView = UIImageView(image: UIImage(named: "speaker_background"))
        backgroundImageView.frame = frame
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        
        
        let logoImageView = UIImageView(image: UIImage(named: "MUchineLearning"))
        addSubview(logoImageView)
        
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLeft = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        buttonLeft?.backgroundColor = .clear
        buttonLeft?.setImage(UIImage(named: "left_button"), for: .normal)
        buttonLeft?.addTarget(self, action: #selector(buttonLeftPressed), for: .touchUpInside)
        addSubview(buttonLeft!)
        
        
        buttonLeft?.translatesAutoresizingMaskIntoConstraints = false
        buttonLeft?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        buttonLeft?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonLeft?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        
        buttonRight = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        buttonRight?.backgroundColor = .clear
        buttonRight?.setImage(UIImage(named: "right_button"), for: .normal)
        buttonRight?.addTarget(self, action: #selector(buttonRightPressed), for: .touchUpInside)
        
        addSubview(buttonRight!)
        buttonRight?.translatesAutoresizingMaskIntoConstraints = false
        buttonRight?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        buttonRight?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonRight?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        
        instrumentImageView = UIImageView(image: UIImage(named: "MUchineLearning"))
        instrumentImageView?.contentMode = .scaleAspectFit
        addSubview(instrumentImageView!)
        
        instrumentImageView?.translatesAutoresizingMaskIntoConstraints = false
        instrumentImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        instrumentImageView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        instrumentImageView?.leadingAnchor.constraint(greaterThanOrEqualTo: (buttonLeft?.trailingAnchor)!, constant: 10).isActive = true
        
        instrumentImageView?.trailingAnchor.constraint(greaterThanOrEqualTo: (buttonRight?.leadingAnchor)!, constant: 10).isActive = true
        
        instrumentImageView?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        
        let buttonRec = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        buttonRec.backgroundColor = .clear
        buttonRec.setImage(UIImage(named: "rec_disabled"), for: .normal)
        buttonRec.addTarget(self, action: #selector(buttonRecPressed), for: .touchUpInside)
        
        addSubview(buttonRec)
        
        buttonRec.translatesAutoresizingMaskIntoConstraints = false
        buttonRec.trailingAnchor.constraint(equalTo: logoImageView.trailingAnchor).isActive = true
        buttonRec.topAnchor.constraint(equalTo: instrumentImageView!.lastBaselineAnchor, constant: 50).isActive = true
        buttonRec.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        
        let buttonPlay = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        buttonPlay.backgroundColor = .clear
        buttonPlay.setImage(UIImage(named: "play_disabled"), for: .normal)
        buttonPlay.addTarget(self, action: #selector(buttonPlayPressed), for: .touchUpInside)
        
        addSubview(buttonPlay)
        
        buttonPlay.translatesAutoresizingMaskIntoConstraints = false
        buttonPlay.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor).isActive = true
        buttonPlay.topAnchor.constraint(equalTo: instrumentImageView!.lastBaselineAnchor, constant: 50).isActive = true
        buttonPlay.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
    }
    
    @objc func buttonLeftPressed()
    {
        print("buttonLeftPressed")
    }
    
    @objc func buttonRightPressed()
    {
        print("buttonRightPressed")
    }
    
    @objc func buttonRecPressed()
    {
        print("buttonRecPressed")
    }
    
    @objc func buttonPlayPressed()
    {
        print("buttonPlayPressed")
    }
    
    public required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}


