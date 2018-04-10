//
//  ViewController.swift
//  Hermis
//
//  Created by Andres on 8/4/18.
//  Copyright © 2018 ghost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var picker: UIPickerView!
  @IBOutlet weak var tableView: UITableView!

  let data = [
    ("Copenhagen", ""),
    ("Barcelona", ""),
    ("London", "Heathrow"),
    ("London", "Luton"),
    ("London", "Stansted"),
    ("Berlin", "Schonefeld")
  ]

  var tableData: [(String, String)] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    picker.dataSource = self
    picker.delegate = self

    tableView.delegate = self
    tableView.dataSource = self
  }
  
  @IBAction func buttonPressed(_ sender: Any) {
    let row = picker.selectedRow(inComponent: 0)
    let city = data[row].0
    let airport = data[row].1

    URLSession.shared.dataTask(with: URL(string: "http://127.0.0.1:5000?city=\(city)&airport=\(airport)")!) { data ,_,_ in

      if let data = data,
        let json = try? JSONSerialization.jsonObject(with: data),
        let array = json as? [[String: Any]] {

        var results: [(String, String)] = []
        for element in array {
          if let head = element["head"] as? String, let sources = element["sources"] as? [String] {
            let string = sources.joined(separator: "\n.")
            results.append((head, string))
          }
        }

        self.tableData = results
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }.resume()
  }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return data.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    var result = data[row].0
    if data[row].1.count > 0 {
      result += ", \(data[row].1)"
    }
    return result
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
    cell.textLabel?.text = tableData[indexPath.row].0
    cell.detailTextLabel?.text = tableData[indexPath.row].1
    return cell
  }
}
