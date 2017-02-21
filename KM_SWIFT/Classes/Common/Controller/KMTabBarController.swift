//
//  KMTabBarController.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class KMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBar.isTranslucent = false
        
        let tabBarItem = UITabBarItem.appearance(whenContainedInInstancesOf: [KMTabBarController.self])
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: RGB(102, 102, 102)]
        let selectedAttrs = [NSForegroundColorAttributeName: UIColor("4b75f3")]
        
        tabBarItem.setTitleTextAttributes(attrs, for: .normal)
        tabBarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
        
        addChildController(vc: KMReportController(), title: "报告", image: #imageLiteral(resourceName: "table1"), sImage: #imageLiteral(resourceName: "table1_s"))
        addChildController(vc: KMQuestionController(), title: "问诊", image: #imageLiteral(resourceName: "table2"), sImage: #imageLiteral(resourceName: "table2_s"))
        addChildController(vc: KMTherapyController(), title: "理疗", image: #imageLiteral(resourceName: "dexicon"), sImage: #imageLiteral(resourceName: "dexicon"))
        addChildController(vc: KMAssistantController(), title: "助手", image: #imageLiteral(resourceName: "table4"), sImage: #imageLiteral(resourceName: "table4_s"))
        addChildController(vc: KMMallController(), title: "商城", image: #imageLiteral(resourceName: "table5"), sImage: #imageLiteral(resourceName: "table5_s"))
        
        childViewControllers[2].tabBarItem.imageInsets = kInsets(-7, 0, 7, 0)
        
    }
    
    private func addChildController(vc: UIViewController, title: String, image: UIImage, sImage: UIImage) {
        
        let nav = KMNavigationController(rootViewController: vc)
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = sImage
        vc.tabBarItem.title = title
        
        addChildViewController(nav)
    }

}
