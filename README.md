# Website các CLB THPT Lê Quý Đôn

Website giới thiệu danh sách các câu lạc bộ của trường THPT Lê Quý Đôn với thiết kế card layout hiện đại, bao gồm trang chủ và các trang chi tiết từng câu lạc bộ.

## Cấu trúc website

**Trang chính:**
- `index.html` — Danh sách tất cả câu lạc bộ của trường dạng grid card
- `styles.css` — CSS responsive tự tạo với dark/light theme

**Các trang câu lạc bộ:**
- `clb-sang-tao.html` — CLB Sáng Tạo (Công nghệ & Thiết kế)
- `clb-nhiep-anh.html` — CLB Nhiếp ảnh (Nghệ thuật)
- `clb-chay-bo.html` — CLB Chạy bộ (Thể thao)  
- `clb-doc-sach.html` — CLB Đọc sách (Văn học & Tri thức)
- `clb-nau-an.html` — CLB Nấu ăn (Ẩm thực)
- `clb-am-nhac.html` — CLB Âm nhạc

## Liên hệ chung

📧 Email: clb@lequydon-hanoi.edu.vn  
🏫 Trường THPT Lê Quý Đôn - Hà Nội

## Chạy website

```bash
# Mở trang chủ
start .\index.html

# Hoặc mở trực tiếp bất kỳ trang nào trong trình duyệt
```

## Tính năng

✅ Responsive design (mobile + desktop)  
✅ Navigation giữa các trang  
✅ Thông tin chi tiết từng CLB  
✅ Thông tin liên hệ phù hợp với môi trường học đường  
✅ Dark/Light theme tự động  
✅ Card hover effects

## Tối ưu ảnh & performance

- Repo hiện tại chứa ảnh gốc ở `images/` (JPG). Để giảm dung lượng và cải thiện thời gian tải, nên chuyển các ảnh lớn sang định dạng WebP và tạo các phiên bản responsive.

### Lệnh gợi ý (Windows PowerShell)

Với ImageMagick (`magick`):
```powershell
Get-ChildItem -Path images -Filter *.jpg | ForEach-Object {
	magick "$_" -quality 75 "${($_.DirectoryName)}\${($_.BaseName)}.webp"
}
```

Với `cwebp` (Google WebP):
```powershell
Get-ChildItem -Path images -Filter *.jpg | ForEach-Object {
	& cwebp -q 75 "$_" -o "${($_.DirectoryName)}\${($_.BaseName)}.webp"
}
```

Sau khi sinh `.webp`, script trên trang sẽ ưu tiên sử dụng `.webp` nếu server trả 200 cho request HEAD. Nên cân nhắc:
- Resize ảnh hero xuống kích thước phù hợp (ví dụ 1600px rộng) trước khi chuyển sang WebP.
- Chất lượng 60-80 thường là lựa chọn tốt giữa chất lượng và dung lượng.

Nếu muốn tôi tự động tạo thêm các phiên bản responsive (`-sm`, `-md`, `-lg`) và cập nhật mã để dùng `srcset`/`picture`, hãy cho biết.

## Thay đổi (changelog nhanh)

- Thêm Google Fonts (Poppins + JetBrains Mono)
- Thêm dark/light toggle và lưu preference vào `localStorage`
- Lazy-load background cho card (`data-bg`) và preload `.webp` nếu có
- Thêm hiệu ứng reveal khi cuộn
- Thêm icon SVG cho social links

## Script tiện ích

Trong `scripts/` có hai script PowerShell:

- `generate-webp.ps1`: tạo các phiên bản WebP responsive (`-sm`, `-md`, `-lg`) và bản `.webp` cho mỗi ảnh trong `images/`. Yêu cầu `magick` (ImageMagick) hoặc `cwebp`.
- `git-commit-if-git.ps1`: helper để `git add` + `git commit` nếu repo đã khởi tạo git.

Chạy ví dụ (PowerShell):

```powershell
# Tạo webp responsive
.\scripts\generate-webp.ps1

# Commit nếu bạn dùng git
.\scripts\git-commit-if-git.ps1
```

## Progressive Web App (PWA)

Tôi đã thêm `manifest.json` và `sw.js` để bạn có thể cài trang làm PWA (Add to Home) và có caching offline cơ bản.

- Manifest: `manifest.json` (tham chiếu tới `images/manifest-icon-192.svg` và `images/manifest-icon-512.svg`).
- Service worker: `sw.js` (cache app shell và cache theo runtime cho các request GET).

Lưu ý:
- Để thử PWA đầy đủ, hãy phục vụ trang qua HTTPS hoặc `http://localhost` (ví dụ `python -m http.server 8000`).
- Bạn có thể thêm PNG icon đa kích thước nếu muốn hỗ trợ nhiều trình duyệt hơn.

### Tạo PNG icons (tùy chọn)

Để có biểu tượng PNG đa kích thước cho `manifest.json`, bạn có thể chuyển `images/manifest-icon-512.svg` sang PNG bằng ImageMagick:

```powershell
magick images/manifest-icon-512.svg -resize 512x512 images/manifest-icon-512.png
magick images/manifest-icon-192.svg -resize 192x192 images/manifest-icon-192.png
```

Sau khi tạo PNG, manifest đã chấp nhận tên `images/manifest-icon-192.png` và `images/manifest-icon-512.png` (nếu bạn muốn dùng PNG thay cho SVG).

## SEO & Accessibility improvements

- Đã thêm meta `description`, `canonical`, Open Graph và Twitter card trong `index.html`.
- Thêm JSON-LD (Organization/School) cho rich result.
- Thêm `sitemap.xml` và `robots.txt` (cập nhật `https://example.com` thành URL thực của bạn).
- Cải thiện accessibility: `tabindex` cho card, `focus-visible` style, modal trap focus.

## Further polish added

- Animated SVG blobs in the hero for a modern, organic background. You can adjust particle blob colors in `styles.css`.
- Header polish: logo square animation and improved nav hover indicator.
- Cards: glass-like border glow and a magnify button that opens a lightbox.
- Smooth page transitions: internal link clicks fade out the page before navigation.
- Lightbox: click the 🔍 button on any card to open a full image viewer with next/prev controls.

## Deployment helper

To publish to GitHub Pages (recommended simple flow):

1. Create a repo and push your site files to it.
2. In GitHub repo Settings → Pages, set source to `main` branch (or `gh-pages` branch) and root folder `/`.

For a more automated workflow, add a GitHub Action to deploy the `main` branch to `gh-pages` (I can scaffold it if you want).

## Analytics (privacy-friendly)

If you want lightweight analytics, add Plausible or Fathom. Plausible example (replace with your domain):

```html
<!-- Plausible (example) -->
<!-- <script async defer data-domain="yourdomain.com" src="https://plausible.io/js/plausible.js"></script> -->
```

Enable it by adding your domain and uncommenting the script tag.

## Form liên hệ

- Có một modal form (`contact-modal`) dùng `Formspree` làm ví dụ. Thay `action` trong form (`https://formspree.io/f/your-form-id`) bằng endpoint Formspree thực của bạn hoặc dịch vụ tương đương.


