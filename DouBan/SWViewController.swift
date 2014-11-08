//
//  SWViewController.swift
//  
//
//  Created by Mave on 14/10/25.
//
//

import UIKit

class SWViewController: UIViewController {
    var viewcontroller:[UIViewController]

    init(centercontroller:UIViewController, leftcontroller:UIViewController, rightcontroller:UIViewController){
        super.init()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
