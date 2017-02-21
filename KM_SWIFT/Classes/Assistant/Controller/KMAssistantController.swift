//
//  KMAssistantController.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

private let kCustomPlanCell = "kCustomPlanCell"
private let kMargin: CGFloat = 10

class KMAssistantController: UIViewController {

    lazy var planDict = ["0":["name":"服药",
                              "image":"dose",
                              "sImage":""],
                         "1":["name":"针灸",
                              "image":"acupuncture",
                              "sImage":""],
                         "2":["name":"体检",
                              "image":"convention",
                              "sImage":""],
                         "3":["name":"跑步",
                              "image":"run2",
                              "sImage":""],
                         "101":["name":"瑜伽",
                                "image":"yoga_grey",
                                "sImage":"yoga"],
                         "102":["name":"羽毛球",
                              "image":"badminton_grey",
                              "sImage":"badminton"],
                         "103":["name":"太极拳",
                              "image":"tjq_grey",
                              "sImage":"tjq"],
                         "104":["name":"慢跑",
                              "image":"run_grey",
                              "sImage":"run"]]
    
    lazy var modelArray: [KMCustomPlanModel] = {
        
        var modelArr = [KMCustomPlanModel]()
        for i in 0..<14 {
            let date = Date(timeIntervalSinceNow: Double(i*24*60*60))
            let dateModel = KMDateModel(date: date)
            let model = KMCustomPlanModel()
            model.dateMode = dateModel
            modelArr.append(model)
        }
        return modelArr
    }()
    
    var selectedModel: KMCustomPlanModel?
    // MARK: - 控件属性
    var collectionVIew: UICollectionView!
    lazy var dateLabel = UILabel()
    lazy var bottomLine = UIView()
    lazy var doctorPlanView: KMPlanListView = KMPlanListView()
    lazy var userPlanView: KMPlanListView = KMPlanListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "自定义计划"
        view.backgroundColor = kBackgroudColor
        
        setupUI()
        getAllPlan()
        addUserPlanView()
        
        //接收登录成功通知
        let loginSuccess = Notification.Name(rawValue: kLoginSuccessNotification)
        NotificationCenter.default.addObserver(forName: loginSuccess, object: nil, queue: nil) { (notifi) in
            
            //self.getAllPlan()
        }

    }
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI界面搭建
extension KMAssistantController {
    
    fileprivate func setupUI() {
        
        let topView = UIView()
        view.addSubview(topView)
        topView.backgroundColor = UIColor.white
        topView.frame = kRect(0, 0, view.width, 146 * kFitHeightScale)
        
        topView.addSubview(dateLabel)
        dateLabel.textColor = RGB(68, 68, 68)
        dateLabel.frame = kRect(22, 11, 100, 22 * kFitHeightScale)
        
        //日期collectionView
        let collectionY = dateLabel.bottom + 10
        let collectionW = topView.width
        let collectionH = topView.height - collectionY
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = kSize((collectionW - 10) / 7, collectionH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionVIew = UICollectionView(frame: kRect(0, collectionY, collectionW, collectionH), collectionViewLayout: layout)
        topView.addSubview(collectionVIew)
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
        collectionVIew.backgroundColor = UIColor.clear
        collectionVIew.showsHorizontalScrollIndicator = false
        collectionVIew.contentInset = kInsets(0, 5, 0, 5)
        collectionVIew.register(KMCustomPlanCell.self, forCellWithReuseIdentifier: kCustomPlanCell)
        
        collectionVIew.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor("4b75f3")
        
        let lineW: CGFloat = layout.itemSize.width
        let lineH: CGFloat = 2
        let lineX: CGFloat = 0
        let lineY: CGFloat = layout.itemSize.height - lineH
        bottomLine.frame = kRect(lineX, lineY, lineW, lineH)
        
        //计划
        let backgroundPlanView = UIView()
        view.addSubview(backgroundPlanView)
        backgroundPlanView.layer.contents = #imageLiteral(resourceName: "zushou_plan_peizhi_bg").cgImage
        
        let planX: CGFloat = 5
        let planY: CGFloat = topView.bottom + 10
        let planW: CGFloat = view.width - 2 * planX
        let planH: CGFloat = 349 * kFitHeightScale
        backgroundPlanView.frame = kRect(planX, planY, planW, planH)
        
        //医生配置计划
        backgroundPlanView.addSubview(doctorPlanView)
        doctorPlanView.planLabel.text = "—— 医生配置 ——"
        doctorPlanView.planLabel.textColor = UIColor("f0b34f")
        
        let docX: CGFloat = 0
        let docY: CGFloat = 35
        let docW: CGFloat = planW
        let docH: CGFloat = (planH - docY) * 0.5
        doctorPlanView.frame = kRect(docX, docY, docW, docH)
        
        //自定义计划
        backgroundPlanView.addSubview(userPlanView)
        userPlanView.planLabel.text = "—— 自定义 ——"
        userPlanView.planLabel.textColor = UIColor("2b87f8")
        userPlanView.frame = kRect(docX, doctorPlanView.bottom, docW, docH)
        
    }
}

// MARK: - 加载数据
extension KMAssistantController {
    
