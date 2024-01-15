import UIKit

class FormSwitchCell: FormCell {
    
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var booleanSwitch: UISwitch!
	
	override func update(row: FormRowModel) {
		super.update(row: row)
		titleLabel.text = row.title
		booleanSwitch.isOn = row.value?.value as? Bool ?? false
	}
	
	@IBAction private func didChangeValue(_ sender: Any) {
		rowModel?.value = DefaultFormValue(value: booleanSwitch.isOn)
		delegate?.didChange(tag: cellTag, value: booleanSwitch.isOn)
	}
}
