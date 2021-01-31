//
//  PBJTableBuilder.swift
//  PBJCore
//
//  Created by Ian Clawson on 2/22/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

//        let identitySection = PBJTableSection(
//            header: .init(title: "Identity", height: 30),
//            rows: [
//                PBJTableRow<TagsTableViewCell>(
//                    item: (
//                        labelTitle: self.tags.isEmpty ? "No Tags (required)" : "",
//                        tagTitles: self.tags.map { $0.capitalized },
//                        cellDelegate: self,
//                        tagsDelegate: self
//                    ),
//                    actions: [
//                        .select(displayTagPicker)
//                    ]
//                ),
//                PBJTableRow<SegmentedTableViewCell>(item: (
//                    segmentTitles: ["For Boys", "Either", "For Girls"],
//                    selectedSegmentIndex: self.selectedSexIndex,
//                    tag: 1,
//                    delegate: self)),
//                PBJTableRow<SegmentedTableViewCell>(item: (
//                    segmentTitles: ["For Younger", "Either", "For Older"],
//                    selectedSegmentIndex: self.selectedAgeIndex,
//                    tag: 2,
//                    delegate: self))
//        ])
//
//        let optionsSection = PBJTableSection(
//            header: .init(title: "Options", height: 30),
//            rows: [
//                PBJTableRow<SwitchTableViewCell>(item: (
//                    title: switchTitle,
//                    isSwitchOn: assetIsHidden,
//                    tag: 0,
//                    delegate: self))
//        ])
//
//        self.builder = PBJTableBuilder(with: self.tableView, sections: [identitySection, optionsSection])

// OVERALL:: I like!! However, there are datasource issues.
// The data source is _INSIDE_ the builder, so all my efforts to change stuff here in the vc will have no effect.
// This is a problem, because I have a ton of custom cells that use delegates to update data.
//
// Thinking through this some more, I do see why the table view is designed the way it is, with datasource delegate methods.
// in order for this to really work, the builder still needs to somehow reference the data that is stored here in the view controller.......
// Hm.... need to think about that
//
// There COULD be a method that rebuilds the table each time data changes, but that wouldn't be good.
// Maybe enum style is the way to go after all, that's KINDA like a builder... And then this can be used for tables that only display data?
// Either way it was fun to try!

public final class PBJTableBuilder: NSObject {
    public private(set) weak var tableView: UITableView!
    public private(set) var sections: [PBJTableSection]
    
    public init(with tableView: UITableView, sections: [PBJTableSection]) {
        self.tableView = tableView
        self.sections = sections
        
        super.init()
        
        setDataSourceDelegate()
        initCells()
    }
    
    public init(with tableView: UITableView, rows: [PBJConfigurableRow]) {
        self.tableView = tableView
        self.sections = [PBJTableSection(rows: rows)]
        
        super.init()
        
        setDataSourceDelegate()
        initCells()
    }
    
    public init(with tableView: UITableView) {
        self.tableView = tableView
        self.sections = [PBJTableSection(rows: [])]
        
        super.init()
        
        setDataSourceDelegate()
    }
    
    private func initCells() {
        sections
            .flatMap { $0.rows }
            .compactMap { ($0.nib, $0.cellClass, $0.reuseId) }
            .forEach { nib, cellClass, reuseId in
                print(cellClass)
                tableView.registerCells(cellClass, reuseId: reuseId)
        }
    }
    
    private func setDataSourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

//MARK: - TableBuilder Operations

public extension PBJTableBuilder {
    func reloadData() { tableView.reloadData() }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sections[section].numberOfRows()
    }
    
    @discardableResult
    func append(section: PBJTableSection) -> Self {
        sections.append(section)
        return self
    }

    @discardableResult
    func add(sections: [PBJTableSection]) -> Self {
        self.sections.append(contentsOf: sections)
        return self
    }
    
    @discardableResult
    func insert(section: PBJTableSection, at index: Int) -> Self {
        sections.insert(section, at: index)
        return self
    }
    
    @discardableResult
    func replace(section: PBJTableSection, at index: Int) -> Self {
        if index >= 0 && index < sections.count {
            sections += [section]
        }
        return self
    }
    
    func remove(at index: Int) -> PBJTableSection? {
        guard index >= 0 && index < numberOfSections() else { return nil }
        return sections.remove(at: index)
    }
    
    @discardableResult
    func removeAll() -> Self {
        sections.removeAll()
        return self
    }
}

//MARK: - Register Cells from Nib or Class

private extension UITableView {
    func registerCells(_ cellClass: AnyClass, reuseId: String) {
        let bundle = Bundle(for: cellClass)
        let path = bundle.path(forResource: String(describing: cellClass), ofType: "nib")
        
        switch path {
        case .some:
            register(UINib(nibName: String(describing: cellClass),
                           bundle: bundle),
                     forCellReuseIdentifier: reuseId)
        case .none:
            register(cellClass, forCellReuseIdentifier: reuseId)
        }
    }
}

//MARK: - TableView DataSource

extension PBJTableBuilder: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowBuilder = sections[indexPath.section][indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: rowBuilder.reuseId
        ) else { fatalError() }
        
        rowBuilder.configure(cell: cell)
        
        return cell
    }
}

//MARK: - TableView Delegate

extension PBJTableBuilder: UITableViewDelegate {
//    public func tableView(_ tableView: UITableView,
//                          heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let rowBuilder = sections[indexPath.section][indexPath.row]
//        return rowBuilder.height
//    }
    
    public func tableView(_ tableView: UITableView,
                          viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].header?.view
    }
    
//    public func tableView(_ tableView: UITableView,
//                          heightForHeaderInSection section: Int) -> CGFloat {
//        return sections[section].header?.height ?? 0
//    }
    
    public func tableView(_ tableView: UITableView,
                          titleForHeaderInSection section: Int) -> String? {
        return sections[section].header?.title
    }
    
    public func tableView(_ tableView: UITableView,
                          viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footer?.view
    }
    
    public func tableView(_ tableView: UITableView,
                          heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footer?.height ?? 0
    }
    
    public func tableView(_ tableView: UITableView,
                          titleForFooterInSection section: Int) -> String? {
        return sections[section].footer?.title
    }
    
    public func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
        let row = sections[indexPath.section][indexPath.row]
        return row.actions.filter {
            guard case PBJTableAction.edit = $0 else { return false }
            return true
        }.count > 0
    }
    
    public func tableView(_ tableView: UITableView,
                          editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = sections[indexPath.section][indexPath.row]
        
        return row.actions.reduce([]) { result, action -> [(UITableViewRowAction, UIColor)]? in
            guard case let .edit(actions) = action,
                let res = result else { return nil }
            return res + actions
        }?.map { $0.backgroundColor = $1; return $0 }
    }
    
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section][indexPath.row]
        row.actions.forEach {
            guard case PBJTableAction.select(let action) = $0 else { return }
            action(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          didDeselectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section][indexPath.row]
        row.actions.forEach {
            guard case PBJTableAction.deselect(let action) = $0 else { return }
            action(indexPath)
        }
    }
}
#endif
