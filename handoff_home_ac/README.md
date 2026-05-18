# Handoff: PawMap — Màn Trang chủ (Home, hướng A+C)

> **For the developer:** mở `designs/index.html` trong trình duyệt để xem prototype tương tác. Artboard cần xem là **"A+C · Hợp nhất"**. Mọi đo đạc, mã màu, hành vi trong tài liệu này khớp với artboard đó.

---

## 1. Overview

PawMap là ứng dụng giúp chủ nuôi thú cưng ở Việt Nam tìm phòng khám, spa, khách sạn và pet shop gần mình. Bundle này là **màn Trang chủ (Home)** cho cả iOS và Android — một màn duy nhất theo hướng **A+C (Hợp nhất)**:

- Hero gradient xanh + greeting + search
- Lưới 4 danh mục dịch vụ
- Section "Gần bạn" với spotlight card (3 nơi gần bạn)
- Bottom nav 4 tabs

Đi kèm là **bộ icon hai tông** vẽ lại từ logo (xanh dương cho cấu trúc, xanh lá cho điểm nhấn paw).

## 2. About the Design Files

Các file trong `designs/` là **bản tham chiếu thiết kế** dựng bằng HTML + React + Babel inline để mô phỏng tương tác. Chúng **không phải code production** — không copy nguyên xi.

Nhiệm vụ: **dựng lại thiết kế này trong môi trường thật của ứng dụng PawMap** (React Native / Flutter / SwiftUI + Jetpack Compose / web React… tuỳ stack hiện có), dùng design system và component library đã có của codebase. Nếu chưa có codebase, chọn framework phù hợp cho mobile app (React Native hoặc Flutter cho cross-platform).

File chính cần đọc: **`designs/variant-ac.jsx`**. Các file `ios-frame.jsx`, `design-canvas.jsx`, `index.html` chỉ là khung trình bày prototype, không có trong app thật.

## 3. Fidelity

**High-fidelity.** Tất cả màu, typography, spacing, border radius, shadow, và tương tác đều là giá trị cuối cùng. Recreate pixel-perfect.

## 4. Màn Home (Variant A+C)

**Purpose:** Màn home mặc định khi user mở app. Dẫn user đến: tìm kiếm, chọn danh mục dịch vụ, hoặc xem địa điểm nổi bật gần mình.

**Source file:** `designs/variant-ac.jsx`

**Layout từ trên xuống (viewport mockup 360×760):**

### 4.1 Hero block

- Full-bleed, padding `60px 18px 70px` (60 top để chừa status bar)
- Background: `linear-gradient(135deg, #1B6FB5 0%, #2E86CC 55%, #4FA3DC 100%)`
- **Watermark paw màu trắng**:
  - 1 paw 180px ở góc phải-trên, `opacity: 0.13`, rotate `-12deg`
  - 1 paw 70px ở vị trí right:70 top:64, `opacity: 0.09`, rotate `18deg`
- **Top row** (flex space-between, position-relative z-index:2):
  - Trái: cụm logo + greeting
    - Logo tile 42×42 radius 12, nền trắng, shadow `0 4px 12px rgba(0,0,0,.12)`, chứa `PinGlyph size=28` (xanh dương + paw xanh lá)
    - 2 dòng text bên phải logo:
      - Eyebrow: `XIN CHÀO MINH` — 11/500, letter-spacing .4, màu `rgba(255,255,255,.78)`
      - Title: `PawMap Vietnam` — 19/700, letter-spacing -.2, màu `#FFFFFF`
  - Phải: bell button 40×40 radius 12, nền `rgba(255,255,255,.18)`, border `1px solid rgba(255,255,255,.25)`. Icon chuông trắng 20px với dot xanh lá `#8DC63F` (badge thông báo)
- **Search bar** (margin-top 18, height 48, radius 14, nền trắng, shadow `0 8px 22px rgba(15,39,64,.12)`, padding `0 6px 0 14px`, z-index 2):
  - Search icon 18px màu `#7C8C9C`
  - Input placeholder: `Tìm phòng khám, spa, pet shop…` (13.5/normal, `#0F2740`)
  - Filter chip 36×36 radius 10, nền `#1B6FB5`, icon 3 vạch trắng (filter icon)

