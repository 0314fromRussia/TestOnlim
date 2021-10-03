//
//  AutoSizingUiTableView.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit

class AutoSizingUiTableView: UITableView {
    
    override var contentSize: CGSize {
        
        didSet {
            //нужно вызывать, когда меняются вью и его размеры, тогда layout будет учитывать изменения в следующую итеграцию
            invalidateIntrinsicContentSize()
        }
    }

    
    override var intrinsicContentSize: CGSize {
        
        // layoutIfNeeded - сообщаем что сейчас надо пересчитать layout
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
