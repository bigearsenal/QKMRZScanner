import UIKit

class QKCutoutView: UIView {
    fileprivate(set) var cutoutRect: CGRect!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Orientation or the view's size could change
        recalculateCutoutRect()
//        addBorderAroundCutout()
    }

    // MARK: Private

    fileprivate func recalculateCutoutRect() {
//        let documentFrameRatio = CGFloat(1.42) // Passport's size (ISO/IEC 7810 ID-3) is 125mm × 88mm
//        let (width, height): (CGFloat, CGFloat)
//
//        if bounds.height > bounds.width {
//            width = (bounds.width * 0.9) // Fill 90% of the width
//            height = (width / documentFrameRatio)
//        } else {
//            height = (bounds.height * 0.75) // Fill 75% of the height
//            width = (height * documentFrameRatio)
//        }
//
//        let topOffset = (bounds.height - height) / 2
//        let leftOffset = (bounds.width - width) / 2

        cutoutRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

//    fileprivate func addBorderAroundCutout() {
//        let maskLayer = CAShapeLayer()
//        let path = CGMutablePath()
//        let cornerRadius = CGFloat(3)
//
//        path.addRoundedRect(in: cutoutRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
//        path.addRect(bounds)
//
//        maskLayer.path = path
//        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
//
//        layer.mask = maskLayer
//
//        // Add border around the cutout
//        let borderLayer = CAShapeLayer()
//
//        borderLayer.path = UIBezierPath(roundedRect: cutoutRect, cornerRadius: cornerRadius).cgPath
//        borderLayer.lineWidth = 3
//        borderLayer.strokeColor = UIColor.white.cgColor
//        borderLayer.frame = bounds
//
//        layer.sublayers = [borderLayer]
//    }
}
