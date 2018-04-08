//
//  Const.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/20.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import UIKit

struct mri {
    static let title = "mriVoice"
}

struct iconFont {
    static let s24 : CGFloat = 24.0
    static let s36 : CGFloat = 36.0
    static let s50 : CGFloat = 50.0
}

struct iconSize {
    static let w24 = 24.0
    static let h24 = 24.0
    static let w36 = 36.0
    static let h36 = 36.0
    static let w50 = 50.0
    static let h50 = 50.0
    
}

struct tSize {
    static let smallText = 0
    static let middleText = 1
    static let largeText = 2
}

var text_size_mode = tSize.smallText
let voice_text_size:[CGFloat] = [17,22,50]

struct vColor {
    static let titleBlueColor       = UIColor(red: 21/255.0, green: 64/255.0, blue: 111/255.0, alpha: 1.000)
    static let blueColor            = UIColor(red: 0.000, green: 0.480, blue: 1.000, alpha: 1.000)
    static let greenColor           = UIColor(red: 0.5456, green: 0.678, blue: 0.000, alpha: 1.000)
    static let bargainsYellowColor  = UIColor(red: 1.000, green: 0.667, blue: 0.000, alpha: 1.000)
    static let orangeColor          = UIColor(red: 1.000, green: 0.498, blue: 0.000, alpha: 1.000)
    static let redColor             = UIColor(red: 0.937, green: 0.678, blue: 0.000, alpha: 1.000)
    static let noticeRedColor       = UIColor(red: 0.898, green: 0.188, blue: 0.239, alpha: 1.000)
    static let lightBrownColor      = UIColor(red: 0.800, green: 0.631, blue: 0.498, alpha: 1.000)
    static let blackColor           = UIColor(red: 0.282, green: 0.267, blue: 0.196, alpha: 1.000)
    static let darkGrayColor        = UIColor(red: 0.482, green: 0.467, blue: 0.412, alpha: 1.000)
    static let grayColor            = UIColor(red: 0.639, green: 0.627, blue: 0.565, alpha: 1.000)
    static let borderColor          = UIColor(red: 0.859, green: 0.859, blue: 0.808, alpha: 1.000)
    static let pink                 = UIColor(red: 1.000, green: 0.631, blue: 0.691, alpha: 1.000)
    static let sakura               = UIColor(red: 0.992, green: 0.850, blue: 0.850, alpha: 1.000)
    static let kana_back            = UIColor(red: 0.700, green: 0.700, blue: 0.700, alpha: 0.700)
    static let subMenuColor         = UIColor(red: 0.862, green: 0.407, blue: 0.243, alpha: 1.000)
    static let specialMenuColor     = UIColor(red: 0.062, green: 0.447, blue: 0.713, alpha: 1.000)
    static let orderInputBackColor  = UIColor(red: 0.900, green: 0.900, blue: 0.921, alpha: 1.000)
    static let badge_backColoer     = UIColor(red: 0.700, green: 0.200, blue: 0.200, alpha: 1.000)
}

struct voiceList {
    var vID         : Int       // ID
    var Title       : String    // タイトル
    var Age         : Int       // 年齢層（0:だれでも 1:子供 2:大人 3:老人）
    var Gender      : Int       // 性別（0:どちらでも 1:男性 2:女性）
    var Deadline    : String    // 締め切り日（yyyy/mm/dd HH:mm）
    var Rank        : Int       // 重要度（0:なし 1:おすすめ 2:緊急）
    var Created     : String    // 作成日（yyyy/mm/dd HH:mm:ss）
    var contents    : String    // コンテンツ
    
    init(vID : Int,Title : String,Age : Int,Gender : Int,Deadline : String,Rank : Int,Created : String,contents:String){
        self.vID = vID
        self.Title = Title
        self.Age = Age
        self.Gender = Gender
        self.Deadline = Deadline
        self.Rank = Rank
        self.Created = Created
        self.contents = contents
    }
}

