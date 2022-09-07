$hello="                                                                                              
        ,--,                                                                                  
      ,--.'|            ,--,    ,--,                                                          
   ,--,  | :          ,--.'|  ,--.'|                     ,--,                                 
,---.'|  : '          |  | :  |  | :     ,---.         ,'_ /|                         __  ,-. 
|   | : _' |          :  : '  :  : '    '   ,'\   .--. |  | :   .--.--.             ,' ,'/ /| 
:   : |.'  |   ,---.  |  ' |  |  ' |   /   /   |,'_ /| :  . |  /  /    '     ,---.  '  | |' | 
|   ' '  ; :  /     \ '  | |  '  | |  .   ; ,. :|  ' | |  . . |  :  /`./    /     \ |  |   ,' 
'   |  .'. | /    /  ||  | :  |  | :  '   | |: :|  | ' |  | | |  :  ;_     /    /  |'  :  /   
|   | :  | '.    ' / |'  : |__'  : |__'   | .; ::  | | :  ' ;  \  \    `. .    ' / ||  | '    
'   : |  : ;'   ;   /||  | '.'|  | '.'|   :    ||  ; ' |  | '   `----.   \'   ;   /|;  : |    
|   | '  ,/ '   |  / |;  :    ;  :    ;\   \  / :  | : ;  ; |  /  /`--'  /'   |  / ||  , ;    
;   : ;--'  |   :    ||  ,   /|  ,   /  `----'  '  :  `--'   \'--'.     / |   :    | ---'     
|   ,/       \   \  /  ---`-'  ---`-'           :  ,      .-./  `--'---'   \   \  /           
'---'         `----'                             `--`----'                  `----'            
                                                                                              
"

# UTF-8
# chcp 65001

#---------------------- Import Modules BEGIN   ----------------------
# 导入Module
Import-Module PSColor
Import-Module PSReadLine
Import-Module posh-git
Import-Module posh-sshell
Import-Module Get-ChildItemColor

# 设置oh-my-posh
#Import-Module oh-my-posh #Set-PoshPrompt -Theme xtoys #旧版配置
$poshpath="$env:POSH_THEMES_PATH\half-life.omp.json"
oh-my-posh init pwsh --config "$poshpath" | Invoke-Expression

# PSReadline配置
$PSReadLineOptions = @{
    EditMode = "Windows"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    ShowToolTips = $true
}
Set-PSReadLineOption @PSReadLineOptions

# PowerShell命令配色
Set-PSReadLineOption -Colors @{
    Command             = "#e5c07b"
    Number              = "#cdd4d4"
    Member              = "#e06c75"
    Operator            = "#e06c75"
    Type                = "#78b6e9"
    Variable            = "#78b6e9"
    Parameter           = "#e06c75"  #命令行参数颜色
    ContinuationPrompt  = "#e06c75"
    Default             = "#cdd4d4"
    Emphasis            = "#e06c75"
    #Error
    Selection           = "#cdd4d4"
    Comment             = "#cdd4d4"
    Keyword             = "#e06c75"
    String              = "#78b6e9"
}
#---------------------- Import Modules END   ----------------------





#----------------------   Set Alias BEGIN   ----------------------
# 2.查看目录 ls & ll
function ListDirectory {
    (Get-ChildItem).Name
    Write-Host("")
}
#Set-Alias -Name ls -Value ListDirectory
Set-Alias -Name ll -Value Get-ChildItem -option AllScope
Set-Alias -Name ls -Value Get-ChildItemColorFormatWide -option AllScope

# 3.打开当前工作目录
function OpenCurrentFolder {
    param
    (
        # 输入要打开的路径
        # 用法示例：open C:\
        # 默认路径：当前工作文件夹
        $Path = '.'
    )
    Invoke-Item $Path
}
Set-Alias -Name open -Value OpenCurrentFolder

# 4.回到上一级目录
function GoBack {
    Set-Location ..
}
Set-Alias .. GoBack

# 5.跳转根目录
function GoHome {
    cd ~
}
Set-Alias ~ GoHome

# 6.Git格式化输出
function GitLogPretty {
  git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all
}
Set-Alias glola GitLogPretty

# 7.winfetch(存在配置文件才能运行)
Set-Alias winfetch .\Scripts\pwshfetch-test-1.ps1
#----------------------   Set Alias END   ----------------------





#----------------------   Set Hot-keys BEGIN   ----------------------
# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History
# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit
# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#----------------------   Set Hot-keys END   ----------------------





#----------------------   Set Network BEGIN    ----------------------
# 1.获取所有 Network Interface
function Get-AllNic {
    Get-NetAdapter | Sort-Object -Property MacAddress
}
Set-Alias -Name getnic -Value Get-AllNic

# 2.获取 IPv4 关键路由
function Get-IPv4Routes {Get-NetRoute -AddressFamily IPv4}
Set-Alias -Name getip -Value Get-IPv4Routes

# 3.获取 IPv6 关键路由
function Get-IPv6Routes {Get-NetRoute -AddressFamily IPv6}
Set-Alias -Name getip6 -Value Get-IPv6Routes

# 4.获取当前 IP 归属地
function GetMyIp {curl -L tool.lu/ip}
#----------------------    Set Network END     ----------------------

# 欢迎界面
#clear
#$hello
#winfetch
"Welcome back User,Please type 'HelpCmd'"

# 改变默认路径（已禁用）
$path = $pwd.path
if ( $path.split("\")[-1] -eq "System32" ) {
    # change default path to desktop
#   $desktop = "C:\Users\" + $env:UserName + "\Desktop\"
    cd $desktop
}

function HelpCmd {
    "Network: getnic, getip, getip6, GetMyIp"
    "Update: #UpScoop, #UpChoco, UpWinget, UpMoudle"
    "Others: winfetch, .., ~, open, ll, ls, glola,$+hello"
}
#function UpScoop {scoop update; scoop update *}
#function UpChoco {choco upgrade chocolatey}
function UpWinget {winget upgrade}
function UpMoudle {Update-Module}