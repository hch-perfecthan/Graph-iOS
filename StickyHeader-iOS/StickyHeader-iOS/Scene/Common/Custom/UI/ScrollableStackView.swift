// MIT license. Copyright (c) 2017 Gürhan Yerlikaya. All rights reserved.
import UIKit

/**
 * 스크롤 가능한 스택 뷰
 * - DispatchQueue.main.async {} 메인 스레드 안에서 addArrangedSubview를 추가해야 안정적이다.
 * - https://github.com/gurhub/ScrollableStackView
 */
@IBDesignable
public class ScrollableStackView: UIView {
    
    fileprivate var didSetupConstraints = false
    /**
     * PERFECTHAN : spacing 변수를 didSet하는 메소드 추가
     * https://medium.com/ios-development-with-swift/%ED%94%84%EB%A1%9C%ED%8D%BC%ED%8B%B0-get-set-didset-willset-in-ios-a8f2d4da5514
     */
    @IBInspectable open var spacing: CGFloat = 0 {
        didSet(oldValue) {
            self.stackView.spacing = self.spacing;
        }
    }
    open var durationForAnimations:TimeInterval = 1.45
	
    /**
     * PERFECTHAN : SwiftScrollView 스크롤뷰로 변경
     */
	public lazy var scrollView: SwiftScrollView = {
		let instance = SwiftScrollView(frame: CGRect.zero)
		instance.translatesAutoresizingMaskIntoConstraints = false
		instance.layoutMargins = .zero
		return instance
	}()

	public lazy var stackView: UIStackView = {
		let instance = UIStackView(frame: CGRect.zero)
		instance.translatesAutoresizingMaskIntoConstraints = false
		instance.axis = .vertical
		instance.spacing = self.spacing
		instance.distribution = .equalSpacing
		return instance
	}()

    //MARK: View life cycle
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
    //MARK: UI
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true

		addSubview(scrollView)
		scrollView.addSubview(stackView)

        setNeedsUpdateConstraints() // Bootstrap auto layout
    }
    
    /**
     * PERFECTHAN : 임의의 위치의 UIStackView 뷰로부터 삭제하는 메소드 추가
     */
    func removeArrangedSubview(_ view: UIView) {
        if let constraint = view.constraints.first(where: {
            $0.firstAttribute == .height
        }) {
            view.removeConstraint(constraint);
        }
        view.removeFromSuperview();
    }
    
    /**
     * PERFECTHAN : UIStackView 뷰에 추가하는 메소드 추가
     */
    func addArrangedSubview(_ view: UIView) {
        // 임의의 위치의 UIStackView 뷰로부터 삭제하는 메소드 추가
        removeArrangedSubview(view);
        
        if let constraint = view.constraints.first(where: {
            $0.firstAttribute == .height
        }) {
            constraint.constant = view.frame.size.height;
            view.layoutIfNeeded()
        } else {
            view.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        }
        self.stackView.addArrangedSubview(view);
    }
    
    /**
     * PERFECTHAN : 임의의 위치의 UIStackView 뷰에 추가하는 메소드 추가
     */
    func addArrangedSubview(_ view: UIView, at index: Int) {
        // 임의의 위치의 UIStackView 뷰로부터 삭제하는 메소드 추가
        removeArrangedSubview(view);
        
        if let constraint = view.constraints.first(where: {
            $0.firstAttribute == .height
        }) {
            constraint.constant = view.frame.size.height;
            view.layoutIfNeeded()
        } else {
            view.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        }
        self.stackView.insertArrangedSubview(view, at: index);
    }
    
    // Scrolls to item at index
    public func scrollToItem(index: Int) {
        if stackView.arrangedSubviews.count > 0 {
            let view = stackView.arrangedSubviews[index]
            
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:view.frame.origin.y), animated: true)
            })
        }
    }
    
    // Used to scroll till the end of scrollview
    public func scrollToBottom() {
        if stackView.arrangedSubviews.count > 0 {
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.scrollToBottom(true)
            })
        }
    }
    
    // Scrolls to top of scrollable area
    public func scrollToTop() {
        if stackView.arrangedSubviews.count > 0 {
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
            })
        }
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        if !didSetupConstraints {
			scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
			scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
			scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
			
			// Set the width of the stack view to the width of the scroll view for vertical scrolling
			stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
			
            didSetupConstraints = true
        }
    }
}

// Used to scroll till the end of scrollview
extension UIScrollView {
    func scrollToBottom(_ animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

/**
 * PERFECTHAN : 임의의 위치의 UIStackView 뷰의 모든 뷰 삭제
 */
extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    /*
    @discardableResult func removeAllArrangedSubviews() -> [UIView] {
        let removedSubviews = arrangedSubviews.reduce([]) { (removedSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return removedSubviews + [subview]
        }
        return removedSubviews
    }*/
}
