import Foundation

class FormSectionModel: Hashable {
	
	let tag: String
	var rows: [FormRowModel]
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(tag)
	}
	
    static func == (lhs: FormSectionModel, rhs: FormSectionModel) -> Bool {
        return lhs.tag == rhs.tag
    }
	
	init(tag: String, rows: [FormRowModel]) {
		self.tag = tag
		self.rows = rows
	}
}
