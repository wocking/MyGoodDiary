//
//  DiaryRealm.swift
//  MyGoodDiary
//
//  Created by Bosh on 2018/6/18.
//  Copyright © 2018年 bosh. All rights reserved.
//

import Foundation
import RealmSwift

class Diary: Object {
    @objc dynamic var title = ""
    @objc dynamic var date = ""
    @objc dynamic var image = ""
    @objc dynamic var article = ""
}
