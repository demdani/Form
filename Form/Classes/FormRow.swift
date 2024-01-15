import UIKit

protocol FormValue {
	var title: String? { get set }
	var value: Any? { get set }
}

struct DefaultFormValue: FormValue {
	var title: String? = nil
	var value: Any? = nil
}

enum FormRowType {
	case input
	case booleanSwitch
	case text
	case longText
}

class FormRowModel: Hashable {
	let tag: String
	let title: String
	let rowType: FormRowType
	var value: FormValue?
	var placeholder: String?
	var keyboard: UIKeyboardType?
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(tag)
	}
	
	static func == (lhs: FormRowModel, rhs: FormRowModel) -> Bool {
        return lhs.tag == rhs.tag
    }
	
	init(tag: String, title: String, rowType: FormRowType, value: FormValue? = nil, placeholder: String? = nil, keyboard: UIKeyboardType? = nil) {
		self.tag = tag
		self.title = title
		self.rowType = rowType
		self.value = value
		self.placeholder = placeholder
		self.keyboard = keyboard
	}
}
