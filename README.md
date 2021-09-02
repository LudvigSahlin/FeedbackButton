# FeedbackButton

This package is used to easily create tap feedback.
 - Add a tap recognizer to any given UIView by adding a subclassed UIButton as a subview.
 - Specify code to be run when the view is tapped (touchDown).
 - Specify code to be run when the tap is finished in any way (touchUpInside, touchCancel, touchDragExit, etc.).
 - Specify code to be run when the tap is released inside the view (touchUpInside).

 Important:
 - Prevents double taps. If any tap is currently being handled, all other taps on any FeedbackButton will be ignored.



# Usage:

Typically you would create an extension function to UIView like this:

    extension UIView {
        func applyFeedback(showFeedback: @escaping (Bool) -> (), onTouchUpInside: @escaping () -> ()) {
            let feedbackButton = FeedbackButton(showFeedback: showFeedback, onTouchUpInside: onTouchUpInside)
            addSubview(feedbackButton)
            feedbackButton.constrainTo(self, .allBorders) // Note: This function is defined in the Swift package "Constraint".
        }
    }

Then you can specify the desired code for any UIView that should react on tap events:

    xBackgroundView.applyFeedback(showFeedback: { feedback in
        if feedback {
            xImageView.tintColor = .systemGray5
        } else {
            xImageView.tintColor = .systemGray4
        }
    }, onTouchUpInside: {
        textField.text = ""
        textField.becomeFirstResponder()
    })



# License

The contents of this repository is licensed under the
[Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).



# Contact

ludvigsahlin2@gmail.com
