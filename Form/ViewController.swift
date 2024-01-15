//
//  ViewController.swift
//  Form
//
//  Created by Demjen Daniel on 2019. 12. 16..
//  Copyright © 2019. test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	private var formData: [FormSectionModel] {
		var sections: [FormSectionModel] = []
		
		let textRow = FormRowModel(tag: "first", title: "Name", rowType: .text, value: DefaultFormValue(title: "Józsi", value: nil))
		let textRow2 = FormRowModel(tag: "second", title: "Age", rowType: .text, value: DefaultFormValue(title: "22", value: nil))
		let textRow3 = FormRowModel(tag: "third", title: "Sex", rowType: .text, value: DefaultFormValue(title: "male", value: nil))
		let textRow4 = FormRowModel(tag: "fourth", title: "Color", rowType: .text, value: DefaultFormValue(title: "green", value: nil))
		
		let switchRow = FormRowModel(tag: "fifth", title: "Boolean", rowType: .booleanSwitch, value: DefaultFormValue(value: true))
		let switchRow2 = FormRowModel(tag: "sixth", title: "Online", rowType: .booleanSwitch, value: DefaultFormValue(value: false))
		
		let section = FormSectionModel(tag: "first_section", rows: [textRow, switchRow])
		let section2 = FormSectionModel(tag: "second_section", rows: [textRow3, switchRow2, textRow2])
		let section3 = FormSectionModel(tag: "third_section", rows: [textRow4])
		
		sections.append(section)
		sections.append(section2)
		sections.append(section3)

		return sections
	}

	@IBAction private func didTapButton(_ sender: Any) {
		let vc = TestFormViewController()
		vc.formData = formData
		navigationController?.pushViewController(vc, animated: true)
	}
}

