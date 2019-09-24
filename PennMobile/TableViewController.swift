//
//  TableViewController.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/20/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import UIKit
import Foundation

//CellData carries the information gathered from the api for each cell in the tableview
struct CellData{
    let name : String!
    let open : Bool!
    let hours : String!
    let imageUrl : String!
    let facilityURL: String!
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    //label for the date
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    //2D array that holds the cell data, divided by retail vs. residential
    var arrayOfCellData = [[CellData]]()
    var currentDate = ""
    var currentTime = ""
    var months = ["January", "Feburary", "March", "April", "May", "June", "July", "August", "Sepetember", "November", "December"]
    var daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wendesday", "Thursday", "Friday", "Saturday"]
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCellData.append([CellData]())
        arrayOfCellData.append([CellData]())
        parseUrl(theUrl: "http://api.pennlabs.org/dining/venues")
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //current date and time used to calculate what places are open
        currentDate = String(format.string(from: Date()).dropLast(9))
        currentTime = String(format.string(from: Date()).dropFirst(11))
        //displays current date
        dateLabel.text = daysOfWeek[Calendar.current.component(.weekday, from: Date())-1] + " " + months[Int(String(format.string(from: Date()).dropFirst(5).dropLast(12)))!-1] + " " + currentDate.dropFirst(8)
    }
    //isOpen takes in an array of times, odd indexed times are open times, even indexed times are closing times. Calculates if current time is open.
    func isOpen(times:[String]) -> Bool{
        let currentHour = Int(currentTime.dropLast(6))!
        let currentMin = Int(currentTime.dropLast(3).dropFirst(3))!
        let currentTimeInMinutes = currentHour*60 + currentMin
        for i in stride(from: 0, through: times.count-1, by: 2) {
            let openHour = Int(times[i].dropLast(6))!
            let closeHour = Int(times[i+1].dropLast(6))!
            let openMin = Int(times[i].dropLast(3).dropFirst(3))!
            let closeMin = Int(times[i+1].dropLast(3).dropFirst(3))!
            let closeInMinutes = closeHour*60 + closeMin
            let openInMinutes = openHour*60 + openMin
            if currentTimeInMinutes<closeInMinutes && currentTimeInMinutes>openInMinutes{
                return true
            }
        }
        return false
    }
    //organizeTimes takes in an array of times, odd indexed times are open times, even indexed times are closing times. Creates a string to be displayed that represents the hours for a certain venue.
    func organizeTimes(times:[String])-> String{
        var adjustedTimes = times
        var stringTime = ""
        for i in stride(from: adjustedTimes.count-4, through: -1, by: -2) {
            let firstCloseHour = Int(adjustedTimes[i+1].dropLast(6))!
            let firstCloseMin = Int(adjustedTimes[i+1].dropLast(3).dropFirst(3))!
            let secondOpenHour = Int(adjustedTimes[i+2].dropLast(6))!
            let secondOpenMin = Int(adjustedTimes[i+2].dropLast(3).dropFirst(3))!
            let secondCloseHour = Int(adjustedTimes[i+3].dropLast(6))!
            let secondCloseMin = Int(adjustedTimes[i+3].dropLast(3).dropFirst(3))!
            if firstCloseHour*60 + firstCloseMin >= secondOpenHour*60 + secondOpenMin{
                if secondCloseHour*60 + secondCloseMin > firstCloseHour*60 + firstCloseMin{
                    adjustedTimes[i+1] = adjustedTimes[i+3]
                }
                adjustedTimes.remove(at: i+2)
                adjustedTimes.remove(at: i+2)
            }
        }
        for i in stride(from: 0, through: adjustedTimes.count-1, by: 2) {
            let openHour = Int(adjustedTimes[i].dropLast(6))!
            let closeHour = Int(adjustedTimes[i+1].dropLast(6))!
            let openMin = Int(adjustedTimes[i].dropLast(3).dropFirst(3))!
            let closeMin = Int(adjustedTimes[i+1].dropLast(3).dropFirst(3))!
            var range = ""
            var timeBody = ""
            if openMin == 0 && openHour == 12{
                timeBody = String(12)
            }
            else if openMin == 0{
                timeBody = String(openHour%12)
            }
            else if openHour == 12{
                timeBody = String(12) + ":" + String(openMin)
            }
            else{
                timeBody = String(openHour%12) + ":" + String(openMin)
            }
            if adjustedTimes.count == 2{
                if openHour >= 12{
                    range += timeBody + "p - "
                }
                else{
                    range += timeBody + "a - "
                }
            }
            else{
                range += timeBody + " - "
            }
            if closeMin == 0 && closeHour == 12{
                timeBody = String(12)
            }
            else if closeMin == 0{
                timeBody = String(closeHour%12)
            }
            else if closeHour == 12{
                timeBody = String(12) + ":" + String(closeMin)
            }
            else{
                timeBody = String(closeHour%12) + ":" + String(closeMin)
            }
            if adjustedTimes.count == 2{
                if closeHour >= 12{
                    range += timeBody + "p"
                }
                else{
                    range += timeBody + "a"
                }
            }
            else{
                range += timeBody
            }
            if i < adjustedTimes.count-3{
                stringTime += range + " | "
            }
            else{
                stringTime += range
            }
        }
        return stringTime
    }
    //parseUrl reads information from the api and loads the data into arrayOfCellData
    func parseUrl(theUrl:String) {
        let url = URL(string: theUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                DispatchQueue.main.asyncAfter(deadline: .now() ){
                    
                }
            }
            else{
                do{
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    DispatchQueue.main.async {
                        for(_, outer1) in parsedData{
                            if let outer2:[String:Any] = outer1 as?[String:Any]{
                                for (_,document) in outer2 {
                                    if let venue:[[String:Any]] = document as?[[String:Any]]{
                                        for dict in venue{
                                            var open = false
                                            var hours = ""
                                            var times = [String]()
                                            //parsing opening and closing data
                                            if let dateHours = dict["dateHours"] as? [[String:Any]]{
                                                for d in dateHours{
                                                    if let date = d["date"] as? String?, date == self.currentDate{
                                                        if let meal = d["meal"] as? [[String:String]]{
                                                            for j in meal{
                                                                if let close = j["close"] as? String, let open = j["open"] as? String, let type = j["type"] as? String{
                                                                    if type != "Closed"{
                                                                        times.append(open)
                                                                        times.append(close)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                if times.count == 0{
                                                    hours = "CLOSED TODAY"
                                                }
                                                else{
                                                    hours = self.organizeTimes(times: times)
                                                }
                                                open = self.isOpen(times: times)
                                            }
                                            //parsing all other important information
                                            if let name = dict["name"] as? String, let imageUrl = dict["imageUrl"] as? String, let venueType = dict["venueType"] as? String, let facilityURL = dict["facilityURL"] as? String{
                                                print(name)
                                                if venueType == "residential"{
                                                    self.arrayOfCellData[0].append(CellData(name: name, open: open, hours: hours,imageUrl: imageUrl, facilityURL: facilityURL))
                                                    self.tableView.reloadData()
                                                }
                                                else{
                                                    self.arrayOfCellData[1].append(CellData(name: name, open: open, hours: hours,imageUrl: imageUrl, facilityURL: facilityURL))
                                                    self.tableView.reloadData()
                                                }
                                                self.tableView.estimatedRowHeight = 0;
                                                self.tableView.estimatedSectionHeaderHeight = 0;
                                                self.tableView.estimatedSectionFooterHeight = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch let error as NSError{
                    print(error)
                    DispatchQueue.main.asyncAfter(deadline:.now()){
                        
                    }
                }
            }
            
            }.resume()
    }
    //Sections is the amount of data in array
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfCellData.count
    }
    // One row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData[section].count
    }
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //Creates the header for the two sections, "Dining Halls" and "Retail Dining"
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if section == 0{
            label.text = "Dining Halls"
        }
        else{
            label.text = "Retail Dining"
        }
        label.font = UIFont.init(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "SF Pro Text",UIFontDescriptor.AttributeName.textStyle : "Bold"]), size: 28)
        headerView.addSubview(label)
        
        return headerView
    }
    
    //Creates the tableview cells and modifies appearence
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
        let imageUrlString = arrayOfCellData[indexPath.section][indexPath.row].imageUrl
        let imageUrl = URL(string: imageUrlString!)
        let imageData = try! Data(contentsOf: imageUrl!)
        cell.mainImageView.image = UIImage(data: imageData)
        cell.mainImageView.contentMode = .scaleToFill
        cell.mainImageView.layer.cornerRadius = 8.0
        cell.mainImageView.clipsToBounds = true
        cell.nameLabel.text = arrayOfCellData[indexPath.section][indexPath.row].name
        if arrayOfCellData[indexPath.section][indexPath.row].open{
            cell.openLabel.textColor = UIColor(red:0.13, green:0.61, blue:0.93, alpha:1.0)
            cell.openLabel.text = "OPEN"
        }
        else{
            cell.openLabel.textColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
            cell.openLabel.text = "CLOSED"
        }
        cell.hoursLabel.text = arrayOfCellData[indexPath.section][indexPath.row].hours
        
        return cell
    }
    //Perform segue to webView when clicked
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "showLinks", sender: self)
    }
    //segue to webView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLinks" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destination = segue.destination as? WebViewController
                destination?.links = arrayOfCellData[indexPath.section][indexPath.row].facilityURL
            }
        }
    }
    //Height of table view cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }

}
