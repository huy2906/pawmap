// variant-a.jsx — Clean Modern
// White base, deep blue hero w/ subtle paw watermark, 6-category grid w/ unique tinted tiles,
// nearby list w/ rating, soft promo banner, animated bottom nav.

function VariantA() {
  const [tab, setTab] = React.useState('home');
  const [activeCat, setActiveCat] = React.useState(null);

  const cats = [
    { id: 'vet',    label: 'Phòng khám',    Icon: VetIcon,        tint: '#E6F0F9', shadow: 'rgba(27,111,181,.18)' },
    { id: 'groom',  label: 'Spa & Tắm',     Icon: GroomingIcon,   tint: '#EAF6D9', shadow: 'rgba(141,198,63,.22)' },
    { id: 'hotel',  label: 'Khách sạn',     Icon: HotelIcon,      tint: '#E6F0F9', shadow: 'rgba(27,111,181,.18)' },
    { id: 'shop',   label: 'Pet Shop',      Icon: ShopIcon,       tint: '#EAF6D9', shadow: 'rgba(141,198,63,.22)' },
    { id: 'train',  label: 'Huấn luyện',    Icon: TrainingIcon,   tint: '#E6F0F9', shadow: 'rgba(27,111,181,.18)' },
    { id: 'sos',    label: 'Cấp cứu 24/7',  Icon: EmergencyIcon,  tint: '#FDE6E6', shadow: 'rgba(233,69,69,.22)' },
  ];

  const nearby = [
    { name: 'Phòng khám PetCare', tag: 'Phòng khám · Mở cửa', dist: '2.5 km', rating: 4.8, open: true, hue: '#E6F0F9' },
    { name: 'Spa Cún Cưng Sài Gòn', tag: 'Grooming · Mở cửa', dist: '1.2 km', rating: 4.9, open: true, hue: '#EAF6D9' },
    { name: 'VietPet Hospital', tag: 'Bệnh viện · Cấp cứu', dist: '3.8 km', rating: 4.7, open: true, hue: '#FDE6E6' },
  ];

  return (
    <div style={vaStyles.frame}>
      {/* Hero */}
      <div style={vaStyles.hero}>
        {/* paw watermark */}
        <div style={{ position: 'absolute', right: -20, top: 4, opacity: 0.13, transform: 'rotate(-12deg)' }}>
          <PawGlyph size={180} color="#fff"/>
        </div>
        <div style={{ position: 'absolute', right: 70, top: 64, opacity: 0.09, transform: 'rotate(18deg)' }}>
          <PawGlyph size={70} color="#fff"/>
        </div>

        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', position: 'relative', zIndex: 2 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={vaStyles.logoTile}>
              <PinGlyph size={28} blue="#1B6FB5" green={PM_GREEN}/>
            </div>
            <div>
              <div style={{ fontSize: 11, color: 'rgba(255,255,255,.78)', fontWeight: 500, letterSpacing: .4 }}>XIN CHÀO MINH</div>
              <div style={{ fontSize: 19, fontWeight: 700, color: '#fff', letterSpacing: -.2 }}>PawMap Vietnam</div>
            </div>
          </div>
          <button style={vaStyles.bellBtn} aria-label="notifications">
            <BellIcon size={20} color="#fff" dot/>
          </button>
        </div>

        {/* search */}
        <div style={vaStyles.search}>
          <SearchIcon size={18} color="#7C8C9C"/>
          <input
            readOnly
            placeholder="Tìm phòng khám, spa, pet shop…"
            style={vaStyles.searchInput}
          />
          <div style={vaStyles.filterChip}>
            <svg width="14" height="14" viewBox="0 0 24 24"><path d="M4 6h16M7 12h10M10 18h4" stroke="#fff" strokeWidth="2.4" strokeLinecap="round"/></svg>
          </div>
        </div>
      </div>

      {/* Body */}
      <div style={vaStyles.body}>
        {/* Categories */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 4px 12px' }}>
          <div style={vaStyles.sectionTitle}>Dịch vụ</div>
          <div style={vaStyles.seeAll}>Xem tất cả</div>
        </div>
        <div style={vaStyles.catGrid}>
          {cats.map(c => (
            <button
              key={c.id}
              onClick={() => setActiveCat(c.id === activeCat ? null : c.id)}
              style={{ ...vaStyles.catCell, transform: activeCat === c.id ? 'translateY(-2px)' : 'none' }}>
              <div style={{ ...vaStyles.catTile, background: c.tint, boxShadow: activeCat === c.id ? `0 8px 20px ${c.shadow}` : '0 2px 6px rgba(15,39,64,.05)' }}>
                <c.Icon size={30}/>
              </div>
              <div style={vaStyles.catLabel}>{c.label}</div>
            </button>
          ))}
        </div>

        {/* Promo */}
        <div style={vaStyles.promo}>
          <div style={{ position: 'absolute', right: -10, bottom: -10, opacity: .18 }}>
            <PawGlyph size={110} color="#fff"/>
          </div>
          <div style={{ position: 'relative', zIndex: 2 }}>
            <div style={{ fontSize: 11, fontWeight: 600, color: PM_GREEN, letterSpacing: .6 }}>ƯU ĐÃI THÁNG NÀY</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#fff', marginTop: 4, lineHeight: 1.25 }}>Tiêm phòng dại trọn gói<br/>chỉ <span style={{ color: PM_GREEN }}>199.000đ</span></div>
            <button style={vaStyles.promoBtn}>Đặt lịch ngay</button>
          </div>
          <div style={vaStyles.promoIllo}>
            <PinGlyph size={64} blue="#fff" green={PM_GREEN}/>
          </div>
        </div>

        {/* Nearby */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '18px 4px 12px' }}>
          <div>
            <div style={vaStyles.sectionTitle}>Gần bạn</div>
            <div style={vaStyles.sectionSub}>
              <LocationDotIcon size={11} color={PM_BLUE}/>
              <span>Quận 1, TP.HCM</span>
            </div>
          </div>
          <div style={vaStyles.seeAll}>Xem bản đồ</div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {nearby.map((n, i) => (
            <div key={i} style={vaStyles.placeCard}>
              <div style={{ ...vaStyles.placeThumb, background: n.hue }}>
                {n.tag.startsWith('Spa') ? <GroomingIcon size={28}/> : n.tag.startsWith('Bệnh') ? <EmergencyIcon size={28}/> : <VetIcon size={28}/>}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14.5, fontWeight: 700, color: '#0F2740' }}>{n.name}</div>
                <div style={{ fontSize: 12, color: '#5A6B7C', marginTop: 2 }}>{n.tag}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 6 }}>
                  <div style={vaStyles.metaPill}>
                    <StarIcon size={11}/>
                    <span style={{ fontSize: 11.5, fontWeight: 600, color: '#0F2740' }}>{n.rating}</span>
                  </div>
                  <div style={vaStyles.metaPill}>
                    <LocationDotIcon size={11} color={PM_BLUE}/>
                    <span style={{ fontSize: 11.5, fontWeight: 600, color: '#0F2740' }}>{n.dist}</span>
                  </div>
                </div>
              </div>
              <ChevronRightIcon size={18} color="#B7C2CC"/>
            </div>
          ))}
        </div>
        <div style={{ height: 16 }}/>
      </div>

      {/* Bottom nav */}
      <BottomNav active={tab} onChange={setTab}/>
    </div>
  );
}

