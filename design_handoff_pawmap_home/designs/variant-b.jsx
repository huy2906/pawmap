// variant-b.jsx — Map-forward home
// Top half: stylised SVG map with location pins; floating search + greeting overlay.
// Bottom: bottom-sheet style scrollable content with filter chips & nearby cards.

function VariantB() {
  const [tab, setTab] = React.useState('home');
  const [filter, setFilter] = React.useState('all');

  const chips = [
    { id: 'all',   label: 'Tất cả',     Icon: null },
    { id: 'vet',   label: 'Phòng khám', Icon: VetIcon },
    { id: 'groom', label: 'Grooming',   Icon: GroomingIcon },
    { id: 'hotel', label: 'Khách sạn',  Icon: HotelIcon },
    { id: 'shop',  label: 'Pet Shop',   Icon: ShopIcon },
  ];

  const pins = [
    { id: 1, x: 22,  y: 52, type: 'vet',   selected: false },
    { id: 2, x: 48,  y: 44, type: 'groom', selected: true  },
    { id: 3, x: 72,  y: 58, type: 'shop',  selected: false },
    { id: 4, x: 30,  y: 78, type: 'hotel', selected: false },
    { id: 5, x: 68,  y: 82, type: 'vet',   selected: false },
  ];

  const places = [
    { name: 'Spa Cún Cưng Sài Gòn', tag: 'Grooming · Mở đến 21:00', dist: '1.2 km', rating: 4.9, hue: '#EAF6D9', Icon: GroomingIcon, selected: true },
    { name: 'Phòng khám PetCare',   tag: 'Phòng khám · Mở cửa',    dist: '2.5 km', rating: 4.8, hue: '#E6F0F9', Icon: VetIcon },
    { name: 'Pet Mart Lê Lợi',      tag: 'Pet Shop · Mở 24/7',     dist: '0.8 km', rating: 4.6, hue: '#EAF6D9', Icon: ShopIcon },
  ];

  return (
    <div style={vbStyles.frame}>
      {/* Map */}
      <div style={vbStyles.map}>
        <MapBackdrop/>
        {/* pins */}
        {pins.map(p => (
          <div key={p.id} style={{ position: 'absolute', left: `${p.x}%`, top: `${p.y}%`, transform: 'translate(-50%,-100%)' }}>
            {p.selected ? (
              <div style={vbStyles.pinSel}>
                <PinGlyph size={36} blue={PM_BLUE} green={PM_GREEN}/>
                <div style={vbStyles.pinSelTag}>Cún Cưng</div>
              </div>
            ) : (
              <PinGlyph size={26} blue={PM_BLUE} green={PM_GREEN}/>
            )}
          </div>
        ))}
        {/* user dot */}
        <div style={{ position: 'absolute', left: '50%', top: '50%', transform: 'translate(-50%,-50%)' }}>
          <div style={vbStyles.userDotPulse}/>
          <div style={vbStyles.userDot}/>
        </div>

        {/* Top overlay: greeting + bell */}
        <div style={vbStyles.topBar}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={vbStyles.avatar}>
              <PawGlyph size={20} color={PM_GREEN}/>
            </div>
            <div>
              <div style={{ fontSize: 11, color: '#5A6B7C', fontWeight: 500 }}>Vị trí hiện tại</div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
                <LocationDotIcon size={12} color={PM_BLUE}/>
                <div style={{ fontSize: 13.5, fontWeight: 700, color: '#0F2740' }}>Quận 1, TP.HCM</div>
                <svg width="10" height="10" viewBox="0 0 24 24"><path d="m6 9 6 6 6-6" stroke="#0F2740" strokeWidth="2.4" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
              </div>
            </div>
          </div>
          <button style={vbStyles.bellBtn}>
            <BellIcon size={18} color="#0F2740" dot/>
          </button>
        </div>

        {/* Search */}
        <div style={vbStyles.search}>
          <SearchIcon size={18} color="#7C8C9C"/>
          <input readOnly placeholder="Tìm trên bản đồ…" style={vbStyles.searchInput}/>
          <div style={vbStyles.searchPaw}><PawGlyph size={18} color={PM_GREEN}/></div>
        </div>

        {/* Floating map controls */}
        <div style={vbStyles.mapCtrls}>
          <button style={vbStyles.mapBtn}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M12 2v3M12 19v3M2 12h3M19 12h3" stroke="#0F2740" strokeWidth="2" strokeLinecap="round"/><circle cx="12" cy="12" r="6" stroke="#0F2740" strokeWidth="2"/><circle cx="12" cy="12" r="2" fill={PM_BLUE}/></svg>
          </button>
          <button style={vbStyles.mapBtn}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M4 6h16M7 12h10M10 18h4" stroke="#0F2740" strokeWidth="2" strokeLinecap="round"/></svg>
          </button>
        </div>
      </div>

      {/* Bottom sheet */}
      <div style={vbStyles.sheet}>
        <div style={vbStyles.handle}/>

        {/* Chips */}
        <div style={vbStyles.chipRow}>
          {chips.map(c => (
            <button key={c.id} onClick={() => setFilter(c.id)}
              style={{ ...vbStyles.chip, ...(filter === c.id ? vbStyles.chipActive : null) }}>
              {c.Icon && <div style={{ width: 18, height: 18, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <c.Icon size={18}/>
              </div>}
              <span>{c.label}</span>
            </button>
          ))}
        </div>

        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '12px 4px 8px' }}>
          <div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#0F2740' }}>23 địa điểm gần bạn</div>
            <div style={{ fontSize: 11.5, color: '#5A6B7C', marginTop: 2 }}>Sắp xếp theo khoảng cách</div>
          </div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {places.map((p, i) => (
            <div key={i} style={{ ...vbStyles.placeCard, ...(p.selected ? vbStyles.placeCardSel : null) }}>
              <div style={{ ...vbStyles.thumb, background: p.hue }}>
                <p.Icon size={28}/>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <div style={{ fontSize: 14.5, fontWeight: 700, color: '#0F2740' }}>{p.name}</div>
                  {p.selected && <div style={vbStyles.selDot}/>}
                </div>
                <div style={{ fontSize: 12, color: '#5A6B7C', marginTop: 2 }}>{p.tag}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 6 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 3 }}>
                    <StarIcon size={11}/>
                    <span style={{ fontSize: 11.5, fontWeight: 600, color: '#0F2740' }}>{p.rating}</span>
                  </div>
                  <div style={{ width: 3, height: 3, borderRadius: 99, background: '#C8D1DA' }}/>
                  <div style={{ fontSize: 11.5, color: '#5A6B7C' }}>{p.dist}</div>
                </div>
              </div>
              <button style={vbStyles.cta}>Đặt</button>
            </div>
          ))}
        </div>
        <div style={{ height: 12 }}/>
      </div>

      <BottomNav active={tab} onChange={setTab}/>
    </div>
  );
}

