import Foundation
import UIKit

public class FeedbackButton: UIButton {

    private var showFeedback: (Bool) -> ()
    private var onTouchUpInside: () -> ()
    private var instanceFeedbackInProgress = false
    private static var externalFeedbackInProgress = false
    private var feedbackTimer: Timer? = nil
    private var lockTimer: Timer? = nil

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(showFeedback: @escaping (Bool) -> (), onTouchUpInside: @escaping () ->()) {
        self.showFeedback = showFeedback
        self.onTouchUpInside = onTouchUpInside
        super.init(frame: .zero)
        addTarget(self, action: #selector(touchCancel(sender:)), for: .touchCancel)
        addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
//        addTarget(self, action: #selector(touchDownRepeat(sender:)), for: .touchDownRepeat)
        addTarget(self, action: #selector(touchDragEnter(sender:)), for: .touchDragEnter)
        addTarget(self, action: #selector(touchDragExit(sender:)), for: .touchDragExit)
//        addTarget(self, action: #selector(touchDragInside(sender:)), for: .touchDragInside)
        addTarget(self, action: #selector(touchDragOutside(sender:)), for: .touchDragOutside)
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside(sender:)), for: .touchUpOutside)
    }

    @objc func touchCancel(sender: FeedbackButton) { performAction(.tapCancelled) }
    @objc func touchDown(sender: FeedbackButton) { performAction(.touchDown) }
    @objc func touchDragEnter(sender: FeedbackButton) { performAction(.tapCancelled) }
    @objc func touchDragExit(sender: FeedbackButton) { performAction(.tapCancelled) }
    @objc func touchDragOutside(sender: FeedbackButton) { performAction(.tapCancelled) }
    @objc func touchUpInside(sender: FeedbackButton) { performAction(.successfullyTapped) }
    @objc func touchUpOutside(sender: FeedbackButton) { performAction(.tapCancelled) }

    private enum Action { case touchDown, tapCancelled, successfullyTapped }
    private enum LockType { case set, release }
    private func performAction(_ action: Action) {
        func instanceLock(_ lock: LockType) {
            instanceFeedbackInProgress = lock == .set
        }
        func externalLock(_ lock: LockType) {
            Self.externalFeedbackInProgress = lock == .set
        }
        switch action {
        case .touchDown:
            guard Self.externalFeedbackInProgress == false else {
                // This will stop all instances of FeedbackButton
                return
            }
            externalLock(.set)
            showFeedback(true)

        case .tapCancelled:
            externalLock(.release)
            showFeedback(false)

        case .successfullyTapped:
            guard instanceFeedbackInProgress == false else {
                // This prevents double taps.
                return
            }
            instanceLock(.set)
            feedbackTimer?.invalidate()
            feedbackTimer = Timer.scheduledTimer(withTimeInterval: Constants.Time.feedback, repeats: false) { [weak self] _ in
                self?.onTouchUpInside()
                self?.showFeedback(false)
            }
            lockTimer?.invalidate()
            lockTimer = Timer.scheduledTimer(withTimeInterval: Constants.Time.feedbackLock, repeats: false) { _ in
                instanceLock(.release)
                externalLock(.release)
            }
        }
    }
}

