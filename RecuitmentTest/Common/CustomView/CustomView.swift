//
//  CustomView.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import UIKit

class CustomView: UIView {

    lazy var nibName: String = String(describing: type(of: self))
    var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }

    private func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView

        return view
    }

    func setup() {}
}

