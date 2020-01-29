//
//  KeyboardGuardian.swift
//  MovieStore
//
//  Created by Maciej Krysiak on 30/12/2019.
//  Copyright © 2019 Maciej Krysiak. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class KeyboardGuardian: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()

    public var rects: Array<CGRect>
    public var keyboardRect: CGRect = CGRect()

    // keyboardWillShow notification may be posted repeatedly,
    // this flag makes sure we only act once per keyboard appearance
    public var keyboardIsHidden = true

    public var slide: CGFloat = 0 {
        didSet {
            objectWillChange.send()
        }
    }

    public var showField: Int = 0 {
        didSet {
            updateSlide()
        }
    }

    init(textFieldCount: Int) {
        self.rects = Array<CGRect>(repeating: CGRect(), count: textFieldCount)

        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
                updateSlide()
            }
        }
    }

    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsHidden = true
        updateSlide()
    }

    func updateSlide() {
        if keyboardIsHidden {
            slide = 0
        } else {
            let tfRect = self.rects[self.showField]
            let diff = keyboardRect.minY - tfRect.maxY
            print("tfRect", tfRect, "\nself.showField", self.showField)
            if diff > 0 {
                slide += diff
            } else {
                slide += min(diff, 0)
            }
        }
    }
}
