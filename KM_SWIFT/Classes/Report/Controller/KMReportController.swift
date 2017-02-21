//
//  KMReportController.swift
//  swift预览
//
//  Created by Roc on 17/2/13.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

private let kTitleColor = RGB(102, 102, 102)
private let kHistoryCell = "kHistoryCell"

class KMReportController: UIViewController {

    lazy var modelArray: [KMHistoryModel] = [KMHistoryModel]()
    var selectedYear: Int = 2017
    
    // MARK: - 懒加载控件
    fileprivate lazy var yearLabel = UILabel()
    fileprivate lazy var scrollView = UIScrollView()
    fileprivate lazy var bottomLine = UIView()
    fileprivate lazy var tableView = UITableView()
    fileprivate lazy var monthLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kBackgroudColor
        navigationItem.title = "检测历史"
        
        setupUI()
        //接收登录成功通知
        let loginSuccess = Notification.Name(rawValue: kLoginSuccessNotification)
        NotificationCenter.default.addObserver(forName: loginSuccess, object: nil, queue: nil) { (notifi) in
            
            self.beganLoadData(year: KMDateModel.current.year)
        }
    }
    //开始加载数据
    private func beganLoadData(year: Int) {
        
        loadMonth(year: year) { (result) in
            
            if result == nil {
                if year == 2015 {
                    return
                }
                self.beganLoadData(year: year - 1)
            }
        }
    }
    
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 请求数据
extension KMReportController {
    
    //某一年所有的数据的月份
    fileprivate func loadMonth(year: Int, finishedBack: ((_ result: Any?)->())?) {
        
        let url = kBaseURL + "api/App/GetPhysicalExamDate"
        let params = ["request.year":year]
        
        KMNetworkManager.request(url: url, params: params) { (result, error) in
            if result == nil {
                print("请求失败")
                return
            }
            self.selectedYear = year
            self.yearLabel.text = "\(year)年"
            
            let resultArray = (result as? [String: Any])?["Data"] as? [Int]
            if resultArray?.count == nil || resultArray!.count <= 0 {
                self.modelArray.removeAll()
                self.tableView.reloadData()
                finishedBack?(nil)
                return
            }
            //有数据的时候
            let monthButton = self.scrollView.viewWithTag(resultArray!.last!) as! UIButton
            self.selectedMonth(btn: monthButton)
        }
    }
    
