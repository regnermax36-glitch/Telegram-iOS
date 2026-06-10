import UIKit
import QuartzCore

// MARK: - MaxRegnerUI · Holographic Particle / Grid Background · 2029

/// A CAEmitterLayer that emits floating holographic dust particles.
public final class HoloParticleLayer: CAEmitterLayer {

    public override init() {
        super.init()
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        emitterShape  = .rectangle
        renderMode    = .additive
        emitterCells  = [makeCell(color: HoloColors.plasma0, birthRate: 0.8, velocity: 18),
                         makeCell(color: HoloColors.aurora0, birthRate: 0.4, velocity: 12),
                         makeCell(color: HoloColors.neon0,   birthRate: 0.2, velocity: 8)]
    }

    public override var frame: CGRect {
        didSet {
            emitterPosition = CGPoint(x: frame.midX, y: frame.maxY)
            emitterSize     = CGSize(width: frame.width, height: 0)
        }
    }

    private func makeCell(color: UIColor, birthRate: Float, velocity: CGFloat) -> CAEmitterCell {
        let cell          = CAEmitterCell()
        cell.birthRate    = birthRate
        cell.lifetime     = 12
        cell.lifetimeRange = 4
        cell.velocity     = velocity
        cell.velocityRange = velocity * 0.5
        cell.emissionLongitude = -.pi / 2
        cell.emissionRange    = .pi / 6
        cell.scale            = 0.04
        cell.scaleRange       = 0.02
        cell.alphaSpeed       = -0.04
        cell.color            = color.withAlphaComponent(0.6).cgColor
        cell.contents         = makeParticleImage().cgImage
        return cell
    }

    private func makeParticleImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 6, height: 6), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: 0, y: 0, width: 6, height: 6))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}

// MARK: - HoloScanGridLayer
// Renders a perspective holographic grid (like a 2029 HUD floor plane)

public final class HoloScanGridLayer: CALayer {

    private let gridLayer = CAShapeLayer()
    private let scanLine  = CALayer()

    public var gridColor: UIColor = HoloColors.plasma0.withAlphaComponent(0.04) {
        didSet { gridLayer.strokeColor = gridColor.cgColor }
    }

    public override init() {
        super.init()
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSublayer(gridLayer)
        gridLayer.strokeColor = gridColor.cgColor
        gridLayer.fillColor   = UIColor.clear.cgColor
        gridLayer.lineWidth   = 0.5

        scanLine.backgroundColor = HoloColors.plasma0.withAlphaComponent(0.08).cgColor
        addSublayer(scanLine)
        animateScan()
    }

    public override var frame: CGRect {
        didSet { drawGrid(); layoutScanLine() }
    }

    private func drawGrid() {
        let path = UIBezierPath()
        let cols = 12
        let rows = 20
        let cw = bounds.width / CGFloat(cols)
        let rh = bounds.height / CGFloat(rows)

        for i in 0...cols {
            let x = CGFloat(i) * cw
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: bounds.height))
        }
        for j in 0...rows {
            let y = CGFloat(j) * rh
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: bounds.width, y: y))
        }

        gridLayer.frame = bounds
        gridLayer.path  = path.cgPath
    }

    private func layoutScanLine() {
        scanLine.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2)
    }

    private func animateScan() {
        let anim = CABasicAnimation(keyPath: "position.y")
        anim.fromValue  = 0
        anim.toValue    = bounds.height + 2
        anim.duration   = 4.0
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        scanLine.add(anim, forKey: "scan")
    }
}
