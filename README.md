# cgictrl ver.0.4 2012.12.19 Masahiko Ito \<m-ito@myh.no-ip.org\>
Copyright (C) 2009 Masahiko Ito
  
These programs is free software; you can redistribute it and/or modify  
it under the terms of the GNU General Public License as published by 
the Free Software Foundation; either version 2 of the License, or (at  
your option) any later version.

These programs is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
for more details.

You should have received a copy of the GNU General Public License along 
with these programs; if not, write to the Free Software Foundation, Inc., 
59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

Mail suggestions and bug reports for these programs to
"Masahiko Ito" \<m-ito@myh.no-ip.org\>

## これは何?
ruby言語を使ってWebアプリケーションを作る時に利用するフレームワークの
一種です。

## 機能とか特徴とか

rubyのフレームワークと言えば **Ruby on Rails** とかが真っ先に思い浮かぶ
と思うのですが、この **cgictrl** の方向性は、それらとはかなり違ったもの
ですし、競合するようなものでもありません(まぁ、最初から相手にされない
とは思いますが...)。

一言で言うと、**cgictrl**はメインフレームでのオンラインプログラムの構造を
Webアプリケーションの世界に適用する為のフレームワークという事になりま
す。

NEC ACOS-4でのVIS環境、日立 VOS-3でのADM環境(富士通でのAIM、IBMでの
CICSかな?)辺りでのオンラインプログラム構造を思い浮かべていただければ
良いかと思います。

プログラムはトランザクションコードで識別され、プログラムから次に起動す
るトランザクションコードを指定する事で会話処理を継続して行きます。

基本的に一つのプログラムは、一種類の画面を送信し、その画面からの入力デー
タを処理することに専念します。また、あるプログラムから次のプログラムへ
のデータ引き渡しはSPA(Scratch Pad Area)と呼ばれる特別の領域(これはセッ
ションごとに確保される)にそのデータを保存する事で実現します。

機能としては、

### ゆるやかなMVC(Model-View-Control)モデルの実現。

  * Model : 実際にユーザが開発するCGIプログラムが該当する。
  * View  : ユーザインターフェースをModelから独立したhtmlファイルとModelから呼び出す**out_html**メソッドで実現する。
  * Control : **cgictrl.cgi**(+ **cgictrl_common.rb**)がViewからの入力に対応す るModelの呼び出しを制御する。

### セッション管理機能。

  \<input type="hidden" ...\>によりセッションIDを受渡し、そのセッションID
  を基にしてセッション管理を行う。

### 排他制御機能。

  トランザクションと関連付けて定義するリソースIDを基にユーザプログラム
  で意識する事無く排他制御を行う。

### SPAを利用したデータ連係機能。

  セッションIDをキーにして作成されるセッション毎にユニークなSPA領域を介
  してトランザクション間でのデータ授受を可能にする。

### 画面から入力されたデータのロギング機能。

  \<form\>から入力されたデータをログファイルに記録する。

### 画面に表示した内容のロギング機能。

  表示した画面(htmlイメージ)を、そのままログファイルに記録する。

### httpサーバの持つ認証機能により認証されたユーザに対するトランザクション制御機能。また、トランザクション実行拒否情報のロギング機能。

  ユーザIDに対して許可するトランザクションを正規表現を使って定義するこ
  とができる。

### 必要に応じてhttps(ssl)通信を強制させる機能。
### 画面(html)編集機能。

  画面の雛型となるhtmlファイルを、あらかじめ用意しておき、編集メソッド
  (out_html)で編集して出力する。編集する際には自動的にhtmlエスケープを
  行うため、XSSに対する予防が容易にできる。

### 入力データを任意の文字コードに変換する機能。

  nkfを利用してのコード変換を利用できる。

等を備えています。

## インストール方法

