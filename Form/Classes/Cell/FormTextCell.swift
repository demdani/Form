import UIKit

class FormTextCell: FormCell {
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var valueLabel: UILabel!
	
	override func update(row: FormRowModel) {
		super.update(row: row)
		titleLabel.text = row.title
		valueLabel.text = row.value?.title
	}
}