    fileprivate func getAllPlan() {
        let beginDate = KMDateModel.current.timeString
        let endDate = KMDateModel(date: Date(timeIntervalSinceNow: 14*24*60*60)).timeString
        let url = kBaseURL + "api/App/GetHealthPlan"
        let params = ["BeginDate":beginDate, "EndDate":endDate]
        
        KMNetworkManager.request(url: url, params: params) { (result, error) in
            if result == nil {
                return
            }
            let resultArray = ((result as? [String: Any])?["Data"] as? [String: Any])?["UserHealthPlanDetails"] as? [[String: Any]]
            if resultArray == nil || resultArray!.count <= 0 {
                return
            }
            //有数据的时候
            for dict in resultArray! {
                let timeString = (dict["Start"] as! NSString).substring(to: 10)
                let dateModel = KMDateModel(timeString: timeString)
                for model in self.modelArray {
                    if model.dateMode?.day == dateModel.day {
                        let planType = dict["ExeType"] as! Int
                        if planType < 100 {
                            model.doctorPlans.append(planType)
                        }
                        else {
                            model.userPlans.append(planType)
                        }
                    }
                }
            }
            self.collectionVIew.reloadData()
            self.modelArray[0].doctorPlans = [0,1,2,3]
            self.selectedModel(cell: nil, model: self.modelArray[0])
        }
    }
}

// MARK: - 数据展示相关(计划)
extension KMAssistantController {
    //医生配置计划
    fileprivate func showDoctorPlan() {
        
        for view in doctorPlanView.planView.subviews {
            view.removeFromSuperview()
        }
        if selectedModel!.doctorPlans.count <= 0 {
            return
        }
        
        let planW = (doctorPlanView.width - 2 * kMargin) / 4
        let planH = doctorPlanView.planView.height
        
        for (i, type) in selectedModel!.doctorPlans.enumerated() {
            
            let planView = KMPlanView()
            let planType = String(type)
            let planImg = UIImage(named: planDict[planType]!["image"]!)
            let planName = planDict[planType]!["name"]
            
            planView.exeType = type
            planView.iconBtn.setImage(planImg, for: .normal)
            planView.titleLabel.text = planName
            planView.frame = kRect(kMargin + CGFloat(i) * planW, 0, planW, planH)
            doctorPlanView.planView.addSubview(planView)
        }
    }
    