### パッケージをpublic_html以下の適当なディレクトリに展開する。
### データ用ディレクトリを作成する(後述する **cgictrl_common.cgi** 中のパラメータ **@cgictrl_data_dir** で場所を指定できる)。

  * tar xvzf cgictrl-0.4.tar.gz
  * mkdir ~/cgictrl
  * mkdir ~/cgictrl/html
  * mkdir ~/cgictrl/lock
  * mkdir ~/cgictrl/log
  * mkdir ~/cgictrl/spa
  * mkdir ~/cgictrl/tmp
  * chmod ???? \~/cgictrl \~/cgictrl/html # httpサーバの権限で参照できるように設定する。
  * chmod ???? \~/cgictrl/lock \~/cgictrl/log \~/cgictrl/spa \~/cgictrl/tmp # httpサーバの権限で更新できるように設定する。
  * cp cgictrl-0.4/cgi-bin/\* \~/public_html/cgi-bin/
  * cp cgictrl-0.4/cgictrl/\*.txt \~/cgictrl/
  * cp cgictrl-0.4/cgictrl/html/\* \~/cgictrl/html/
  * vi \~/public_html/cgi-bin/cgictrl_common.rb  
```
    @cgictrl_data_dir = "/home/自分のアカウント/cgictrl"
```
  * vi \~/cgictrl/resource.txt  
```
    RES_ADDR=/home/自分のアカウント/cgictrl/tmp/samp_addr.csv
```

## 使い方

### 設定ファイル

  * \~/cgictrl/resource.txt : cgictrlで制御されるCGIプログラムで排他制
                             御の対象とするリソースを定義する。
                             (ADMDEFにデータベースを定義するような感覚
                              とでも言えば特定の方々には分かりやすいか
                              も)
  * \~/cgictrl/tran2pgm.txt : トランザクションに対応するCGIプログラムお
                             よび、そのトランザクションで排他制御の対
                             称にするリソースを定義する。
                             (PAS(Program Access Specification)を定義
                              するような感覚とでも言えば特定の方々には
                              分かりやすいかも)
  * \~/cgictrl/usertran.txt : Basic認証等で認識されたユーザに対して許可
                             するトランザクションを定義する。
  * \~/cgictrl/html/\*.html : 画面定義ファイル(MVCのVに相当する部分)。画
                            面定義(html)を独立したファイルで定義する事
                            で、画面のデザインとCGIプログラムのロジック
                            とを分離する事ができる。
                            (MIB(Message Input Block)/MOB(Message Output Block)
                            を定義するような感覚とでも言えば特定の方々
                            には分かりやすいかも)

## 制御CGIプログラム

  * cgictrl.cgi        : \<form action="..."\>により、ユーザが直接起動する
                         CGIプログラム(MVCのCに相当する部分)。実際にユー
                         ザが作成する業務CGIプログラム(MVCのMに相当する
                         部分)は直接呼び出す事をせずに、常にこのcgictrl.cgi
                         を介して呼び出される仕組みとなっている。
  * cgictrl_common.cgi : cgictrl classの定義。

## ~/cgictrl/resource.txtの設定

  書式 : リソースID=リソース実体名称

  例 : RES1=/home/m-ito/dat/database.txt

  排他制御の対象リソースを登録する。cgictrlではあらかじめ登録されたリ
  ソースのみ排他制御の対象にできる。cgictrlはリソースIDでのみリソース
  を識別する。cgictrlにとってリソース実体名称は特段意味を持たない。よっ
  てリソース実体名称は必ずしも実体を表す必要はない(ただし以下の特殊な
  リソースIDを除く)。

  * 特殊なリソースID (cgictrl内部で利用するので、ユーザのリソースIDと
                      して利用してはいけない)

    **LOGFILE** はアクセスログファイルを示し、このリソースIDに対する実体
    名称は実際にhttpデーモンの権限で書き込み可能なファイルである必要が
    有る。ただし、resource.txt中で指定されない場合は cgictrl_common.rb
    中のinitializeメソッドにハードコーディングされたログファイルが出力
    先となるので、一時的に出力先を変更したい等の特別な事情がなければ、
    あえてresource.txt中で指定する必要は無い。

    **SPADIR** はSPAを格納するディレクトリを示し、このリソースIDに対する
    実体名称は実際にhttpデーモンの権限で書き込み可能なディレクトリであ
    る必要が有る。ただし、resource.txt中で指定されない場合は
    cgictrl_common.rb 中のinitializeメソッドにハードコーディングされた
    SPAディレクトリが設定されるので、一時的にSPAの出力先を変更したい等
    の特別な事情がなければ、あえてresource.txt中で指定する必要は無い。

