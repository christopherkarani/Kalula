//
//  TableDataSource.swift
//  Kalula
//
//  Created by Chris Karani on 05/10/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit



class TableDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
    typealias Configurator = (Model, UITableViewCell) -> ()
    
    let items : [Model]
    let reuseIdentifier: String
    let config : Configurator
    
    init(items: [Model], identifier: String, config: @escaping Configurator) {
        self.items = items
        self.reuseIdentifier = identifier
        self.config = config
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        config(item, cell)
        return cell
    }
}