### 4.2 Body container

- Nền `#F6F8FB`, margin-top `-36` (đè lên hero), border-top-radius 24, padding `24px 16px 12px`, position-relative z-index 1

### 4.3 Section "Dịch vụ"

**Header row** (flex space-between, padding `4px 4px 12px`):
- Title `Dịch vụ` — 16/700, `#0F2740`, letter-spacing -.2
- Link `Xem tất cả` — 12/600, `#1B6FB5`

**Grid 4 cột × 1 hàng, gap 10**, mỗi cell:
- Padding `8px 0`
- Tile 62×62 radius 18, shadow `0 2px 6px rgba(15,39,64,.05)`, transition `box-shadow .2s, transform .2s`
- Icon 30px ở giữa tile (xem `icons.jsx`)
- Label dưới tile (gap 8): 11.5/600, `#0F2740`, text-align center

**Thứ tự + tint background**:
| # | Label | Icon component | Tile background | Shadow màu (state active) |
|---|---|---|---|---|
| 1 | Phòng khám | `VetIcon` | `#E6F0F9` | `rgba(27,111,181,.18)` |
| 2 | Spa & Tắm | `GroomingIcon` | `#EAF6D9` | `rgba(141,198,63,.22)` |
| 3 | Khách sạn | `HotelIcon` | `#E6F0F9` | `rgba(27,111,181,.18)` |
| 4 | Pet Shop | `ShopIcon` | `#EAF6D9` | `rgba(141,198,63,.22)` |

**State active** (sau khi tap): cell `transform: translateY(-2px)`, tile shadow đổi sang `0 8px 20px <tint shadow>`.

### 4.4 Section "Gần bạn"

**Header row** (flex space-between, padding `20px 4px 12px`):
- Trái — 2 dòng:
  - Title `Gần bạn` — 16/700, `#0F2740`, letter-spacing -.2
  - Subtitle row (display flex, gap 4, margin-top 3): icon pin `LocationDotIcon size=11 color=#1B6FB5` + text `Quận 1, TP.HCM` — 11.5/normal, `#5A6B7C`
- Phải: link `Xem bản đồ` — 12/600, `#1B6FB5`

### 4.5 Spotlight card

Card: background `#FFFFFF`, radius 22, overflow hidden, shadow `0 4px 16px rgba(15,39,64,.06)`

**Top — Mini map** (height 120px, position relative, overflow hidden):
- SVG flat-color map (xem function `MiniMap` trong `variant-c.jsx`):
  - Nền `#EAF1F7`
  - 2 mảng xanh lá công viên `#D8EBB1` (ellipse)
  - Đường trắng nét đậm (stroke-width 6–10)
- **Pin lớn** ở giữa (`left:50% top:50%`, transform `translate(-50%,-100%)`):
  - `PinGlyph size=32` (xanh + paw xanh lá), filter `drop-shadow(0 4px 6px rgba(0,0,0,.18))`
- **Badge nổi** (position absolute, top 10, left 12):
  - Text `3 nơi gần bạn` — 11/700, `#0F2740`
  - Background trắng, padding `4px 10px`, radius 999, shadow `0 2px 6px rgba(0,0,0,.08)`

**Bottom — Content** (padding `14px 14px 14px`):
- **Status row** (flex gap 6):
  - Dot 6px radius 99 nền `#8DC63F`
  - Text `ĐANG MỞ CỬA` — 11/700, `#6FA82C`, letter-spacing .5 (uppercase)
- **Name** (margin-top 6): `Phòng khám PetCare` — 16/800, `#0F2740`, letter-spacing -.2
- **Address** (margin-top 2): `2 Nguyễn Huệ, Quận 1 · Cách bạn 2.5 km` — 12/normal, `#5A6B7C`
- **Meta tags** (margin-top 10, flex gap 8) — mỗi tag là pill:
  - Padding `4px 9px`, radius 999, background `#F2F5F8`, gap 4, font 11.5/600 `#0F2740`
  - Tag 1: `StarIcon size=11 color=#F5A623` + `4.8 · 124 đánh giá`
  - Tag 2: `LocationDotIcon size=11 color=#1B6FB5` + `2.5 km`
