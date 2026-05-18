// variant-ac.jsx — Combined: A's hero/categories + C's spotlight card replacing the promo

function VariantAC() {
  const [tab, setTab] = React.useState('home');
  const [activeCat, setActiveCat] = React.useState(null);

  const cats = [
  { id: 'vet', label: 'Phòng khám', Icon: VetIcon, tint: '#E6F0F9', shadow: 'rgba(27,111,181,.18)' },
  { id: 'groom', label: 'Spa & Tắm', Icon: GroomingIcon, tint: '#EAF6D9', shadow: 'rgba(141,198,63,.22)' },
  { id: 'hotel', label: 'Khách sạn', Icon: HotelIcon, tint: '#E6F0F9', shadow: 'rgba(27,111,181,.18)' },
  { id: 'shop', label: 'Pet Shop', Icon: ShopIcon, tint: '#EAF6D9', shadow: 'rgba(141,198,63,.22)' }];


  const nearby = [
  { name: 'Phòng khám PetCare', tag: 'Phòng khám · Mở cửa', dist: '2.5 km', rating: 4.8, hue: '#E6F0F9', Icon: VetIcon },
  { name: 'Spa Cún Cưng Sài Gòn', tag: 'Grooming · Mở cửa', dist: '1.2 km', rating: 4.9, hue: '#EAF6D9', Icon: GroomingIcon },
  { name: 'VietPet Hospital', tag: 'Bệnh viện · Cấp cứu', dist: '3.8 km', rating: 4.7, hue: '#FDE6E6', Icon: EmergencyIcon }];


  return (
    <div style={vaStyles.frame}>
      {/* Hero — from variant A */}
      <div style={vaStyles.hero}>
        <div style={{ position: 'absolute', right: -20, top: 4, opacity: 0.13, transform: 'rotate(-12deg)' }}>
          <PawGlyph size={180} color="#fff" />
        </div>
        <div style={{ position: 'absolute', right: 70, top: 64, opacity: 0.09, transform: 'rotate(18deg)' }}>
          <PawGlyph size={70} color="#fff" />
        </div>

        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', position: 'relative', zIndex: 2 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={vaStyles.logoTile}>
              <PinGlyph size={28} blue="#1B6FB5" green={PM_GREEN} />
            </div>
            <div>
              <div style={{ fontSize: 11, color: 'rgba(255,255,255,.78)', fontWeight: 500, letterSpacing: .4 }}>XIN CHÀO MINH</div>
              <div style={{ fontSize: 19, fontWeight: 700, color: '#fff', letterSpacing: -.2 }}>PawMap Vietnam</div>
            </div>
          </div>
          <button style={vaStyles.bellBtn} aria-label="notifications">
            <BellIcon size={20} color="#fff" dot />
          </button>
        </div>

        <div style={vaStyles.search}>
          <SearchIcon size={18} color="#7C8C9C" />
          <input readOnly placeholder="Tìm phòng khám, spa, pet shop…" style={vaStyles.searchInput} />
          <div style={vaStyles.filterChip}>
            <svg width="14" height="14" viewBox="0 0 24 24"><path d="M4 6h16M7 12h10M10 18h4" stroke="#fff" strokeWidth="2.4" strokeLinecap="round" /></svg>
          </div>
        </div>
      </div>

      <div style={vaStyles.body}>
        {/* Categories */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 4px 12px' }}>
          <div style={vaStyles.sectionTitle}>Dịch vụ</div>
          <div style={vaStyles.seeAll}>Xem tất cả</div>
        </div>
        <div style={{ ...vaStyles.catGrid, gridTemplateColumns: 'repeat(4,1fr)', gap: 10 }}>
          {cats.map((c) =>
          <button
            key={c.id}
            onClick={() => setActiveCat(c.id === activeCat ? null : c.id)}
            style={{ ...vaStyles.catCell, padding: '8px 0', transform: activeCat === c.id ? 'translateY(-2px)' : 'none' }}>
              <div style={{ ...vaStyles.catTile, width: 62, height: 62, borderRadius: 18, background: c.tint, boxShadow: activeCat === c.id ? `0 8px 20px ${c.shadow}` : '0 2px 6px rgba(15,39,64,.05)' }}>
                <c.Icon size={30} />
              </div>
              <div style={vaStyles.catLabel}>{c.label}</div>
            </button>
          )}
        </div>

        {/* Near you header — moved up under services */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '20px 4px 12px' }}>
          <div>
            <div style={vaStyles.sectionTitle}>Gần bạn</div>
            <div style={vaStyles.sectionSub}>
              <LocationDotIcon size={11} color={PM_BLUE} />
              <span>Quận 1, TP.HCM</span>
            </div>
          </div>
          <div style={vaStyles.seeAll}>Xem bản đồ</div>
        </div>

        {/* Spotlight — from variant C */}
        <div style={vcStyles.spotlight}>
          <div style={vcStyles.spotMap}>
            <MiniMap />
            <div style={vcStyles.spotPin}><PinGlyph size={32} blue={PM_BLUE} green={PM_GREEN} /></div>
            <div style={vcStyles.spotBadge}>3 nơi gần bạn</div>
          </div>
          <div style={{ padding: '14px 14px 14px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <div style={{ width: 6, height: 6, borderRadius: 99, background: PM_GREEN }} />
              <div style={{ fontSize: 11, fontWeight: 700, color: PM_GREEN_DEEP, letterSpacing: .5 }}>ĐANG MỞ CỬA</div>
            </div>
            <div style={{ fontSize: 16, fontWeight: 800, color: '#0F2740', marginTop: 6, letterSpacing: -.2 }}>Phòng khám PetCare</div>
            <div style={{ fontSize: 12, color: '#5A6B7C', marginTop: 2 }}>2 Nguyễn Huệ, Quận 1 · Cách bạn 2.5 km</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 10 }}>
              <div style={vcStyles.tag}><StarIcon size={11} /><span>4.8 · 124 đánh giá</span></div>
              <div style={vcStyles.tag}><LocationDotIcon size={11} color={PM_BLUE} /><span>2.5 km</span></div>
            </div>
            <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
              <button style={vcStyles.primaryBtn}>Xem chi tiết  </button>
              <button style={vcStyles.ghostBtn}>Chỉ đường</button>
            </div>
          </div>
        </div>

        <div style={{ height: 16 }} />
      </div>

      <BottomNav active={tab} onChange={setTab} />
    </div>);

}

window.VariantAC = VariantAC;