## ~/cgictrl/tran2pgm.txtの設定

  書式 : トランザクション名=プログラムへのパス[:リソースID/アクセスモード[,リソースID/アクセスモード ...]]

  例 : SAMPLE1=/home/m-ito/public_html/RubyFrameWork/cgi-bin/sample1.cgi:RES1/A,RES2/G,RES3/A

  トランザクションに対応するプログラム実体と排他処理の対象とするリソー
  スIDを登録する。ここで記述するリソースIDは ~/cgictrl/resource.txt に
  登録された物でないといけない。

  アクセスモードは現時点ではコメントに過ぎない(A:更新モード扱いとなる)。
  将来的には

  * A : 更新モード
  * G : 参照モード

  の2種類が指定可能となる予定(?)。

## \~/cgictrl/usertran.txtの設定

  書式 : ユーザ名=許可トランザクション(正規表現)

  例 : m-ito=TEST|SAMP_.\*

  httpサーバの認証機能(Basic認証等)により認証されたユーザIDに対して
  許可するトランザクションを登録する。

  認証機能を利用しない場合、ユーザIDには **anonymous** が設定されるの
  で、許可するトランザクションは **anonymous** に対して設定する。

## cgictrl_common.cgiでの各種既定値定義。

  * サイトごとに必ず設定を見直すべき項目
    - cgictrlが利用するデータディレクトリ。  
      @cgictrl_data_dir = "/home/_your_own_account_/cgictrl"
  * サイトの方針により設定を見直すべき項目
    - https(ssl)通信を強制しない。  
      @force_https = "n"
    - [戻る]ボタンで遡ったページからの処理継続を禁止する。  
      @backward_deny = "y"
    - 禁止された[戻る]ボタンを利用した場合、画面の遷移を止める。  
      @backward_deny_msg = "Status: 204 No Response\n\n"
    - nkf変換パラメータ。  
      @default_nkf_param = "-W -X -Z1 -w"
    - \<form\>からの入力データをログファイルに残す。  
      @get_log_input_flag = "y"
    - stdoutに出力したデータをログファイルに残す。  
      @get_log_send_flag = "y"
    - トランザクションの実行拒否をログファイルに残す。  
      @get_log_deny_flag = "y"
    - トランザクションを中断するエラーメッセージをログファイルに残す。  
      @get_log_error_flag = "y"
    - 排他リトライ時の間隔(秒)。  
      @lock_sleep_sec = 1
    - 排他リトライの回数。  
      @lock_retry_max = 60
    - 指定時間(秒)より古いSPAファイルを削除対象とする。  
      @sweep_time_before = 2 * 24 * 60 * 60
    - umask値  
      @umask = 007
  * 既定値のまま運用する事が望ましい項目

    - トランザクション to プログラム変換テーブルファイル。  
      @tran2pgm_file = @cgictrl_data_dir + "/" + "tran2pgm.txt"
    - ユーザ to トランザクション許可ファイル。  
      @usertran_file = @cgictrl_data_dir + "/" + "usertran.txt"
    - 排他対象リソース登録ファイル。  
      @resource_file = @cgictrl_data_dir + "/" + "resource.txt"
    - htmlファイル格納ディレクトリ。  
      @html_dir = @cgictrl_data_dir + "/" + "html"
    - cgictrlシステムエラー画面htmlファイルのID。  
      @error_msg_id = "cgictrl_error"
    - cgictrlシステムエラー画面htmlファイル中のメッセージ項目名称。  
      @error_msg_string = "error_message"
    - 排他制御用の親ディレクトリ。  
      @lock_parent_dir = @cgictrl_data_dir + "/" + "lock"
    - 排他制御ディレクトリのフォーマット。  
      @lock_dir_format = "%s.dir"
    - 排他制御ファイル。  
      @lock_file = "lock.txt"
    - htmlファイル中の項目開始文字列名称、終了文字列名称。  
      @html_start_param = "START"  
      @html_end_param = "END"  
    - htmlファイル中の項目開始文字列、終了文字列。  
      @html_start_default = "@\{"  
      @html_end_default = "\}@" 
    - htmlファイル中にトランザクションコードを埋め込む際の文字列名称。  
      @html_tran_key = "SYS_tran"
    - htmlファイル中の項目開始文字列、終了文字列の最終的な値の16進文字列。  
      @start_str_hex = "01"  
      @end_str_hex = "02" 
    - ログ記録ファイルのリソースID、格納ディレクトリ、ファイル実体。 
      @log_file_res = "LOGFILE"  
      @log_dir = @cgictrl_data_dir + "/" + "log"  
      @log_file = @log_dir + "/" + "log.txt"
    - SPA(Scratch Pad Area)ファイル格納ディレクトリ、リソースID。  
      @spa_dir_res = "SPADIR"  
      @spa_dir = @cgictrl_data_dir + "/" + "spa"

