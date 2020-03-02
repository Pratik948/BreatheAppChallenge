//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .black
        var flowerView: FlowerView = FlowerView(circles: 6)
        flowerView.translatesAutoresizingMaskIntoConstraints = false
        flowerView.clipsToBounds = false
        view.addSubview(flowerView)
        NSLayoutConstraint.activate([
            flowerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flowerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flowerView.widthAnchor.constraint(equalToConstant: 300),
            flowerView.heightAnchor.constraint(equalToConstant: 300)
        ])
        self.view = view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

class FlowerView: UIView {
    var numberOfCircles: Int = 6
    private var pelats:[CALayer] = []
    private var pelatsToAnimateAlpha:[CALayer] = []
    convenience init(circles: Int = 6) {
        self.init()
        self.numberOfCircles = circles
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.white.cgColor
        self.setLayers()
    }
    
    private func setLayers() {
        self.pelats.forEach { (view) in
            view.removeFromSuperlayer()
        }
        self.pelatsToAnimateAlpha.forEach { (view) in
            view.removeFromSuperlayer()
        }
        self.pelats.removeAll()
        self.pelatsToAnimateAlpha.removeAll()
        let center = CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2)
        var curAngle: CGFloat = 0
        let incAngle: CGFloat = (360/CGFloat(numberOfCircles)) * CGFloat.pi/180
        var curAngle2: CGFloat = incAngle/2
        let circleRadius: CGFloat = 75
        let size = self.bounds.width/2
        for _ in 0..<numberOfCircles {
            let pelat: CALayer = CALayer()
            pelat.backgroundColor = UIColor.cyan.withAlphaComponent(0.8).cgColor
            pelat.cornerRadius = size/2
            let x1 = center.x + cos(curAngle)*circleRadius - (size / 2)
            let y1 = center.y + sin(curAngle)*circleRadius - (size / 2)
            pelat.frame = CGRect.init(x: x1, y: y1, width: size, height: size)
            self.layer.addSublayer(pelat)
            
            let pelat2: CALayer = CALayer()
            pelat2.backgroundColor = UIColor.cyan.withAlphaComponent(0.2).cgColor
            pelat2.cornerRadius = size/2
            let x2 = center.x + cos(curAngle2)*circleRadius - (size / 2)
            let y2 = center.y + sin(curAngle2)*circleRadius - (size / 2)
            pelat2.frame = CGRect.init(x: x2, y: y2, width: size, height: size)
            self.layer.addSublayer(pelat2)
            
            curAngle += incAngle
            curAngle2 += incAngle
            pelats.append(pelat)
            pelatsToAnimateAlpha.append(pelat2)
        }
        self.animate()
    }
    
    func animate(clockWise: Bool = true) {
        for pelat in self.pelatsToAnimateAlpha {
            let animation = CABasicAnimation.init(keyPath: "backgroundColor")
            animation.toValue = UIColor.cyan.withAlphaComponent(clockWise ? 0.8 : 0.2).cgColor
            animation.duration = 3
            pelat.add(animation, forKey: "backgroundColorAnimation")
        }
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.init(rotationAngle: (clockWise ? 0.999 : -0.999)*CGFloat.pi).scaledBy(x: 0.1, y: 0.1)
        }) { (isFinished) in
            UIView.animate(withDuration: 3, delay: 1, options: .curveEaseInOut, animations: {
                self.transform = .identity
            }) { (isFinished) in
                self.animate()
            }
        }
    }
    
}
