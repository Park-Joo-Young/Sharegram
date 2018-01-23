//
//  CameraViewController.swift
//  Sharegram
//
//  Created by 박주영 on 2018. 1. 11..
//  Copyright © 2018년 박주영. All rights reserved.
//
// 바로 업로드 뷰
import UIKit
import SnapKit
import Firebase
import CoreLocation
import MobileCoreServices
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBAction func ActCamera(_ sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flag = true
            imagepicker.delegate = self
            imagepicker.sourceType = .camera
            imagepicker.mediaTypes = [kUTTypeImage as String]
            imagepicker.allowsEditing = false
            
            present(imagepicker, animated: true, completion: nil)
        }
    }
  
    @IBAction func ActPhoto(_ sender: UIBarButtonItem) {
        flag = false
        if flag == false {
            object.lat = 0
            object.lon = 0
        }
        print("\(object.lat) , \(object.lon)")
        grabPhotos()
    }
    
    @IBAction func ActNext(_ sender: UIBarButtonItem) { // 다음화면 넘어가기
        performSegue(withIdentifier: "write", sender: self)
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var PhotoCollection: UICollectionView!
    
    let locationManager = CLLocationManager()
    var location : CLLocation!
    var object = variable()
    var imageArray = [UIImage]()
    let imagepicker : UIImagePickerController! = UIImagePickerController()
    var capture : UIImage!
    var flag = false
    
    var ref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        isAuthorizedtoGetUserLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        myImageView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height/2)
            make.top.equalTo(self.view).offset(44)
        }
        PhotoCollection.snp.makeConstraints { (make) in
            make.size.equalTo(myImageView)
            make.top.equalTo(myImageView.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        // Do any additional setup after loading the view.
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        locationManager.requestLocation()
        locationManager.stopUpdatingLocation()
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            capture = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let imageData : Data = UIImageJPEGRepresentation(capture, 0.9)!
//            self.baseString = imageData.base64EncodedString(options: .init(rawValue: 0))
            
            if flag {
                //UIImageWriteToSavedPhotosAlbum(capture, self, nil, nil) //사진 저장
                if CLLocationManager.locationServicesEnabled() {
                    if location != nil {
                        print("\(object.lat) , \(object.lon)")
                        //convertToAddressWith(coordinate: location)
                    }
                    
                }
            }
            imageArray.removeAll()
            self.PhotoCollection.reloadData()
            myImageView.image = capture
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    //this method is called by the framework on         locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        print("Did location updates is called")
        object.lat = location.coordinate.latitude
        object.lon = location.coordinate.longitude
        //store the user location here to firebase or somewhere
    }
    func grabPhotos() {
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    self.imageArray.append(image!)
                    self.myImageView.image = self.imageArray[0]
                })
            }
        } else {
                print("You got no Photos!")
            }
        print(imageArray.count)
        DispatchQueue.main.async {
            self.PhotoCollection.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myImageView.image = imageArray[indexPath.row]
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = PhotoCollection.frame.width / 4 - 1
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "write" {
            let destination = segue.destination as! WriteViewController
            destination.writeImage = myImageView.image
            destination.object.lat = object.lat
            destination.object.lon = object.lon
        }
    }
 

}