## 起動方法

  パラメータ **SYS_init_tran** に初期トランザクションを指定し、
  cgictrl.cgiを呼び出す。

  例 : http://foo.org/cgi-bin/cgictrl.cgi?SYS_init_tran=トランザクション名

## 画面定義(html)作成

  画面のデザインはhtml(的な)ファイルとして作成しプログラムから直接htmlタグ
  を出力する事はしない(推奨)。格納場所は \~/cgictrl/html/ とする。

  通常のhtmlファイルと異なる部分は、

  - httpヘッダーも含めて記述する。 
    Content-Type: text/html; charset=utf-8
  - \<form\>〜\</form\>の間に必ず以下のインプットタグ(セッションID設定用)を記 
    述する。原則、<input type="hidden" ...>は下記以外に使用しない事を推奨
    する(ページ間で受け渡す必要の有るデータはSPAを利用することで可能)。 
    \<input type="hidden" name="SYS_sessionid" value="@{SYS_sessionid}@"\>
  - 出力時に埋め込む部分は、下記
    のように記述し、プログラムから out_html メソッドで置き換えて出力する。
    out_htmlメソッドによる置き換えを行わない項目については、前者の指定の
    場合は空文字列に置換され、後者の指定の場合は既定値文字列に置換される。
    @{項目名称}@ 又は @{項目名称=既定値文字列}@
  - 行頭から始まる **START=文字列**, **END=文字列** の指定により、項目名称の
    開始文字列と終了文字列を指定する事ができる。通常この指定はhttpヘッダー
    よりも先に指定する事を推奨する。文字列中に正規表現上の特殊文字を含む
    場合は、**\\** によりエスケープする必要がある。未指定時(デフォルト値)は
      * START=@\{
      * END=\}@
    となっている。
  - START, ENDに指定する文字列は意図せぬ置換を防ぐために、html本文中に現
    れてはいけない。しかし、どうしても記述せざるを得ない場合は &#xxx; 等
    の表現(数値文字参照)に置き換えれば記述可能である。

## ユーザプログラム作成

  サンプルスクリプトを参考に作成する。基本的には
