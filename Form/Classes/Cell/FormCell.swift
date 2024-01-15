import UIKit

protocol FormDelegate: class {
	func didChange(tag: String, value: Any?)
}

enum FormCellRoundEdgeType {
	case bottom
	case top
	case full
	case none
}

class FormCell: UITableViewCell, LoadableResource, ClassName {
	
	private let cornerRadius: CGFloat = 24
	private let separatorView = UIView()
	
	@IBOutlet weak var containerView: FormContainerView!
	
	weak var delegate: FormDelegate?
	var rowModel: FormRowModel?
	var cellTag = ""
	var separatorHidden: Bool = false {
		didSet {
			separatorView.isHidden = separatorHidden
		}
	}
	var roundEdgeType: FormCellRoundEdgeType = .none {
		didSet {
			drawEdges()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		configureSeparator()
	}
	
	func update(row: FormRowModel) {
		rowModel = row
		cellTag = row.tag
	}
	
	private func configureSeparator() {
		separatorView.backgroundColor = .lightGray
		
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(separatorView)
		NSLayoutConstraint.activate([
			separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 0.5)
		])
	}
	
	private func drawEdges() {
		containerView.layer.masksToBounds = true
		containerView.layer.cornerRadius = cornerRadius
		switch roundEdgeType {
			case .full:
				containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
			case .none:
				containerView.layer.cornerRadius = 0
			case .top:
				containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
			case .bottom:
				containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		}
	}
}

class FormContainerView: UIView {
	
	var selectionEnabled = true
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard selectionEnabled else { return }
		backgroundColor = .lightGray
		alpha = 0.75
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		guard selectionEnabled else { return }
		backgroundColor = .white
		alpha = 1
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		guard selectionEnabled else { return }
		backgroundColor = .white
		alpha = 1
	}
	
	override var bounds: CGRect {
		didSet {
			renderShadow()
		}
	}
	
	private func renderShadow() {
		layer.shadowOffset = .zero
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 8
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 24).cgPath
	}
}
