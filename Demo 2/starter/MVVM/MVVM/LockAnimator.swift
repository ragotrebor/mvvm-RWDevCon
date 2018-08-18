/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class LockAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  let duration = 1.0
  var isPresenting = true

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView()!

    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

    let loginVC = isPresenting ? toVC as! LoginViewController : transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! LoginViewController

    containerView.addSubview(toVC.view)
    containerView.bringSubviewToFront(loginVC.view)

    var topFromFrame = loginVC.topVaultView.frame
    topFromFrame.origin.y = isPresenting ? -topFromFrame.height - loginVC.lockView.frame.height/2 : 0

    var topToFrame = loginVC.topVaultView.frame
    topToFrame.origin.y = isPresenting ? 0 : -topFromFrame.height - loginVC.lockView.frame.height/2

    var bottomFromFrame = loginVC.bottomVaultView.frame
    bottomFromFrame.origin.y = isPresenting ? containerView.frame.height : containerView.frame.height - bottomFromFrame.height

    var bottomToFrame = loginVC.bottomVaultView.frame
    bottomToFrame.origin.y = isPresenting ? containerView.frame.height - bottomFromFrame.height : containerView.frame.height

    loginVC.topVaultView.frame = topFromFrame
    loginVC.bottomVaultView.frame = bottomFromFrame

    UIView.animateWithDuration(duration, delay:0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 0.5,
      options: [],
      animations: {
        loginVC.topVaultView.frame = topToFrame
        loginVC.bottomVaultView.frame = bottomToFrame
      }, completion: { finished in
        transitionContext.completeTransition(true)
      }
    )
  }
}

extension LockAnimator: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = true
    return self
  }

  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresenting = false
    return self
  }
}

extension UIImageView {
  func setImageFromPath(path: String) {
    image = nil
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
      var image: UIImage?
      if let imageData = NSData(contentsOfFile: path) {
        image = UIImage(data: imageData)
      }

      dispatch_async(dispatch_get_main_queue()) {
        self.image = image
      }
    }
  }
}