function BottomNav({ active, onChange }) {
  const items = [
    { id: 'home', label: 'Trang chủ', Icon: HomeLineIcon },
    { id: 'map',  label: 'Bản đồ',    Icon: MapLineIcon },
    { id: 'cal',  label: 'Lịch hẹn',  Icon: CalendarLineIcon },
    { id: 'me',   label: 'Hồ sơ',     Icon: ProfileLineIcon },
  ];
  return (
    <div style={vaStyles.nav}>
      {items.map(it => {
        const on = active === it.id;
        return (
          <button key={it.id} onClick={() => onChange(it.id)} style={vaStyles.navBtn}>
            <div style={{ position: 'relative' }}>
              <it.Icon size={24} color={on ? PM_BLUE : '#9AA7B4'} filled={on}/>
              {on && <div style={{ position: 'absolute', top: -8, left: '50%', transform: 'translateX(-50%)', width: 24, height: 3, borderRadius: 2, background: PM_BLUE }}/>}
            </div>
            <div style={{ fontSize: 10.5, fontWeight: on ? 700 : 500, color: on ? PM_BLUE : '#9AA7B4', marginTop: 4 }}>{it.label}</div>
          </button>
        );
      })}
    </div>
  );
}

const vaStyles = {
  frame: { width: '100%', height: '100%', background: '#F6F8FB', display: 'flex', flexDirection: 'column', fontFamily: 'Inter, -apple-system, system-ui, sans-serif', position: 'relative' },
  hero: {
    background: 'linear-gradient(135deg, #1B6FB5 0%, #2E86CC 55%, #4FA3DC 100%)',
    padding: '60px 18px 70px', position: 'relative', overflow: 'hidden',
  },
  logoTile: { width: 42, height: 42, borderRadius: 12, background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 4px 12px rgba(0,0,0,.12)' },
  bellBtn: { width: 40, height: 40, borderRadius: 12, background: 'rgba(255,255,255,.18)', border: '1px solid rgba(255,255,255,.25)', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' },
  search: {
    marginTop: 18, height: 48, background: '#fff', borderRadius: 14, display: 'flex', alignItems: 'center', gap: 10, padding: '0 6px 0 14px',
    boxShadow: '0 8px 22px rgba(15,39,64,.12)', position: 'relative', zIndex: 2,
  },
  searchInput: { flex: 1, border: 'none', outline: 'none', fontSize: 13.5, color: '#0F2740', background: 'transparent', fontFamily: 'inherit' },
  filterChip: { width: 36, height: 36, borderRadius: 10, background: PM_BLUE, display: 'flex', alignItems: 'center', justifyContent: 'center' },
  body: { flex: 1, overflow: 'auto', padding: '18px 16px 12px', marginTop: -36, background: '#F6F8FB', borderTopLeftRadius: 24, borderTopRightRadius: 24, position: 'relative', zIndex: 1, paddingTop: 24 },
  sectionTitle: { fontSize: 16, fontWeight: 700, color: '#0F2740', letterSpacing: -.2 },
  sectionSub: { display: 'flex', alignItems: 'center', gap: 4, fontSize: 11.5, color: '#5A6B7C', marginTop: 3 },
  seeAll: { fontSize: 12, fontWeight: 600, color: PM_BLUE, cursor: 'pointer' },
  catGrid: { display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 12 },
  catCell: { display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8, padding: '8px 4px', border: 'none', background: 'transparent', cursor: 'pointer', transition: 'transform .18s' },
  catTile: { width: 64, height: 64, borderRadius: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', transition: 'box-shadow .2s, transform .2s' },
  catLabel: { fontSize: 11.5, fontWeight: 600, color: '#0F2740', textAlign: 'center' },
  promo: {
    marginTop: 18, position: 'relative', overflow: 'hidden',
    background: 'linear-gradient(120deg, #155488 0%, #1B6FB5 100%)', borderRadius: 18, padding: 16, display: 'flex', alignItems: 'center', justifyContent: 'space-between',
    boxShadow: '0 10px 24px rgba(27,111,181,.28)',
  },
  promoBtn: { marginTop: 10, height: 30, padding: '0 14px', borderRadius: 999, border: 'none', background: PM_GREEN, color: '#0F2740', fontSize: 12, fontWeight: 700, cursor: 'pointer', boxShadow: '0 4px 10px rgba(141,198,63,.45)' },
  promoIllo: { width: 86, height: 86, background: 'rgba(255,255,255,.14)', borderRadius: 20, display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px solid rgba(255,255,255,.2)' },
  placeCard: { display: 'flex', alignItems: 'center', gap: 12, padding: 12, background: '#fff', borderRadius: 16, boxShadow: '0 2px 8px rgba(15,39,64,.05)', border: '1px solid rgba(15,39,64,.04)' },
  placeThumb: { width: 52, height: 52, borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center', flex: '0 0 auto' },
  metaPill: { display: 'flex', alignItems: 'center', gap: 4, padding: '2px 8px', background: '#F2F5F8', borderRadius: 999 },
  nav: {
    height: 76, background: '#fff', borderTop: '1px solid rgba(15,39,64,.06)', display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', alignItems: 'center', padding: '8px 4px 14px',
    boxShadow: '0 -4px 18px rgba(15,39,64,.05)',
  },
  navBtn: { display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: 'transparent', border: 'none', cursor: 'pointer' },
};

window.VariantA = VariantA;
window.BottomNav = BottomNav;
window.vaStyles = vaStyles;