- **Buttons row** (margin-top 12, flex gap 8):
  - Primary `Xem chi tiết`: flex 1, height 40, radius 12, background `#1B6FB5`, text trắng 13/700, shadow `0 4px 10px rgba(27,111,181,.25)`
  - Ghost `Chỉ đường`: flex 1, height 40, radius 12, background trắng, border `1.5px solid #1B6FB5`, text `#1B6FB5` 13/700

### 4.6 Bottom Nav

- Height 76 (iOS — cộng safe-area-inset-bottom), background trắng
- Border-top `1px solid rgba(15,39,64,.06)`
- Shadow `0 -4px 18px rgba(15,39,64,.05)`
- Grid 4 cột, padding `8px 4px 14px`
- **4 tabs theo thứ tự**:
  1. `Trang chủ` — `HomeLineIcon`
  2. `Bản đồ` — `MapLineIcon`
  3. `Lịch hẹn` — `CalendarLineIcon`
  4. `Hồ sơ` — `ProfileLineIcon`
- Tab inactive: icon outline 24px `#9AA7B4`, label 10.5/500 `#9AA7B4`
- Tab active:
  - Icon filled 24px `#1B6FB5`
  - Label 10.5/700 `#1B6FB5`
  - Thanh chỉ báo 24×3 radius 2 nền `#1B6FB5` ở vị trí `top:-8`, `transform: translateX(-50%)` (đặt phía trên icon)

## 5. Interactions & Behavior

| Action | Behavior |
|---|---|
| Tap category tile | Toggle local active state — tile lift `translateY(-2px)`, shadow đậm hơn. Trong app thật: navigate to category listing screen. |
| Tap search bar | Open search overlay (chưa thiết kế — placeholder cho phase sau) |
| Tap bell | Navigate to notifications screen |
| Tap "Xem tất cả" (services) | Navigate to all-categories screen |
| Tap "Xem bản đồ" (gần bạn) | Switch sang tab Bản đồ |
| Tap spotlight card (toàn card) | Navigate to detail screen của PetCare |
| Tap "Xem chi tiết" | Như trên — detail screen |
| Tap "Chỉ đường" | Mở app bản đồ hệ thống (Apple Maps / Google Maps) với địa chỉ đích |
| Tap nav tab | Switch tab; indicator slide vào icon mới (transition `.18s`) |

**Transitions:**
- Category tile: `transform .18s ease`, `box-shadow .2s`
- Nav indicator: `.18s ease`

## 6. State Management

```ts
type HomeState = {
  selectedCategory: 'vet' | 'groom' | 'hotel' | 'shop' | null,
  selectedTab: 'home' | 'map' | 'cal' | 'me',
  userLocation: { district: string, city: string, lat: number, lng: number },
  featuredPlace: Place,   // 1 place cho spotlight (api: GET /places/featured)
  unreadNotifs: number,   // hiển thị dot trên bell
}
```

Data fetching:
- `GET /places/featured?lat&lng` → 1 place + 3 nearby places dùng cho mini-map pin
- Cache 5 phút, refetch khi pull-to-refresh hoặc location đổi

## 7. Design Tokens

### Colors
```
// Brand
--blue-primary:    #1B6FB5
--blue-deep:       #155488
--blue-bright:     #2E86CC    (gradient middle)
--blue-light:      #4FA3DC    (gradient end)
--green-paw:       #8DC63F
--green-deep:      #6FA82C

// Neutrals
--ink:             #0F2740   (text primary)
--muted:           #5A6B7C   (text secondary)
--outline:         #B7C2CC   (chevron, divider)
--mist:            #F6F8FB   (body bg)
--surface:         #FFFFFF
--chip-bg:         #F2F5F8

// Category tile tints
--tint-blue:       #E6F0F9
--tint-green:      #EAF6D9

// Map
--map-bg:          #EAF1F7
--map-park:        #D8EBB1

// Status
--star:            #F5A623
```

