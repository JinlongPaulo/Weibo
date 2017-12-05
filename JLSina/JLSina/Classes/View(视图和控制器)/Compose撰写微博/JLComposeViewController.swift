//
//  JLComposeViewController.swift
//  JLSina
//
//  Created by 盘赢 on 2017/12/5.
//  Copyright © 2017年 JinLong. All rights reserved.
//

import UIKit

//撰写微博控制器
class JLComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cz_random();
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
