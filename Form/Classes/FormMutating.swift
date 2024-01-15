import Foundation

typealias SectionInsert = (index: Int, section: FormSectionModel)
typealias RowInsert = (sectionIndex: Int, rowIndex: Int, row: FormRowModel)

enum FormMutationType {
	case sectionInsert(sections: [SectionInsert])
	case rowInsert(rows: [RowInsert])
	case sectionDelete(sectionTags: [String])
	case rowDelete(rowTags: [String])
	case update(rowTags: [String])
}
