# Script tạo các phiên bản WebP responsive cho ảnh trong thư mục images/
# Yêu cầu: ImageMagick (magick) hoặc cwebp có trong PATH
# Sử dụng PowerShell: mở terminal ở thư mục repo và chạy: .\scripts\generate-webp.ps1

$images = Get-ChildItem -Path .\images -Include *.jpg,*.png -File
if(-not $images){ Write-Host "Không tìm thấy ảnh jpg/png trong images/"; exit }

foreach($img in $images){
  $full = $img.FullName
  $dir = $img.DirectoryName
  $base = $img.BaseName

  Write-Host "Processing $($img.Name) ..."

  # Create sizes: sm (480), md (900), lg (1600)
  $sizes = @{"sm"=480; "md"=900; "lg"=1600}

  foreach($k in $sizes.Keys){
    $w = $sizes[$k]
    $out = Join-Path $dir "$($base)-$k.webp"
    if(Test-Path $out){ Write-Host " - Skipping existing $out"; continue }
    if(Get-Command magick -ErrorAction SilentlyContinue){
      magick "$full" -resize ${w}x -quality 75 "$out"
    }elseif(Get-Command cwebp -ErrorAction SilentlyContinue){
      # create a temporary resized jpg then convert
      $tmp = Join-Path $dir "$($base)-tmp-$k.jpg"
      magick "$full" -resize ${w}x "$tmp"
      & cwebp -q 75 "$tmp" -o "$out" | Out-Null
      Remove-Item "$tmp" -ErrorAction SilentlyContinue
    }else{
      Write-Host "Neither magick nor cwebp found. Install ImageMagick or cwebp and re-run." -ForegroundColor Yellow
      break
    }
    Write-Host " - Created $out"
  }

  # Also create full-width webp
  $fullwebp = Join-Path $dir "$($base).webp"
  if(-not (Test-Path $fullwebp)){
    if(Get-Command magick -ErrorAction SilentlyContinue){
      magick "$full" -quality 80 "$fullwebp"
      Write-Host " - Created $fullwebp"
    }elseif(Get-Command cwebp -ErrorAction SilentlyContinue){
      & cwebp -q 80 "$full" -o "$fullwebp" | Out-Null
      Write-Host " - Created $fullwebp"
    }
  }
}

Write-Host "Done. Kiểm tra thư mục images/ để xem các file .webp được tạo."