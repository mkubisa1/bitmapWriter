# colors (backwards from RGB representation, by BMP format spec)
[byte[]]$lights = 255,255,255
[byte[]]$helmet = 64,128,255
[byte[]]$hair = 4,58,98
[byte[]]$skin = 113,194,249
[byte[]]$darks = 32,32,32
[byte[]]$pants = 17,95,255

$previewImage = "$pwd\bmpWriterPreview.bmp"
if(Test-Path "$previewImage") {Clear-Content "$previewImage"}

[byte[]]$header = @(
    0x42,0x4D,              # "BM" header for all bitmap images
    0x36,0x06,0x00,0x00,    # file size in bytes
    0x00,0x00,0x00,0x00,    # reserved area
    0x36,0x00,0x00,0x00     # byte offset of where pixel data starts
)
foreach($i in $header) { Add-Content "$previewImage" $i -Encoding byte }     # note: "-encoding byte" only works with powershell 5 (default windows install.) powershell 6+ uses -asbytestream instead.

[byte[]]$info = @(
    0x28,0x00,0x00,0x00,    # size of the info header
    0x10,0x00,0x00,0x00,    # image width in pixels (16)
    0x20,0x00,0x00,0x00,    # image height in pixels (32)
    0x01,0x00,              # number of "color planes" (always 1)
    0x18,0x00,              # number of btis per pixel (24-bit)
    0x00,0x00,0x00,0x00,    # compression method used (no compression)
    0x00,0x06,0x00,0x00,    # image size (in bytes)
    0xC2,0x0E,0x00,0x00,    # horizontal resolution (irrelevant)
    0xC2,0x0E,0x00,0x00,    # vertical resolution   (irrelevant)
    0x00,0x00,0x00,0x00,    # number of colors in color palette (0 is default)
    0x00,0x00,0x00,0x00     # number of important colors (0 => all colors important)
)
foreach($i in $info) { Add-Content "$previewImage" $i -Encoding byte }

# bottom-most row, starting from the left
$pixels = "aaaaaeeaaeeaaaaaaaaaaeeaaeeaaaaaaaaaaeeaaeeaaaaaaaaaaffaaffaaaaaaaaaaffaaffaaaaaaaaaaffaaffaaaaaaaddaffaaffaddaaaaddaffffffaddaaaabbabbbbbbabbaaaabbabbbbbbabbaaaabbabbbbbbabbaaaabbabbbbbbabbaaaabbabbbbbbabbaaaabbbbbbbbbbbbaaaaabbbbbbbbbbaaaaaaaaaaddaaaaaaaaaaddddddddddaaaaaddddddddddddaaaddddddddddddddabddddddddddddddbbddaeeddddaeeddbbdaaeeeddaaeeedbbdaaeeeddaaeeedbbdaaeeedcccccedbbcdaeedddccccccbbccccccccccccccbbbccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbabbbbbbbbbbbbbbaaabbbbbbbbbbbbaaaaabbbbbbbbbbaaa"
for($i = 0; $i -lt $pixels.length; $i++) {
    switch($pixels[$i]) {
        'a' {Add-Content "$previewImage" $lights -Encoding byte}
        'b' {Add-Content "$previewImage" $helmet -Encoding byte}
        'c' {Add-Content "$previewImage" $hair -Encoding byte}
        'd' {Add-Content "$previewImage" $skin -Encoding byte}
        'e' {Add-Content "$previewImage" $darks -Encoding byte}
        'f' {Add-Content "$previewImage" $pants -Encoding byte}
        '0' {Add-Content "$previewImage" ([byte]0x00) -Encoding byte}   # some parts of hex may be padded with 0s per the BMP spec (not used in this example)
    }
}

Start-Process $previewImage
Read-Host "When you are done viewing the preview, press enter to delete the preview"
Remove-Item $previewImage