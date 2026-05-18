

### 4.2 Variant B (Map-first) — `variant-b.jsx`

**Purpose:** Cho user muốn tìm địa điểm trực quan qua bản đồ.

**Layout:**

1. **Top half (380px)** — map background (SVG block pattern + parks + roads, xem `MapBackdrop` trong `variant-b.jsx`)
   - **Overlay top bar** (top 58, padding ngang 14): avatar paw + "Vị trí hiện tại / Quận 1, TP.HCM ▾" bên trái, bell trắng bên phải
   - **Search pill** (top 108, height 46, radius 14, nền trắng, shadow `0 10px 22px rgba(15,39,64,.13)`): search icon + input `Tìm trên bản đồ…` + nút paw xanh lá
   - **Map pins**: 4 pin nhỏ + 1 pin selected to hơn (38px) có tooltip `Cún Cưng` (white pill, radius 10, shadow). Vị trí xem array `pins` trong code.
   - **User dot pulse** ở giữa: 14px dot xanh dương border trắng 3px, pulse animation `pmpulse 1.8s ease-out infinite` (scale từ .6 đến 2.4, opacity .8→0)
   - **Map controls** (bottom 24, right 14): 2 nút 38×38 radius 12 nền trắng — recenter + filter

2. **Bottom sheet** (margin-top -22, radius `24 24 0 0`, padding ngang 16):
   - Handle 40×4 radius 4 nền `#D8E0E8`
   - **Filter chips** (overflow-x auto): chip nền `#F2F5F8` radius 999 padding `7px 14px` 12.5/600. Active: nền `#E6F0F9`, border `1px solid #1B6FB5`, text `#1B6FB5`. 5 chips: Tất cả, Phòng khám, Grooming, Khách sạn, Pet Shop.
   - **Section header**: `23 địa điểm gần bạn` (16/700) + subtitle `Sắp xếp theo khoảng cách` (11.5, `#5A6B7C`)
   - **List 3 cards** (gap 10): card radius 16, padding 12, border `1px solid rgba(15,39,64,.08)`. Card selected: border xanh dương, nền `rgba(230,240,249,.6)`, shadow `0 4px 14px rgba(27,111,181,.15)`. Thumbnail 50×50 radius 14 + name + tag + rating/distance + nút CTA `Đặt` (height 32, radius 999, nền `#1B6FB5`, text trắng 12/700).

3. **Bottom nav** — giống Variant A+C.

### 4.3 Android variants — `variant-android.jsx`

3 hướng song song cho Android, dùng **Material 3 / Material You**:
- **VariantAndroidA** — M3 chuẩn: top app bar + M3 search pill + 6 category tiles (radius 22) + hero card radius 28 + M3 list cards (radius 20) + M3 nav bar với pill indicator
- **VariantAndroidB** — Map-first + FAB cấp cứu (radius 16, nền `#FDE8E8`, position fixed bottom-right)
- **VariantAndroidC** — Material You expressive: pet hero radius 32, service cards grid 3 cột với surfaceContainerLow

**Material 3 tokens** dùng trong file:
```
primary: #1B6FB5         primaryContainer: #DBEAF7    onPrimaryContainer: #0E3F6A
secondary: #8DC63F       secondaryContainer: #E8F4D6  onSecondaryContainer: #3F5A0C
tertiaryContainer: #FDE8E8   onTertiaryContainer: #7A1F1F
surface: #FBF8F4         surfaceContainerLow: #F4F1ED surfaceContainer: #EEEAE4
outline: #74797F         outlineVariant: #C4C7CD
onSurface: #1A1C1E       onSurfaceVar: #43474E
```

## 5. Interactions & Behavior

| Action | Behavior |
|---|---|
| Tap category tile | Toggle active state — tile lift `translateY(-2px)`, shadow đậm hơn. (Real app: navigate to category listing screen) |
| Tap search bar | Open search overlay (chưa thiết kế — placeholder cho phase sau) |
| Tap bell | Open notifications screen |
| Tap "Xem tất cả" / "Xem bản đồ" | Navigate to all-services / map view |
| Tap spotlight card "Xem chi tiết" | Navigate to place detail screen của PetCare |
| Tap "Chỉ đường" | Mở app bản đồ hệ thống (Google Maps / Apple Maps) với địa chỉ đích |
| Tap nav tab | Switch tab; tab indicator slide vào icon mới (animation `.18s ease`) |
| Variant B — tap map pin | Highlight pin, scroll bottom sheet đến card tương ứng và select |
| Variant B — drag bottom sheet | Expand/collapse (chưa làm trong prototype; standard iOS/Android sheet behavior) |

