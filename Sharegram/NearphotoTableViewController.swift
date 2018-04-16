//
//  NearphotoTableViewController.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 4. 11..
//  Copyright © 2018년 박주영. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import ScrollableSegmentedControl
import SDWebImage

class NearphotoTableViewController: UITableViewController,CLLocationManagerDelegate {

    var object = variable()
let segment = ScrollableSegmentedControl()
var ref : DatabaseReference?
let locationManager = CLLocationManager()
var location = CLLocation() //현재위치받을친구
var location2 = CLLocation()
    struct MyLocation {
        var postimg : String? = nil
        var profilename : String? = nil
        var postid : String? = nil
        var description : String? = nil
        var date : String? = nil
        var longitude : Double? = nil
        var latitude : Double? = nil
    }
var locationArray = [MyLocation]() //스냅샷한거 배열별로들어감.
   

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    //this method is called by the framework on         locationManager.requestLocation();
    //현재위치저장
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        print("Did location updates is called")
        object.lat = location.coordinate.latitude
        object.lon = location.coordinate.longitude
        //store the user location here to firebase or somewhere
    }
    func DataInput(_ distanse : Int) { //
        self.locationArray.removeAll()
        ref?.child("WholePosts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Nothing")
            } else {
                if let item = snapshot.value as? [String : AnyObject] {
                    for (_, value) in item {
                        if let Description = value["Description"] as? String, let Author = value["Author"] as? String, let Date = value["Date"] as? String, let ID = value["ID"] as? String, let image = value["image"] as? String , let postID = value["postID"] as? String {
                            if value["latitude"] as? String != nil { //위치가 있는 게시물들만
                                let lat = value["latitude"] as? String
                                let lon = value["longitude"] as? String
                                let location2 = CLLocation(latitude: Double(lat!)!, longitude: Double(lon!)!)
                                let meter = Int(self.location.distance(from: location2))
                                print(meter)
                                var data = MyLocation()
                                if distanse == 100 {
                                if meter <= 100 { //100미터
                                    data.description = Description
                                    data.postimg = image
                                    data.longitude = Double(lat!)!
                                    data.latitude = Double(lat!)!
                                    data.profilename = Author
                                    data.postid = postID
                                    data.date = Date
                                   
                                    self.locationArray.append(data)
                                    print(self.locationArray)
                                    }
                                    
                                }else if distanse == 500 {
                                    if meter <= 500 { //500이내
                                    
                                    data.description = Description
                                    data.postimg = image
                                    data.longitude = Double(lat!)!
                                    data.latitude = Double(lat!)!
                                    data.profilename = Author
                                    data.postid = postID
                                    data.date = Date
                                    
                                    self.locationArray.append(data)
                                    } } else if distanse == 1000 { //나중에 뺼꺼
                                    data.description = Description
                                    data.postimg = image
                                    data.longitude = Double(lat!)!
                                    data.latitude = Double(lat!)!
                                    data.profilename = Author
                                    data.postid = postID
                                    data.date = Date
                                    
                                    self.locationArray.append(data)
                                }
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        })
        ref?.removeAllObservers()
    }

   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
   
        tableView.dataSource = self
        
        segment.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
        self.view.addSubview(segment)
        segment.segmentStyle = .textOnly
        segment.insertSegment(withTitle: "100m", at: 0)
        segment.insertSegment(withTitle: "500m", at: 1)
        segment.insertSegment(withTitle: "그 외", at: 2) //예시용
        segment.underlineSelected = true
        segment.addTarget(self, action: #selector(ActSegClicked), for: .valueChanged)
        segment.segmentContentColor = UIColor.black
        segment.selectedSegmentContentColor = UIColor.black
        segment.backgroundColor = UIColor.white
        segment.selectedSegmentIndex = 0
        
        let largerRedTextHighlightAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.blue]
        let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.orange]
        segment.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        segment.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)
        
        let SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeftAction))
        SwipeLeft.direction = .left
  
        let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRightAction))
        SwipeRight.direction = .right
        
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    @objc func SwipeLeftAction() {
        segment.selectedSegmentIndex += 1
    }
    @objc func SwipeRightAction() {
        segment.selectedSegmentIndex -= 1
    }
    @objc func ActSegClicked(_ sender : ScrollableSegmentedControl) {
        if segment.selectedSegmentIndex == 0 { // 100
            print("세그먼트1")
          print(self.locationArray)
            tableView.reloadData()
//            self.locationArray.removeAll()
            DataInput(100)

          tableView.reloadData()
        
        }  else if segment.selectedSegmentIndex == 1 { // 500
            print("세그먼트2")
            
            self.locationArray.removeAll()
  
            tableView.reloadData()
            DataInput(500)
            tableView.reloadData()
            
        } else if segment.selectedSegmentIndex == 2{
            self.locationArray.removeAll()
            tableView.reloadData()
            DataInput(1000)
            tableView.reloadData()
        }

            }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       print(locationArray.count)
        return locationArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let label = cell.viewWithTag(2) as? UILabel
        label?.text = locationArray[indexPath.row].description
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.sd_setImage(with:URL(string: locationArray[indexPath.row].postimg!))
        
    

        return cell
    }
    
    override func tableView(_ tableview: UITableView, didSelectRowAt: IndexPath){
               //여기서 locationArray에 있는 정보를 postcell에 맞게 뿌림
            }
}
 