```
  #--- user coding start ---
  #--- user coding end   ---
```
  の間にコーディングを行う。

  - sub_open()  
    プログラムの開始時に必ず実行されるルーチン。各種の初期処理を行う。DBへ
    の接続処理や、独自の排他制御取得処理を想定している。
  - sub_send()  
    SPAにより受け渡されたデータを基に画面の編集および出力処理を行う。
    cgictrl.cgiの制御により、下記のsub_receive()と本sub_send()の、どちらか
    一方が呼び出される。次回に起動するトランザクションを戻り値とするが、通
    常は自トランザクションを返す。
  - sub_receive()  
    画面から入力されたデータを受け取り、必要な処理を行う。また、次回に起動
    するトランザクションに引き渡すためのデータをSPAに保存する。SPAに保存す
    る際の項目名には **SYS_** で始まる名称を利用してはいけない(内部での利用のた
    めに予約されている)。 cgictrl.cgiの制御により、上記のsub_send()と本
    sub_receive()の、どちらか一方が呼び出される。処理の結果を判断し、次回に
    起動するトランザクションを戻り値とする。
  - sub_close()  
    プログラムの終了時に必ず実行されるルーチン。各種の終了処理を行う。DBか
    らの切断処理や、独自の排他制御解除処理を想定している。

  原則、それ以外の場所はさわる必要が無いが、どうしてもさわる場合はロジック
  を良く理解した上で自己責任で行う事。

## Cgictrl classに定義されている(主にユーザプログラムで使用する)メソッド

  - start(nkf_param)  
     クライアント開始処理  
     引  数：nkf_param:入力項目をnkfで変換する際のオプション  
     戻り値：セッションID
  - end(tran)  
     クライアント終了処理  
     引  数：tran:次回に起動するトランザクションを指定  
     戻り値：無し
  - is_send()  
     コントロール条件(送信トランザクション)取得  
     引  数：無し  
     戻り値：ステータス true:送信トランザクションである, false:受信トランザクションである
  - is_receive()  
     コントロール条件(受信トランザクション)取得  
     引  数：無し  
     戻り値：ステータス true:受信トランザクションである, false:送信トランザクションである
  - get_realres(res)  
     リソース実体取得  
     引  数：res:リソースID  
     戻り値：リソースの実体を表す文字列 
  - get_input(key)  
     インプットデータ取得  
     引  数：key:項目名称  
     戻り値：項目に対する値(数値データも含めて全て文字列として返ります) 
  - set_input(key, value)  
     インプットデータ設定  
     引  数：key:項目名称,value:項目に対して設定する値  
     戻り値：無し 
  - get_input_file(key)  
     インプットファイルデータ取得  
     引  数：key:項目名称  
     戻り値：項目に対する値
  - set_input_file(key, value)  
     インプットファイルデータ設定  
     引  数：key:項目名称,value:項目に対して設定する値  
     戻り値：無し
  - get_spa(key)  
     SPAデータ取得  
     引  数：key:項目名称  
     戻り値：項目に対する値(数値データも含めて全て文字列として返ります) 
  - set_spa(key, value)  
     SPAデータ設定  
     引  数：key:項目名称, value:項目に対して設定する値  
     戻り値：無し 
  - clear_spa()  
     SPAクリアー  
     引  数：無し  
     戻り値：無し 
  - destroy_spa()  
     SPA完全クリアー  
     引  数：無し  
     戻り値：無し  
  - get_init_tran()  
     初期トランザクションコードの取得  
     引  数：無し  
     戻り値：トランザクションコード 
  - get_tran()  
     現在トランザクションコードの取得  
     引  数：無し  
     戻り値：トランザクションコード 
  - get_prev_tran()  
     呼出元トランザクションコードの取得  
     引  数：無し  
     戻り値：トランザクションコード 
  - out_html(id, hash_param)  
     html出力処理  
     引  数：id:htmlファイルID, hash_param:{ 項目 => 値, ...} (htmlに埋め込む値)  
     戻り値：ステータス true:成功, false:失敗  

       ex. hash_param = { "key" => "value" } の場合
           **#{id}.html** 中の **#{start_str}key#{end_str}** を **value** に置き換える。

## 最後に

このソフトウェアが、汎用機での貴重な開発経験を持ちながら、ウェブアプリケー
ションの開発現場で苦労されている開発者方の手助けとなれば幸いです。

## Youtube
[Ruby向けCGIフレームワーク cgictrl](https://youtu.be/HroANLK0QYg)

--  
Masahiko Ito \<m-ito@myh.no-ip.org\>
