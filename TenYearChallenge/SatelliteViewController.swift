//
//  SatelliteViewController.swift
//  TenYearChallenge
//
//  Created by 連振甫 on 2021/7/25.
//

import UIKit

class SatelliteViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var autoSwitch: UISwitch!
    
    var selectedDateComponets = DateComponents()
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupSelectedDateComponets()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPhoto()
    }
    
    func setupSelectedDateComponets() {
        selectedDateComponets.calendar = Calendar.current
        selectedDateComponets.year = 2016
        selectedDateComponets.month = 1
        
        datePicker.setDate(selectedDateComponets.date!, animated: true)
    }
    
    @IBAction func selectedDate(_ sender: UIDatePicker) {
        setPhoto()
    }
    @IBAction func seekYearAction(_ sender: UISlider) {
        let addMonth = Int(sender.value)
        let curremtDateComponents = Calendar.current.dateComponents(in: .current, from: datePicker.minimumDate!)
        
        
        if addMonth%12 == 1,addMonth/12 > 0 {
            selectedDateComponets.year = curremtDateComponents.year! + addMonth/12
            selectedDateComponets.month = addMonth%12
        }else if addMonth%12 == 0,addMonth/12 > 0 {
            selectedDateComponets.month = 12
        }else{
            selectedDateComponets.year = curremtDateComponents.year! + addMonth/12
            selectedDateComponets.month = addMonth%12
        }
        
        datePicker.setDate(selectedDateComponets.date!, animated: true)
        self.selectedDate(datePicker)
    }
    
    @IBAction func autoSwitchAction(_ sender: UISwitch) {
        timer?.invalidate()
        timer = nil
        if sender.isOn {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {[weak self] _ in
                if let slider = self?.slider {
                    self?.slider.value += 1
                    self?.seekYearAction(slider)
                    if slider.value == slider.maximumValue {
                        self?.autoSwitch.isOn = false
                        self?.timer?.invalidate()
                        self?.timer = nil
                    }
                }
            })
        }
    }
    
    func setPhoto() {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM"
        let queryDate = dateFormatter.string(from: date)
        dateLabel.text = queryDate
        spinner.startAnimating()
        LocationManager.shared.getSatellitePhoto(from: queryDate, completion: { [weak self] date,image in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                if date == self?.dateLabel.text {
                    self?.imageView.image = image
                }
                
            }
        })
    }
}
