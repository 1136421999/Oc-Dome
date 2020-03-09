//
//  UITextField+HWExtension.swift
//  编辑框扩展
//
//  Created by 李含文 on 2018/9/29.
//  Copyright © 2018年 李含文. All rights reserved.
//


import UIKit



extension UITextField {
    private struct RuntimeKey {
        static let hw_TextFieldKey = UnsafeRawPointer.init(bitPattern: "hw_TextField".hashValue)
        /// ...其他Key声明
    }
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return (value(forKeyPath: "_placeholderLabel.textColor") ?? UIColor.lightGray) as! UIColor
        }
        set {
            setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    /// 运行时关联
    var hw: hw_TextField {
        set {
            objc_setAssociatedObject(self, UITextField.RuntimeKey.hw_TextFieldKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var obj = objc_getAssociatedObject(self, UITextField.RuntimeKey.hw_TextFieldKey!) as? hw_TextField
            if obj == nil { // 没有是手动创建 并进行绑定
                obj = hw_TextField.init(self)
                objc_setAssociatedObject(self, UITextField.RuntimeKey.hw_TextFieldKey!, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return obj!
        }
    }

}
class hw_TextField: NSObject, UITextFieldDelegate{
    private weak var tf: UITextField? // 定义属性用于临时记录
    /// 值改变回调
    var valuesChangeBlock: ((String)->())?
    /// 结束编辑回调(未输入是不会回调)
    var endEditingBlock: ((String)->())?
    /// 开始编辑
    var beginEditingBlock:(()->())?
    /// 是否是人民币输入
    @discardableResult
    func isMoeeyEidtor(_ isMoeey: Bool) -> hw_TextField {
        isMoeeyEidtor = isMoeey
        return self
    }
    private var _isMoeeyEidtor =  false
    private var pointlocation:Int = -1 // 用于记录小数点位置
    private var isMoeeyEidtor : Bool {
        set {
            _isMoeeyEidtor = newValue
            self.tf?.keyboardType = .decimalPad
        }
        get {
            return _isMoeeyEidtor
        }
    }
    
    convenience init(_ tf: UITextField) {
        self.init()
        self.tf = tf
        self.tf?.delegate = self
        self.tf!.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    @objc private func editingChanged() {
        if valuesChangeBlock == nil {return}
        valuesChangeBlock!(tf?.text ?? "")
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if endEditingBlock == nil {return}
        if (textField.text ?? "").isEmpty {return}
        endEditingBlock!(textField.text ?? "")
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if beginEditingBlock == nil {return}
        beginEditingBlock!()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isMoeeyEidtor == true {
            if string == "."{ // 记录小数点位置
                pointlocation = range.location
            }
            if range.location == 0 { // 首位不能为小数点
                if string == "." { return false }
            }
            if textField.text == "0"{
                if string == "." || string == "" {
                    return true
                } else {
                    return false
                }
            }
            if (textField.text?.contains("."))! { // 包含小数点 后面不能再输入小数点
                if string == "." {  return false }
            }
            if pointlocation != -1 {
                if range.location > pointlocation + 2 {  return false } // 小数点后2位
            }
        }
        return true
    }
    deinit {
        self.tf?.delegate = nil
    }
}

