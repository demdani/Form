import UIKit

class FormViewController: UIViewController {
	
	let tableView = UITableView(frame: .zero, style: .grouped)
	var formData: [FormSectionModel] = []
	
	private var mutationQue: [[FormMutationType]] = []
	private var mutating = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
	}
	
	private func configureTableView() {
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
		tableView.separatorColor = .clear
		
		tableView.register(FormTextCell.nib, forCellReuseIdentifier: FormTextCell.className)
		tableView.register(FormSwitchCell.nib, forCellReuseIdentifier: FormSwitchCell.className)
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
}

// MARK: DataSource

extension FormViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return formData.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return formData[section].rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var baseCell: FormCell?
		
		let rows = formData[indexPath.section].rows
		let rowModel = rows[indexPath.row]
		
		switch rowModel.rowType {
			case .text:
				baseCell = tableView.dequeueReusableCell(withIdentifier: FormTextCell.className, for: indexPath) as? FormTextCell
			case .booleanSwitch:
				baseCell = tableView.dequeueReusableCell(withIdentifier: FormSwitchCell.className, for: indexPath) as? FormSwitchCell
			default:
				return UITableViewCell()
		}
		
		guard let cell = baseCell else { return UITableViewCell() }
		
		cell.delegate = self
		cell.update(row: rowModel)
		
		if rows.count == 1 {
			cell.roundEdgeType = .full
			cell.separatorHidden = true
		} else if indexPath.row == 0  {
			cell.roundEdgeType = .top
			cell.separatorHidden = false
		} else if indexPath.row == rows.count - 1 {
			cell.roundEdgeType = .bottom
			cell.separatorHidden = true
		} else {
			cell.roundEdgeType = .none
			cell.separatorHidden = false
		}

		return cell
	}
}

// MARK: Insert, Delete, Update

extension FormViewController {
	
	func update(mutation: [FormMutationType]) {
		guard !mutating else {
			mutationQue.append(mutation)
			return
		}
		mutate(mutation)
	}
	
	private func mutate(_ mutation: [FormMutationType]) {
		mutating = true
		
		tableView.performBatchUpdates({
			for case let .update(rowTags: tags) in mutation {
				update(rows: tags)
			}
			for case let .sectionDelete(sectionTags: tags) in mutation {
				delete(sections: tags)
			}
			for case let .rowDelete(rowTags: tags) in mutation {
				delete(rows: tags)
			}
			
			
			mutation.forEach { performUpdate(mutation: $0) }
		}) { [weak self] _ in
			guard let self = self else { return }
			self.tableView.reloadData()
			guard self.mutationQue.count == 0 else {
				let newModel = self.mutationQue.remove(at: 0)
				self.mutate(newModel)
				return
			}
			self.mutating = false
		}
	}
	
	private func performUpdate(mutation: FormMutationType) {
		switch mutation {
			case let .sectionDelete(sectionTags: tags):
			delete(sections: tags)
			case let .rowDelete(rowTags: tags):
			delete(rows: tags)
			case let .sectionInsert(sections: sections):
			insert(sections: sections)
			case let .update(rowTags: tags):
			update(rows: tags)
			default:
			print()
		}
	}
	
	private func update(rows: [String]) {
		var indexPaths: [IndexPath] = []
		rows.forEach {
			guard let currentIndexPath = indexPath(by: $0) else { return }
			indexPaths.append(currentIndexPath)
		}
		tableView.reloadRows(at: indexPaths, with: .fade)
	}
	
	private func insert(sections: [SectionInsert]) {
		sections.forEach {
			formData.insert($0.section, at: $0.index)
			tableView.insertSections(IndexSet(integer: $0.index), with: .fade)
		}
	}
	
	private func delete(rows: [String]) {
		let indexPaths = rows.compactMap({ indexPath(by: $0) }).sorted(by: { $0.row > $1.row })
		indexPaths.forEach { formData[$0.section].rows.remove(at: $0.row) }
		
		#warning("Is it necessary?")
		for (sectionIndex, section) in formData.enumerated() {
			if section.rows.count == 0 {
				formData.remove(at: sectionIndex)
				tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
			}
		}
		
		tableView.deleteRows(at: indexPaths, with: .fade)
	}
	
	private func delete(sections: [String]) {
		sections.map { findSectionIndex(by: $0) }.compactMap { $0 }.sorted(by: { $0 > $1 }).forEach {
			formData.remove(at: $0)
			tableView.deleteSections(IndexSet(integer: $0), with: .fade)
		}
	}
}

// MARK: Section and row handling

extension FormViewController {
	
	func indexPath(by tag: String) -> IndexPath? {
		for (sectionIndex, section) in formData.enumerated() {
			for (rowIndex, row) in section.rows.enumerated() {
				if row.tag == tag {
					return IndexPath(row: rowIndex, section: sectionIndex)
				}
			}
		}
		return nil
	}
	
	func findRow(by tag: String) -> FormRowModel? {
		return formData.flatMap { $0.rows }.first(where: { $0.tag == tag })
	}
	
	func findSectionIndex(by tag: String) -> Int? {
		guard let sectionModel = formData.first(where: { $0.tag == tag }) else { return nil }
		return formData.firstIndex(of: sectionModel)
	}
}

// MARK: Event handling

@objc extension FormViewController: FormDelegate {
	
	func didChange(tag: String, value: Any?) {}
}
