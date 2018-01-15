//
//  PdfViewController.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 11/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {
    @IBOutlet weak var pdfTableView: UITableView!
    @IBOutlet weak var addPdfBtn: UIButton!
    @IBOutlet var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFooterView()
    }
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        pdfTableView.tableFooterView = footerView
        let titleColor = addPdfBtn.titleColor(for: .normal)
        addPdfBtn.setRadius(10, titleColor!, 2)
        
        
    }
}
extension PdfViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (dataModel?.data?.count)!
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pdfTableCell", for: indexPath) as! pdfTableCell;
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.white // set your default color
        }
     
        return cell
    }
    
}
extension PdfViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }


}