    //指定年月的数据
    fileprivate func loadData(year: Int, month: Int) {
        
        let url = kBaseURL + "api/App/GetPhysicalExamHisData"
        let params = ["request.year":year, "request.month":month]
        
        KMNetworkManager.request(url: url, params: params) { (result, error) in
            if result == nil {
                print("请求失败")
                return
            }
            
            guard let resultDict = ((result as? [String: Any])?["Data"] as? [String: Any])?["Data"] as? [[String: Any]] else {
                
                self.modelArray.removeAll()
                self.tableView.reloadData()
                return
            }
            
            self.modelArray.removeAll()
            for dict in resultDict {
                let model = KMHistoryModel(dict: dict)
                self.modelArray.append(model)
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - UI界面布局
extension KMReportController {
    
    fileprivate func setupUI() {
        
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        topView.frame = kRect(0, 0, view.width, 100)
        view.addSubview(topView)
        
        yearLabel.textColor = kTitleColor
        yearLabel.font = UIFont.systemFont(ofSize: 24)
        yearLabel.text = "\(KMDateModel.current.year)年"
        yearLabel.textAlignment = .center
        topView.addSubview(yearLabel)
        
        let yearW: CGFloat = 85
        let yearH: CGFloat = 20
        let yearX: CGFloat = (topView.width - yearW) * 0.5
        let yearY: CGFloat = 20
        yearLabel.frame = kRect(yearX, yearY, yearW, yearH)
        
        //切换年份按钮
        let prevBtn = UIButton()
        prevBtn.tag = 0
        prevBtn.setImage(#imageLiteral(resourceName: "arrow-left"), for: .normal)
        topView.addSubview(prevBtn)
        prevBtn.addTarget(self, action: #selector(changeYear(btn:)), for: .touchUpInside)
        prevBtn.snp.makeConstraints { (make) in
            make.size.equalTo(kSize(12, 21))
            make.right.equalTo(yearLabel.snp.left).offset(-5)
            make.centerY.equalTo(yearLabel)
        }
        
        let nextBtn = UIButton()
        nextBtn.tag = 1
        nextBtn.setImage(#imageLiteral(resourceName: "arrow-right"), for: .normal)
        topView.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(changeYear(btn:)), for: .touchUpInside)
        nextBtn.snp.makeConstraints { (make) in
            make.size.equalTo(prevBtn)
            make.left.equalTo(yearLabel.snp.right).offset(5)
            make.centerY.equalTo(yearLabel)
        }
        
        //月份滚动条
        topView.addSubview(scrollView)
        let scroX: CGFloat = 0
        let scroY: CGFloat = yearLabel.bottom + 10
        let scroW: CGFloat = topView.width
        let scroH: CGFloat = topView.height - scroY
        scrollView.frame = kRect(scroX, scroY, scroW, scroH)
        scrollView.contentSize = kSize(scroW * 2, 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        //月份选项
        let monthW = scroW / CGFloat(6)
        var monthBtn: UIButton!
        for i in 0..<12 {
            monthBtn = UIButton()
            monthBtn.tag = i + 1
            monthBtn.frame = kRect(CGFloat(i) * monthW, 0, monthW, scroH)
            monthBtn.setTitle("\(i+1)月", for: .normal)
            monthBtn.setTitleColor(kTitleColor, for: .normal)
            monthBtn.setTitleColor(RGB(204, 204, 204), for: .disabled)
            scrollView.addSubview(monthBtn)
            monthBtn.addTarget(self, action: #selector(selectedMonth(btn:)), for: .touchUpInside)
            
        }
        //月份下划线
        let lineH: CGFloat = 2
        scrollView.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor("4b75f3")
        bottomLine.frame = kRect(0, scroH - lineH, monthW, lineH)
        
        //列表tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.bottom.equalTo(-49);
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 100 * kFitHeightScale
        tableView.tableFooterView = UIView()
        
        monthLabel.textColor = kTitleColor
        monthLabel.height = 45
        monthLabel.backgroundColor = RGB(244, 243, 248)
        tableView.tableHeaderView = monthLabel
        tableView.register(KMHistoryCell.self, forCellReuseIdentifier: kHistoryCell)
        
    }
}

// MARK: - 点击事件
extension KMReportController {
    //切换年份
    @objc fileprivate func changeYear(btn: UIButton) {
        if btn.tag == 0 {
            selectedYear -= 1
        }
        else {
            selectedYear += 1
        }
        
        loadMonth(year: selectedYear, finishedBack: nil)
    }
    
    //选中月份
    @objc fileprivate func selectedMonth(btn: UIButton) {
        
        let minOffset: CGFloat = 0
        let maxOffset: CGFloat = scrollView.contentSize.width - scrollView.width
        let halfW: CGFloat = scrollView.width * 0.5
        var offset: CGFloat = 0
        
        if btn.centerX > maxOffset + halfW {
            offset = maxOffset
        }else if btn.centerX < halfW {
            offset = minOffset
        }else {
            offset = btn.centerX - halfW
        }
        UIView.animate(withDuration: 0.25) { 
            self.bottomLine.x = btn.x
            self.scrollView.contentOffset.x = offset
        }
        loadData(year: selectedYear, month: btn.tag)
        monthLabel.text = "    \(btn.tag)月已评估项目"
    }
}

// MARK: - tableView协议方法
extension KMReportController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kHistoryCell) as! KMHistoryCell
        
        cell.model = modelArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! KMHistoryCell
        
    }
    
}




