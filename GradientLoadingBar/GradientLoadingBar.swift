//
//  GradientLoadingBar.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

// Default configuration
let defaults = (
    height: 2.5,
    durations: Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)
)

public class GradientLoadingBar {
    private let height : Double
    private let durations : Durations!
    
    private lazy var gradientView : GradientView! = self.initGradientView()
    private var gradientViewAddedToWindow : Bool = false
    
    private var visibilityCounter : Int
    
    private static var instance : GradientLoadingBar?
    
    public init (
        height: Double = defaults.height,
        durations: Durations! = defaults.durations
    ) {
        self.height = height
        self.durations = durations
        
        self.visibilityCounter = 0 // Used to handle mutliple calls to show/hide at the same time
    }
    
    deinit {
        if (self.gradientViewAddedToWindow) {
            self.gradientView.removeFromSuperview()
        }
    }
    
    // MARK: Lazy Initialization
    
    func initGradientView() -> GradientView {
        let window = UIApplication.shared.keyWindow!
        let frame = window.frame
        
        let gradientView = GradientView(
            frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: CGFloat(self.height)),
            durations: durations
        )
        
        // Add view to main window
        window.addSubview(gradientView)
        self.gradientViewAddedToWindow = true
        
        // Layout
        gradientView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        
        return gradientView
    }
    
    
    // MARK: Helper to use as a Singleton
    
    public func saveInstance() {
        type(of: self).instance = self;
    }
    
    public static func sharedInstance() -> GradientLoadingBar! {
        if (instance == nil) {
            instance = GradientLoadingBar()
        }
        
        return instance!
    }
    
    
    // MARK: Show / Hide
    
    public func show() {
        if (self.visibilityCounter == 0) {
            self.gradientView.show()
        }
        
        self.visibilityCounter += 1
    }
    
    public func hide() {
        self.visibilityCounter -= 1
        
        if (self.visibilityCounter == 0) {
            self.gradientView.hide()
        }
    }
}