var voiceLists:[voiceList] = [
    voiceList(vID:1,Title:"坊っちゃん",Age:1,Gender:0,Deadline:"2018/04/30 18:00",Rank:1,Created:"2018/03/22 12:10:40",contents:"親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても、そこから飛び降りる事は出来まい。弱虫やーい。と囃したからである。小使に負ぶさって帰って来た時、おやじが大きな眼をして二階ぐらいから飛び降りて腰を抜かす奴があるかと云ったから、この次は抜かさずに飛んで見せますと答えた。（青空文庫より）"),
    voiceList(vID:2,Title:"徒然草",Age:1,Gender:1,Deadline:"2018/04/30 18:00",Rank:2,Created:"2018/03/22 12:10:40",contents:"つれづれなるまゝに、日暮らし、硯にむかひて、心にうつりゆくよしなし事を、そこはかとなく書きつくれば、あやしうこそものぐるほしけれ。（Wikipediaより）"),
    voiceList(vID:3,Title:"爆発音がした",Age:1,Gender:2,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"後ろで大きな爆発音がした。俺は驚いて振り返った。"),
    voiceList(vID:4,Title:"英語",Age:2,Gender:0,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
    voiceList(vID:5,Title:"おとな２",Age:2,Gender:1,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"カタカナ語が苦手な方は「組見本」と呼ぶとよいでしょう。主に書籍やウェブページなどのデザインを作成する時によく使われます。カタカナ語が苦手な方は「組見本」と呼ぶとよいでしょう。主に書籍やウェブページなどのデザインを作成する時によく使われます。書体やレイアウトなどを確認するために用います。この組見本は自由に複製したり頒布することができます。"),
    voiceList(vID:6,Title:"おとな３",Age:2,Gender:2,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"これは正式な文章の代わりに入れて使うダミーテキストです。この組見本は自由に複製したり頒布することができます。カタカナ語が苦手な方は「組見本」と呼ぶとよいでしょう。なお、組見本の「組」とは文字組のことです。活字印刷時代の用語だったと思います。書体やレイアウトなどを確認するために用います。ダミーテキストはダミー文書やダミー文章とも呼ばれることがあります。"),
    voiceList(vID:7,Title:"ながい題名６７８９０１２３４５６７８９０",Age:0,Gender:0,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"書体やレイアウトなどを確認するために用います。主に書籍やウェブページなどのデザインを作成する時によく使われます。文章に特に深い意味はありません。主に書籍やウェブページなどのデザインを作成する時によく使われます。書体やレイアウトなどを確認するために用います。この組見本は自由に複製したり頒布することができます。"),
    voiceList(vID:8,Title:"英語大文字",Age:3,Gender:0,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISICING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. EXCEPTEUR SINT OCCAECAT CUPIDATAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM."),
    voiceList(vID:9,Title:"老人１",Age:3,Gender:0,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"彼は背後にひそかな足音を聞いた。それはあまり良い意味を示すものではない。誰がこんな夜更けに、しかもこんな街灯のお粗末な港街の狭い小道で彼をつけて来るというのだ。人生の航路を捻じ曲げ、その獲物と共に立ち去ろうとしている、その丁度今。 彼のこの仕事への恐れを和らげるために、数多い仲間の中に同じ考えを抱き、彼を見守り、待っている者がいるというのか。それとも背後の足音の主は、この街に無数にいる法監視役で、強靭な罰をすぐにも彼の手首にガシャンと下すというのか。彼は足音が止まったことに気が着いた。あわてて辺りを見回す。ふと狭い抜け道に目が止まる。 彼は素早く右に身を翻し、建物の間に消え去った。その時彼は、もう少しで道の真中に転がっていたごみバケツに躓き転ぶところだった。 彼は暗闇の中で道を確かめようとじっと見つめた。どうやら自分の通ってきた道以外にこの中庭からの出道はないようだ。 足音はだんだん近づき、彼には角を曲がる黒い人影が見えた。彼の目は夜の闇の中を必死にさまよい、逃げ道を探す。もうすべては終わりなのか。すべての苦労と準備は水の泡だというのか。 突然、彼の横で扉が風に揺らぎ、ほんのわずかにきしむのを聞いた時、彼は背中を壁に押し付け、追跡者に見付けられないことを願った。この扉は望みの綱として投げかけられた、彼のジレンマからの出口なのだろうか。背中を壁にぴったり押し付けたまま、ゆっくりと彼は開いている扉の方へと身を動かして行った。この扉は彼の救いとなるのだろうか。"),
    voiceList(vID:10,Title:"Wordの使い方",Age:3,Gender:2,Deadline:"2018/04/30 18:00",Rank:0,Created:"2018/03/22 12:10:40",contents:"[挿入] タブのギャラリーには、文書全体の体裁に合わせて調整するためのアイテムが含まれています。これらのギャラリーを使用して、表、ヘッダー、フッター、リスト、表紙や、その他の文書パーツを挿入できます。図、グラフ、図表を作成すると、文書の現在の体裁に合わせて調整されます。文書で選択した文字列の書式は、[ホーム] タブのクイック スタイル ギャラリーで体裁を選択することで簡単に変更できます。[ホーム] タブの他のボタンやオプションを使用して、文字列に書式を直接設定することもできます。ほとんどのボタンやオプションで、現在のテーマの体裁を使用するか、直接指定する書式を使用するかを選択できます。文書全体の体裁を変更するには、[ページ レイアウト] タブで新しいテーマを選択します。クイック スタイル ギャラリーに登録されている体裁を変更するには、現在のクイック スタイル セットを変更するコマンドを使用します。テーマ ギャラリーとクイック スタイル ギャラリーにはリセット コマンドが用意されており、文書の体裁を現在のテンプレートの元の体裁にいつでも戻すことができます。")
]

struct listLabel {
    // 年齢層
    static let ageLabel:[String] = ["だれでも","子供","大人","老人"]
    // 性別
    static let genderLabel:[String] = ["どちらでも","男性","女性"]
}

var SELECT_VOICE_NO = 0
// タイマー
var voice_timer = Timer()

let server: URL = URL(string: "https://www.mediasoken.net/oc/remote.php/webdav")!
let username = "med1gf15297"
let password = "9210419"
// オーディオファイル
var AudioFileName:URL?