**Transitions:**
- Category tile hover/active: `transform .18s`, `box-shadow .2s`
- Pulse on user location dot: `2s ease-out infinite`
- Tất cả các nút có ripple/highlight chuẩn của platform

## 6. State Management

```
homeState = {
  selectedCategory: string | null,    // category đang active
  selectedTab: 'home' | 'map' | 'cal' | 'me',
  notifications: { count, dot },      // bell indicator
  userLocation: { district, city, lat, lng },
  nearbyPlaces: Place[],              // fetched từ API theo location
  featuredPlace: Place,               // 1 place cho spotlight card
}
```

Data fetching:
- `GET /places/nearby?lat&lng&radius` → trả về list places
- `GET /places/featured?location` → trả về 1 spotlight
- Cache trong session, refetch khi location đổi hoặc pull-to-refresh

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

// Tints (category tiles, hue)
--tint-blue:       #E6F0F9
--tint-green:      #EAF6D9
--tint-red:        #FDE6E6

// Status
--alert:           #E94545
--star:            #F5A623
```

### Typography (iOS — system / SF Pro; Android — Roboto)
- Display title:    19/700 / -0.2
- Section title:    16/700 / -0.2
- Card title:       16/800 / -0.2
- Body strong:      14.5/700
- Body:             13.5/normal
- Caption:          12/normal
- Eyebrow:          11/700 / +0.5 uppercase
- Nav label:        10.5/700 (active) — 10.5/500 (inactive)

### Spacing scale (px)
`4, 6, 8, 10, 12, 14, 16, 18, 20, 24`

### Radius
- Tile small: 10, 12
- Tile medium: 14, 16, 18
- Card: 18, 22
- Pill: 999
- Body sheet (top corners): 24
- Bottom sheet (top corners): 24, M3: 28

### Shadow
```
--shadow-card:     0 2px 6px rgba(15,39,64,.05)
--shadow-elevated: 0 4px 16px rgba(15,39,64,.06)
--shadow-floating: 0 8px 22px rgba(15,39,64,.12)
--shadow-pop:      0 10px 24px rgba(27,111,181,.28)
--shadow-nav-top:  0 -4px 18px rgba(15,39,64,.05)
```

## 8. Assets

- `assets/logo.png` — logo gốc do user cung cấp
- **Icons** — toàn bộ icon dịch vụ và nav vẽ bằng SVG inline trong `icons.jsx`. Export sang asset library của codebase (SVG hoặc font-icon set). Mỗi icon:
  - `VetIcon`, `GroomingIcon`, `HotelIcon`, `ShopIcon`, `EmergencyIcon`, `WalkIcon`, `TrainingIcon` — viewBox 32×32, sized 28–30
  - `HomeLineIcon`, `MapLineIcon`, `CalendarLineIcon`, `ProfileLineIcon` — viewBox 24×24, có prop `filled` cho state active
  - `SearchIcon`, `BellIcon`, `ChevronRightIcon`, `StarIcon`, `LocationDotIcon`, `ClockIcon` — utility
  - `PawGlyph`, `PinGlyph` — brand mark glyphs

## 9. Files

```
designs/
  index.html              ← entry, mở trong trình duyệt để xem tương tác
  icons.jsx               ← bộ icon (SVG)
  variant-ac.jsx          ← MÀN CHÍNH (A+C hợp nhất)
  variant-b.jsx           ← Map-first
  variant-a.jsx           ← (reference) phiên bản gốc A
  variant-c.jsx           ← (reference) phiên bản gốc C
  variant-android.jsx     ← 3 hướng Android Material 3
  ios-frame.jsx           ← khung iPhone (chỉ để preview, không dùng trong app thật)
  android-frame.jsx       ← khung Android (chỉ để preview)
  design-canvas.jsx       ← khung trình bày các artboard (không dùng trong app thật)
assets/
  logo.png
README.md                 ← file này
```

**Ưu tiên triển khai:** `variant-ac.jsx` (màn home chính) và `variant-b.jsx` (map screen — có thể dùng cho tab "Bản đồ" trong bottom nav).

## 10. Notes for the implementer

- Component `PinGlyph` (pin xanh + paw xanh lá bên trong) là **brand mark cốt lõi** — dùng làm logo trong app, splash, và map markers. Phải vector-perfect.
- Tất cả copy đều bằng tiếng Việt. Không dịch sang tiếng Anh trừ khi có yêu cầu i18n.
- Bottom nav iOS dùng safe-area-inset-bottom; Android dùng gesture nav bar height.
- Map screen (Variant B) phải dùng thư viện bản đồ thật (MapKit / Google Maps SDK / Mapbox) — SVG `MapBackdrop` chỉ là placeholder.
- Pulse animation cho user location dot: dùng CSS keyframe `pmpulse` trong `index.html`, hoặc native equivalent.
