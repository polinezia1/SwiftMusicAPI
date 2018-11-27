//
//  BossViewController.swift
//  simpleSendData
//
//  Created by suricat on 21.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit


protocol Delegation{
	func sendDelegation(task: String) -> Void
}

class BossViewController: UIViewController {

	var delegate: Delegation?
	
	var closure: ((_ task: String) -> Void)?
	
	@IBAction func delegationAction(_ sender: UIButton) {
		// send button title by delegate
		delegate?.sendDelegation(task: (sender.titleLabel?.text)!)
		self.dismiss(animated: true, completion: nil)
	}
	@IBAction func closureAction(_ sender: UIButton) {
		// send button title by closure
		closure?((sender.titleLabel?.text)!)
		self.dismiss(animated: true, completion: nil)
	}
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
