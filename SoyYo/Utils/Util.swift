//
//  Util.swift
//  SoyYo
//
//  Created by Oscar Julian on 28/08/21.
//  Copyright © 2021 Oscar Julian Gil Bernal. All rights reserved.
//

import Foundation
import UIKit

class Util{

 internal static var spinner: UIActivityIndicatorView?
    // utility function to show a spinner for long tasks
    static func showSpinner() {
        let style: UIActivityIndicatorView.Style = .whiteLarge
        let backColor = UIColor.black.withAlphaComponent(0.5)
        let baseColor = UIColor.black
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    // utility function to stop the spinner
    static func stopSpinner() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
}
