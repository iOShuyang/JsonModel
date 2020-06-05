//
//  MainWindowController.swift
//  JsonModel
//
//  Created by 胡洋 on 2018/1/27.
//  Copyright © 2020年 胡洋. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    lazy var mainViewController: MainViewController = {
        let mainVc = MainViewController()
        return mainVc
    }()

    override func windowDidLoad() {
        super.windowDidLoad()
        contentViewController = mainViewController
        window?.delegate = self
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name(rawValue: "MainWindowController")
    }

}

extension MainWindowController: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        //print("关闭窗口了")
        return true;
    }
}