### Typography (iOS: SF Pro / system; Android: Roboto)
| Token | Spec |
|---|---|
| Display title | 19/700 / -0.2 |
| Section title | 16/700 / -0.2 |
| Card title | 16/800 / -0.2 |
| Body strong | 14.5/700 |
| Body | 13.5/normal |
| Caption | 12/normal |
| Eyebrow | 11/700 / +0.5 uppercase |
| Nav label active | 10.5/700 |
| Nav label inactive | 10.5/500 |

### Spacing (px)
`4, 6, 8, 10, 12, 14, 16, 18, 20, 24`

### Radius
- Tile small: 10, 12
- Tile medium: 14, 16, 18
- Card: 22
- Pill: 999
- Body sheet top corners: 24

### Shadow
```
--shadow-card:     0 2px 6px rgba(15,39,64,.05)
--shadow-elevated: 0 4px 16px rgba(15,39,64,.06)
--shadow-floating: 0 8px 22px rgba(15,39,64,.12)
--shadow-pop:      0 10px 24px rgba(27,111,181,.28)
--shadow-nav-top:  0 -4px 18px rgba(15,39,64,.05)
--shadow-btn:      0 4px 10px rgba(27,111,181,.25)
```

## 8. Assets / Icons

`designs/icons.jsx` chứa toàn bộ icon dạng SVG inline. Export sang asset library của codebase:

**Brand glyphs:**
- `PawGlyph(size, color)` — paw 4 toe + palm
- `PinGlyph(size, blue, green)` — location pin chứa paw bên trong (logo mark)

**Category icons** (viewBox 32×32, sized 28–30):
- `VetIcon` — chữ thập y tế + paw stamp
- `GroomingIcon` — kéo + nơ
- `HotelIcon` — ngôi nhà + paw door
- `ShopIcon` — túi mua hàng + bone tag
- *(Bonus — chưa dùng ở home A+C nhưng có sẵn: `EmergencyIcon`, `WalkIcon`, `TrainingIcon`)*

**Line icons** (viewBox 24×24, có prop `filled` cho state active):
- `HomeLineIcon`, `MapLineIcon`, `CalendarLineIcon`, `ProfileLineIcon`

**Utility:**
- `SearchIcon`, `BellIcon(dot)`, `ChevronRightIcon`, `StarIcon`, `LocationDotIcon`, `ClockIcon`

`assets/logo.png` — logo gốc do user cung cấp (reference, có thể dùng làm splash hoặc app icon).

## 9. Files

```
designs/
  index.html              ← entry, mở trong trình duyệt để xem prototype (artboard "A+C · Hợp nhất")
  variant-ac.jsx          ← MÀN HOME CHÍNH — đọc file này
  variant-a.jsx           ← (dependency) chứa BottomNav + vaStyles dùng chung
  icons.jsx               ← bộ icon SVG
  ios-frame.jsx           ← khung iPhone (chỉ để preview)
  design-canvas.jsx       ← canvas trình bày artboard (chỉ để preview)
assets/
  logo.png                ← logo gốc
README.md                 ← file này
```

## 10. Notes for the implementer

- `PinGlyph` (pin xanh + paw xanh lá) là **brand mark cốt lõi** — dùng làm logo trong app, splash, và map markers. Vector-perfect.
- Tất cả copy bằng tiếng Việt — không dịch sang tiếng Anh trừ khi có yêu cầu i18n.
- Bottom nav iOS dùng `safe-area-inset-bottom`; Android dùng gesture nav bar height.
- Hero gradient + watermark paw nên tách thành 1 component `HomeHero` tái sử dụng được.
- Spotlight card nên là 1 component `FeaturedPlaceCard(place)` nhận data từ API.
- Bộ icon SVG nên convert sang component / asset chuẩn của framework (React Native: `react-native-svg` hoặc SVGR; Flutter: flutter_svg; Compose: `ImageVector`).
