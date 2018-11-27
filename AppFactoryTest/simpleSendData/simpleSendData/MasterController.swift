//
//  ViewController.swift
//  simpleSendData
//
//  Created by suricat on 21.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit

class MasterController: UIViewController,Delegation {

	@IBAction func askBoss(_ sender: Any) {
		// go to the bosses office
		performSegue(withIdentifier: "dataSent", sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? BossViewController {
			destination.delegate = self
			destination.closure = {
				task in
				self.executantLabel.text = task
			}
		}
	}
	@IBOutlet weak var executantLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	func sendDelegation(task: String) -> Void {
		
		executantLabel.text = task
	}
}

