//
//  PStarRateView.swift
//  PStarRateView
//
//  Created by 邓杰豪 on 2016/9/19.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

protocol PStarRateViewDelegate{
    func starRateView(view:PStarRateView,newScorePercent:CGFloat)
}

class PStarRateView: UIView {
    var scorePercent:CGFloat?
    var hasAnimation:Bool?
    var allowInCompleteStar:Bool?
    var delegate:PStarRateViewDelegate?
    var tapped:Bool?
    var foregroundStarView:UIView?
    var backgroundSrarView:UIView?
    var numberOfStars:NSInteger?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithFrameCustom(frame: frame, numberOfStars: 5, tap: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initWithFrameCustom(frame:CGRect,numberOfStars:NSInteger,tap:Bool)
    {
        self.frame = frame
        self.numberOfStars = numberOfStars
        self.tapped = tap
        buildDataAndUI()
    }

    init(frame:CGRect,numberOfStars:NSInteger,imageForeground:NSString,imageBackground:NSString)
    {
        super.init(frame: frame)
        self.numberOfStars = numberOfStars
        buildUIWithImageStr(f: imageForeground, b: imageBackground)
    }

    func buildUIWithImageStr(f:NSString,b:NSString)
    {
        self.scorePercent = 0.2
        self.hasAnimation = false
        self.allowInCompleteStar = false

        self.foregroundStarView = createStarViewWithImage(name: f)
        self.backgroundSrarView = createStarViewWithImage(name: b)

        self.addSubview(self.backgroundSrarView!)
        self.addSubview(self.foregroundStarView!)

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(userTapRateView(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }

    func buildDataAndUI()
    {
        self.scorePercent = 0.2
        self.hasAnimation = false
        self.allowInCompleteStar = false

        if self.tapped!
        {
            self.foregroundStarView = createStarViewWithImage(name: "")
            self.backgroundSrarView = createStarViewWithImage(name: "")
        }
        else
        {
            self.foregroundStarView = createStarViewWithImage(name: "")
            self.backgroundSrarView = createStarViewWithImage(name: "")
        }
        self.addSubview(self.backgroundSrarView!)
        self.addSubview(self.foregroundStarView!)

        if self.tapped! {
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(userTapRateView(gesture:)))
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
        }
    }

    func userTapRateView(gesture:UITapGestureRecognizer)
    {
        let tapPoint = gesture.location(in: self)
        let offSet = tapPoint.x
        let realStarScore = offSet / (self.bounds.size.width / CGFloat(self.numberOfStars!))
        let starScore:CGFloat?
        if self.allowInCompleteStar! {
            starScore = realStarScore
        }
        else
        {
            starScore = CGFloat(ceilf(Float(realStarScore)))
        }
        self.scorePercent = starScore! / CGFloat(self.numberOfStars!)
    }

    func createStarViewWithImage(name:NSString)->UIView
    {
        let view = UIView.init(frame: self.bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        for i in 0 ..< Int(self.numberOfStars!)
        {
            let imageView = UIImageView.init(image: UIImage.init(named: name as String))
            imageView.frame = CGRect.init(x: CGFloat(i * Int(self.bounds.size.width)) / CGFloat(self.numberOfStars!), y: 0, width: self.bounds.size.width / CGFloat(self.numberOfStars!), height: self.bounds.size.height)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
        }
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let animationTimeInterval:CGFloat?
        if self.hasAnimation! {
            animationTimeInterval = 0.2
        }
        else
        {
            animationTimeInterval = 0
        }
        UIView.animate(withDuration: Double(animationTimeInterval!)) {
            self.foregroundStarView?.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width * self.scorePercent!, height: self.bounds.size.height)
        }
    }

    func setScorePercent(scorePercent:CGFloat)
    {
        if self.scorePercent == scorePercent {
            return
        }

        if scorePercent < 0
        {
            self.scorePercent = 0
        }
        else if scorePercent > 1
        {
            self.scorePercent = 1
        }
        else
        {
            self.scorePercent = scorePercent
        }

        if delegate != nil {
            delegate?.starRateView(view: self, newScorePercent: scorePercent)
        }
        super.setNeedsLayout()
    }
}
