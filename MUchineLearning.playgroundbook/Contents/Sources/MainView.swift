import UIKit

public class MainView: UIView {
    
    //VIEW COMPONENTS
    var buttonLeft: UIButton?
    var buttonRight: UIButton?
    var buttonRec: UIButton?
    var buttonPlay: UIButton?
    
    public var previewImage: UIImageView?

    var instrumentImageView: UIImageView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        //let viewWidth = frame.width
        //let viewHeight = frame.height
        
        let backgroundImageView = UIImageView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        backgroundImageView.image = UIImage(named: "metal")
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
//        
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        
        let logoImageView = UIImageView(image: UIImage(named: "LOGO"))
        addSubview(logoImageView)
        
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10).isActive = true
//        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLeft = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        buttonLeft?.backgroundColor = .clear
        buttonLeft?.setImage(UIImage(named: "left_button"), for: .normal)
        buttonLeft?.addTarget(self, action: #selector(buttonLeftPressed), for: .touchUpInside)
        addSubview(buttonLeft!)
        
        
        buttonLeft?.translatesAutoresizingMaskIntoConstraints = false
        buttonLeft?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        buttonLeft?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //buttonLeft?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        
        buttonRight = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        buttonRight?.backgroundColor = .clear
        buttonRight?.setImage(UIImage(named: "right_button"), for: .normal)
        buttonRight?.addTarget(self, action: #selector(buttonRightPressed), for: .touchUpInside)
        
        addSubview(buttonRight!)
        buttonRight?.translatesAutoresizingMaskIntoConstraints = false
        buttonRight?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        buttonRight?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //buttonRight?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        
        instrumentImageView = UIImageView(image: UIImage(named: "piano"))
        instrumentImageView?.contentMode = .scaleAspectFit
        addSubview(instrumentImageView!)
        
        instrumentImageView?.translatesAutoresizingMaskIntoConstraints = false
        instrumentImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        instrumentImageView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        previewImage = UIImageView(image: UIImage(named: "no_hand"))
        previewImage?.contentMode = .scaleAspectFit
        addSubview(previewImage!)
        
        previewImage?.translatesAutoresizingMaskIntoConstraints = false
        //previewImage?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        previewImage?.topAnchor.constraint(greaterThanOrEqualTo: instrumentImageView!.lastBaselineAnchor).isActive = true
        previewImage?.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        previewImage?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //previewImage?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
    }
    
    @objc func buttonLeftPressed()
    {
        print("MainViewButtonLeftPressed")
        AudioManager.sharedInstance.prepareAudioPlayers(instrument: -1)
        
        updateInstrument()

    }
    
    @objc func buttonRightPressed()
    {
        print("MainViewButtonRightPressed")
        AudioManager.sharedInstance.prepareAudioPlayers(instrument: 1)
        updateInstrument()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
    
    public func updateInstrument() {
        var counterInstrument = AudioManager.sharedInstance.instrumentCount

        if counterInstrument < 0 {
            counterInstrument *= -1
        }
        switch counterInstrument % 5 {
        case InstrumentsEnum.BAND:
            self.instrumentImageView?.image = UIImage(named: "band")
            break

        case InstrumentsEnum.DRUM:
            self.instrumentImageView?.image = UIImage(named: "drum")
            break

        case InstrumentsEnum.GUITAR:
            self.instrumentImageView?.image = UIImage(named: "guitar")
            break

        case InstrumentsEnum.PIANO:
            self.instrumentImageView?.image = UIImage(named: "piano")
            break
        default:
            self.instrumentImageView?.image = UIImage(named: "sampler")

            break
        }
    }
}

extension UIButton {
    func hasImage(named imageName: String, for state: UIControlState) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }
        
        return UIImagePNGRepresentation(buttonImage) == UIImagePNGRepresentation(namedImage)
    }
}