function MapBackdrop() {
  // stylised flat-color map: roads + blocks. Soft palette aligned to blue/green.
  return (
    <svg width="100%" height="100%" viewBox="0 0 360 380" preserveAspectRatio="xMidYMid slice" style={{ position: 'absolute', inset: 0 }}>
      <defs>
        <pattern id="blocks" x="0" y="0" width="60" height="60" patternUnits="userSpaceOnUse">
          <rect width="60" height="60" fill="#EAF1F7"/>
          <rect x="6" y="6" width="22" height="18" rx="3" fill="#fff"/>
          <rect x="32" y="6" width="22" height="22" rx="3" fill="#fff"/>
          <rect x="6" y="30" width="18" height="24" rx="3" fill="#fff"/>
          <rect x="28" y="32" width="26" height="22" rx="3" fill="#fff"/>
        </pattern>
      </defs>
      <rect width="360" height="380" fill="url(#blocks)"/>
      {/* parks (green blobs) */}
      <ellipse cx="80" cy="220" rx="48" ry="32" fill="#D8EBB1"/>
      <ellipse cx="290" cy="100" rx="40" ry="28" fill="#D8EBB1"/>
      {/* water */}
      <path d="M0 320 Q90 300 180 320 T 360 320 L360 380 L0 380 Z" fill="#CFE3F2"/>
      {/* roads */}
      <path d="M0 180 L360 175" stroke="#fff" strokeWidth="14"/>
      <path d="M0 180 L360 175" stroke="#E0E8F0" strokeWidth="1"/>
      <path d="M180 0 L180 380" stroke="#fff" strokeWidth="12"/>
      <path d="M180 0 L180 380" stroke="#E0E8F0" strokeWidth="1"/>
      <path d="M40 0 Q60 120 100 220 Q140 320 200 380" stroke="#fff" strokeWidth="8" fill="none"/>
    </svg>
  );
}

