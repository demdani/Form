import Foundation

class TestFormViewController: FormViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		/*DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let delete = ["third", "fourth", "sixth"]
			self.updateRows(mutatingModel: FormMutatingModel(delete: delete))
			
			guard let first = self.findRow(by: "first"), let second = self.findRow(by: "second") else { return }
			first.value = DefaultFormValue(title: "Erzsi")
			second.value = DefaultFormValue(title: "60")
			self.updateRows(mutatingModel: FormMutatingModel(update: ["first", "second"]))
		}*/
	}
	
	override func didChange(tag: String, value: Any?) {
		if tag == "sixth", let value = value as? Bool {
			handleOnlineSection(value: value)
		}
	}
	
	private func handleOnlineSection(value: Bool) {
		if value {
			let dev1 = FormRowModel(tag: "dev1", title: "Zoli", rowType: .text, value: DefaultFormValue(title: "android"))
			let dev2 = FormRowModel(tag: "dev2", title: "Dani", rowType: .text, value: DefaultFormValue(title: "ios"))
			let dev3 = FormRowModel(tag: "dev3", title: "Pisti", rowType: .text, value: DefaultFormValue(title: "lead"))
			
			let section = FormSectionModel(tag: "online_section", rows: [dev1, dev2])
			let section2 = FormSectionModel(tag: "online_section_2", rows: [dev3])
			
			let sections: [SectionInsert] = [(index: formData.count, section: section),
											 (index: formData.count + 1, section: section2)]
			update(mutation: [.sectionInsert(sections: sections)])
			
			/*update(mutation: [.sectionInsert(sections: [(index: formData.count, section: section)])])
			update(mutation: [.sectionInsert(sections: [(index: formData.count, section: section2)])])*/
		} else {
			let sections = ["online_section", "online_section_2"]
			update(mutation: [.sectionDelete(sectionTags: sections)])
			
			/*update(mutation: [.sectionDelete(sectionTags: ["online_section"])])
			update(mutation: [.sectionDelete(sectionTags: ["online_section_2"])])*/
		}
	}
}
