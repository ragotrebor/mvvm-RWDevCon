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

class ThreatsViewController: UIViewController {
  private let cellIdentifier = "ImageCell"
  private let headerIdentifier = "HeaderView"

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // TODO: Add ViewModel Property

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: Set ViewModel Delegate
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !LoginService.isAuthenticated {
      presentLoginViewController()
    }
  }
}

// MARK: UICollectionViewDataSource
extension ThreatsViewController: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 0 // TODO: Get Number from ViewModel
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0 // TODO: Get Number from ViewModel
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell

    // TODO: Customize Cell Image from ViewModel

    return cell
  }

  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath)
        as! ResultsHeaderView

      // TODO: Set Title Text from ViewModel

      return headerView
    }

    assert(false, "Unexpected element kind")
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ThreatsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellWidth = (collectionView.bounds.width - CGFloat(30)) / 2.0
    return CGSize(width: cellWidth, height: cellWidth)
  }
}

// MARK: Actions
extension ThreatsViewController {
  @IBAction func logoutPressed() {
    LoginService.logout {
      self.presentLoginViewController() {
        // TODO: Clear data in ViewModel
      }
    }
  }
}

// MARK: Private Methods
private extension ThreatsViewController {
  func presentLoginViewController(completion: (() -> Void)? = nil) {
    let loginVC = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
    loginVC.loginSuccess = {
      self.activityIndicator.startAnimating()
      self.dismissViewControllerAnimated(true) {
        // TODO: Load data from ViewModel
      }
    }

    presentViewController(loginVC, animated: true, completion: completion)
  }
}

// TODO: Implement ViewModel Delegate