const vbStyles = {
  frame: { width: '100%', height: '100%', background: '#fff', display: 'flex', flexDirection: 'column', fontFamily: 'Inter, -apple-system, system-ui, sans-serif', position: 'relative', overflow: 'hidden' },
  map: { position: 'relative', flex: '0 0 380px', overflow: 'hidden' },
  topBar: { position: 'absolute', top: 58, left: 14, right: 14, display: 'flex', alignItems: 'center', justifyContent: 'space-between', zIndex: 5 },
  avatar: { width: 38, height: 38, borderRadius: 12, background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 4px 10px rgba(15,39,64,.12)' },
  bellBtn: { width: 38, height: 38, borderRadius: 12, background: '#fff', border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', boxShadow: '0 4px 10px rgba(15,39,64,.12)' },
  search: { position: 'absolute', top: 108, left: 14, right: 14, height: 46, background: '#fff', borderRadius: 14, display: 'flex', alignItems: 'center', gap: 10, padding: '0 14px', boxShadow: '0 10px 22px rgba(15,39,64,.13)', zIndex: 5 },
  searchInput: { flex: 1, border: 'none', outline: 'none', fontSize: 13.5, color: '#0F2740', background: 'transparent', fontFamily: 'inherit' },
  searchPaw: { width: 28, height: 28, borderRadius: 8, background: '#F4FAE5', display: 'flex', alignItems: 'center', justifyContent: 'center' },
  mapCtrls: { position: 'absolute', right: 14, bottom: 24, display: 'flex', flexDirection: 'column', gap: 8 },
  mapBtn: { width: 38, height: 38, borderRadius: 12, background: '#fff', border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 4px 10px rgba(15,39,64,.18)' },
  userDot: { width: 14, height: 14, borderRadius: 99, background: PM_BLUE, border: '3px solid #fff', boxShadow: '0 2px 6px rgba(0,0,0,.2)' },
  userDotPulse: { position: 'absolute', top: -8, left: -8, width: 30, height: 30, borderRadius: 99, background: 'rgba(27,111,181,.25)', animation: 'pmpulse 1.8s ease-out infinite' },
  pinSel: { display: 'flex', flexDirection: 'column', alignItems: 'center', filter: 'drop-shadow(0 4px 8px rgba(0,0,0,.2))' },
  pinSelTag: { marginTop: -4, padding: '3px 8px', background: '#fff', borderRadius: 8, fontSize: 10.5, fontWeight: 700, color: '#0F2740', boxShadow: '0 2px 6px rgba(0,0,0,.15)' },

  sheet: { flex: 1, marginTop: -22, background: '#fff', borderRadius: '24px 24px 0 0', padding: '8px 16px 4px', boxShadow: '0 -6px 20px rgba(15,39,64,.08)', position: 'relative', zIndex: 2, overflow: 'auto' },
  handle: { width: 40, height: 4, borderRadius: 4, background: '#D8E0E8', margin: '0 auto 12px' },
  chipRow: { display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4, scrollbarWidth: 'none' },
  chip: { display: 'flex', alignItems: 'center', gap: 6, padding: '7px 14px', borderRadius: 999, background: '#F2F5F8', border: '1px solid transparent', fontSize: 12.5, fontWeight: 600, color: '#0F2740', whiteSpace: 'nowrap', cursor: 'pointer', fontFamily: 'inherit', flex: '0 0 auto' },
  chipActive: { background: '#E6F0F9', border: `1px solid ${PM_BLUE}`, color: PM_BLUE },
  placeCard: { display: 'flex', alignItems: 'center', gap: 12, padding: 12, background: '#fff', borderRadius: 16, border: '1px solid rgba(15,39,64,.08)' },
  placeCardSel: { borderColor: PM_BLUE, background: 'rgba(230,240,249,.6)', boxShadow: '0 4px 14px rgba(27,111,181,.15)' },
  selDot: { width: 7, height: 7, borderRadius: 99, background: PM_GREEN },
  thumb: { width: 50, height: 50, borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center', flex: '0 0 auto' },
  cta: { height: 32, padding: '0 14px', borderRadius: 999, background: PM_BLUE, color: '#fff', fontSize: 12, fontWeight: 700, border: 'none', cursor: 'pointer' },
};

window.VariantB = VariantB;
window.MapBackdrop = MapBackdrop;
