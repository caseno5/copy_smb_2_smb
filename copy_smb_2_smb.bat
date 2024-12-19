@echo off
cd %~dp0
@rem 特定サーバから特定サーバにコピーする

@rem --------------------------------------------------------------
@rem 送信元IP、ログインID、password

@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set sourceIP=\\192.168.XXX.XXX

echo source server login sequence
@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
net use %sourceIP% /user:IDENTITY PASSWORD

@rem --------------------------------------------------------------

@rem 送信元ドライブ名定義
@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set Ndrive=%sourceIP%\CHANGESRCDIRECTORY

@rem -------------------------
@rem コピー先定義
@rem サーバログイン
@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set distinationIP=\\192.168.XXX.YYY

echo distination server login sequence
@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
net use %distinationIP% /user:IDENTITY PASSWORD

@rem コピー先ドライブレーター定義
@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set DRVletter=P

@rem コピー先をネットワークドライブに定義
echo add networkdrive distination server
@rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!要編集!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
net use %DRVletter%: %distinationIP%\CHANGEDISTDIRECTORY

@rem -------

rem 以下は編集の必要なし

@rem -------


@rem コピー先を定義
set DSTdrive=%DRVletter%:\

@rem ドライブ存在確認
IF NOT EXIST %DSTdrive% (
	GOTO BTEND
)

echo VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

echo Drive MOUNTED
timeout /t 5 /nobreak

@rem ログフォルダ作成
IF NOT EXIST %DSTdrive%\robocopylog (
mkdir %DSTdrive%\robocopylog
)


echo VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
echo copy START

@rem robocopy（/Zをつけると書き込みが極端に遅くなるので、初回は外す）
robocopy %Ndrive% %DSTdrive% /xd robocopylog /e /purge /R:2 /W:1 >> %DSTdrive%\robocopylog\%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2%transfer.log

@rem attrib

echo VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
echo attrib START
attrib -s -h %DSTdrive%\*

echo ---END----------------------------------------------
echo DONT mounted....

:BTEND

timeout /t 5 /nobreak


exit


@rem 本バッチファイルはMITライセンスで提供されます
@rem CaseNo.5 | MIT License | https://caseno5.hatenablog.com/ | https://github.com/caseno5/
@rem 