    //自定义计划列表
    fileprivate func addUserPlanView() {
        
        let planW = (userPlanView.width - 2 * kMargin) / 4
        let planH = userPlanView.planView.height
        
        for i in 0..<4 {
            
            let planView = KMPlanView()
            let planType = i + 101
            let planImg = UIImage(named: planDict["\(planType)"]!["image"]!)
            let selected = UIImage(named: planDict["\(planType)"]!["sImage"]!)
            let planName = planDict["\(planType)"]!["name"]
            
            planView.exeType = planType
            planView.tag = planType
            planView.iconBtn.setImage(planImg, for: .normal)
            planView.iconBtn.setImage(selected, for: .selected)
            planView.titleLabel.text = planName
            planView.frame = kRect(kMargin + CGFloat(i) * planW, 0, planW, planH)
            userPlanView.planView.addSubview(planView)
            
            planView.iconBtn.addTarget(self, action: #selector(KMAssistantController.test), for: .touchUpInside)
            
        }
    }
    
    func test() {
        
        print("测试计划中。。。")
    }
    
    //已配置用户计划(选中状态)
    fileprivate func showUserPlan() {
        
        for view in userPlanView.planView.subviews {
            (view as! KMPlanView).iconBtn.isSelected = false
        }
        
        for (i, type) in selectedModel!.userPlans.enumerated() {
            
            let planView = userPlanView.planView.viewWithTag(type) as! KMPlanView
            planView.iconBtn.isSelected = true
            let planX = kMargin + CGFloat(i) * planView.width
            
            for view in userPlanView.planView.subviews {
                if view.x >= planX && view.x < planView.x {
                    view.x += view.width
                }
            }
            planView.x = planX
        }
    }
    
    //添删自定义计划
    @objc private func addOrDeleteCustomPlan(planBtn: UIButton) {
        
        let planView = planBtn.superview as! KMPlanView
        let count = selectedModel!.userPlans.count
        planBtn.isSelected = !planBtn.isSelected
        
        if planBtn.isSelected {  //添加计划
            
            let planX = kMargin + CGFloat(count) * planView.width
            for userPlan in userPlanView.planView.subviews {
                if userPlan.x < planView.x && userPlan.x >= planX {
                    UIView.animate(withDuration: 0.25, animations: { 
                        userPlan.x += userPlan.width
                    })
                }
            }
            UIView.animate(withDuration: 0.25, animations: { 
                planView.x = planX
            })
            //数组加入计划
            selectedModel?.userPlans.append(planView.exeType)
            //发送请求
            let url = kBaseURL + "api/App/AddHealthPlan"
            let params = ["Start":selectedModel?.dateMode?.timeString,
                          "End":selectedModel?.dateMode?.timeString,
                          "ExeType":"\(planView.exeType)"]
            KMNetworkManager.request(url: url, method: .POST, params: params, finishedBack: { (result, error) in
                if result == nil {
                    return
                }
            })
        }
            
        else {  //删除计划
            
            let planX = kMargin + CGFloat(count - 1) * planView.width
            for userPlan in userPlanView.planView.subviews {
                if userPlan.x > planView.x && userPlan.x <= planX {
                    userPlan.x -= userPlan.width
                }
            }
            UIView.animate(withDuration: 0.25, animations: { 
                planView.x = planX
            })
            //数组移除计划
            let index = selectedModel?.userPlans.index(of: planView.exeType)
            selectedModel?.userPlans.remove(at: index!)
            //发送请求
            let url = kBaseURL + "api/App/DeleteHealthPlan"
            let params = ["Start":selectedModel?.dateMode?.timeString,
                          "End":selectedModel?.dateMode?.timeString,
                          "ExeType":"\(planView.exeType)"]
            KMNetworkManager.request(url: url, method: .POST, params: params, finishedBack: { (result, error) in
                if result == nil {
                    return
                }
            })
        }
        collectionVIew.reloadData()
    }
}

// MARK: - KMCustomPlanCellDelegate代理实现
extension KMAssistantController: KMCustomPlanCellDelegate {
    
    func selectedModel(cell: KMCustomPlanCell?, model: KMCustomPlanModel) {
        
        selectedModel?.isSelected = false
        selectedModel = model
        selectedModel?.isSelected = true
        
        collectionVIew.reloadData()
        dateLabel.text = "\(model.dateMode!.year)年\(model.dateMode!.month)月"
        
        UIView.animate(withDuration: 0.25) {
            self.bottomLine.x = cell?.x ?? 0
        }
        
        showDoctorPlan()
        showUserPlan()
    }
    
}

// MARK: - collectionView协议方法
extension KMAssistantController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return modelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCustomPlanCell, for: indexPath) as! KMCustomPlanCell
        
        cell.model = modelArray[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}










