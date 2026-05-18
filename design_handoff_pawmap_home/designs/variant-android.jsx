// variant-android.jsx — Material 3 / Material You variants
// 3 Android home screens that feel native, not just iOS in an Android frame.
// Uses M3 patterns: pill-indicator nav bar, surface containers, FAB, filled chips,
// expressive corner radii. Roboto/Google Sans.

const MD = {
  primary: '#1B6FB5',
  onPrimary: '#fff',
  primaryContainer: '#DBEAF7',
  onPrimaryContainer: '#0E3F6A',
  secondary: PM_GREEN,
  secondaryContainer: '#E8F4D6',
  onSecondaryContainer: '#3F5A0C',
  tertiaryContainer: '#FDE8E8',
  onTertiaryContainer: '#7A1F1F',
  surface: '#FBF8F4',
  surfaceContainerLow: '#F4F1ED',
  surfaceContainer: '#EEEAE4',
  surfaceContainerHigh: '#E8E4DE',
  outline: '#74797F',
  outlineVariant: '#C4C7CD',
  onSurface: '#1A1C1E',
  onSurfaceVar: '#43474E',
  error: '#BA1A1A',
};

// ─────────────────────────────────────────────────────────────
// M3 bottom navigation — pill active indicator behind icon
// ─────────────────────────────────────────────────────────────
function M3Nav({ active, onChange }) {
  const items = [
    { id: 'home', label: 'Trang chủ', Icon: HomeLineIcon },
    { id: 'map',  label: 'Bản đồ',    Icon: MapLineIcon },
    { id: 'cal',  label: 'Lịch hẹn',  Icon: CalendarLineIcon },
    { id: 'me',   label: 'Hồ sơ',     Icon: ProfileLineIcon },
  ];
  return (
    <div style={m3Styles.nav}>
      {items.map(it => {
        const on = active === it.id;
        return (
          <button key={it.id} onClick={() => onChange(it.id)} style={m3Styles.navBtn}>
            <div style={{ ...m3Styles.navPill, background: on ? MD.secondaryContainer : 'transparent' }}>
              <it.Icon size={24} color={on ? MD.onSecondaryContainer : MD.onSurfaceVar} filled={on}/>
            </div>
            <div style={{ fontSize: 12, fontWeight: on ? 600 : 500, color: on ? MD.onSurface : MD.onSurfaceVar, marginTop: 4, letterSpacing: .1 }}>{it.label}</div>
          </button>
        );
      })}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Variant A · Material 3 standard
// ─────────────────────────────────────────────────────────────
function VariantAndroidA() {
  const [tab, setTab] = React.useState('home');
  const cats = [
    { id: 'vet',    label: 'Phòng khám',   Icon: VetIcon,       container: MD.primaryContainer,    on: MD.onPrimaryContainer },
    { id: 'groom',  label: 'Spa & Tắm',    Icon: GroomingIcon,  container: MD.secondaryContainer,  on: MD.onSecondaryContainer },
    { id: 'hotel',  label: 'Khách sạn',    Icon: HotelIcon,     container: MD.primaryContainer,    on: MD.onPrimaryContainer },
    { id: 'shop',   label: 'Pet Shop',     Icon: ShopIcon,      container: MD.secondaryContainer,  on: MD.onSecondaryContainer },
    { id: 'train',  label: 'Huấn luyện',   Icon: TrainingIcon,  container: MD.primaryContainer,    on: MD.onPrimaryContainer },
    { id: 'sos',    label: 'Cấp cứu',      Icon: EmergencyIcon, container: MD.tertiaryContainer,   on: MD.onTertiaryContainer },
  ];
  const nearby = [
    { name: 'Phòng khám PetCare',    tag: 'Phòng khám · Mở cửa',  dist: '2.5 km', rating: 4.8, hue: MD.primaryContainer,   Icon: VetIcon },
    { name: 'Spa Cún Cưng Sài Gòn',  tag: 'Grooming · Mở cửa',    dist: '1.2 km', rating: 4.9, hue: MD.secondaryContainer, Icon: GroomingIcon },
    { name: 'Pet Mart Lê Lợi',       tag: 'Pet Shop · 24/7',      dist: '0.8 km', rating: 4.6, hue: MD.secondaryContainer, Icon: ShopIcon },
  ];
  return (
    <div style={m3Styles.frame}>
      {/* App bar */}
      <div style={m3Styles.appbar}>
        <div style={m3Styles.appbarRow}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={m3Styles.logoSlot}>
              <PinGlyph size={26} blue={MD.primary} green={PM_GREEN}/>
            </div>
            <div>
              <div style={{ fontSize: 20, fontWeight: 500, color: MD.onSurface, fontFamily: 'Roboto, system-ui, sans-serif', letterSpacing: 0 }}>PawMap</div>
              <div style={{ fontSize: 12, color: MD.onSurfaceVar }}>Bạn đồng hành thú cưng</div>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 4 }}>
            <button style={m3Styles.iconBtn}><SearchIcon size={22} color={MD.onSurface}/></button>
            <button style={m3Styles.iconBtn}><BellIcon size={22} color={MD.onSurface} dot/></button>
          </div>
        </div>

        {/* M3 search bar — pill */}
        <div style={m3Styles.searchPill}>
          <SearchIcon size={20} color={MD.onSurfaceVar}/>
          <input readOnly placeholder="Tìm phòng khám, spa, pet shop…" style={m3Styles.searchInput}/>
          <div style={m3Styles.avatarMini}><PawGlyph size={18} color={MD.primary}/></div>
        </div>
      </div>

      {/* Body */}
      <div style={m3Styles.body}>
        {/* Categories */}
        <div style={m3Styles.sectionHead}>
          <div style={m3Styles.sectionTitle}>Dịch vụ</div>
          <button style={m3Styles.textBtn}>Xem tất cả</button>
        </div>
        <div style={m3Styles.catGrid}>
          {cats.map(c => (
            <button key={c.id} style={m3Styles.catCell}>
              <div style={{ ...m3Styles.catTile, background: c.container }}>
                <c.Icon size={30}/>
              </div>
              <div style={m3Styles.catLabel}>{c.label}</div>
            </button>
          ))}
        </div>

        {/* Hero promo (M3 large card) */}
        <div style={m3Styles.heroCard}>
          <div style={{ position: 'absolute', right: -12, bottom: -16, opacity: .22 }}>
            <PawGlyph size={140} color="#fff"/>
          </div>
          <div style={{ position: 'relative', zIndex: 2 }}>
            <div style={{ fontSize: 12, fontWeight: 700, color: MD.secondary, letterSpacing: .6, textTransform: 'uppercase' }}>Ưu đãi tháng 5</div>
            <div style={{ fontSize: 22, fontWeight: 500, color: '#fff', marginTop: 6, lineHeight: 1.2, letterSpacing: -.3 }}>Tiêm phòng dại<br/>chỉ <span style={{ color: PM_GREEN, fontWeight: 700 }}>199.000đ</span></div>
            <div style={{ fontSize: 13, color: 'rgba(255,255,255,.78)', marginTop: 6 }}>Áp dụng tại 12 phòng khám đối tác</div>
            <button style={m3Styles.filledBtn}>Đặt lịch</button>
          </div>
        </div>

        {/* Nearby */}
        <div style={{ ...m3Styles.sectionHead, marginTop: 24 }}>
          <div>
            <div style={m3Styles.sectionTitle}>Gần bạn</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 2 }}>
              <LocationDotIcon size={12} color={MD.primary}/>
              <span style={{ fontSize: 12, color: MD.onSurfaceVar }}>Quận 1, TP.HCM</span>
            </div>
          </div>
          <button style={m3Styles.textBtn}>Bản đồ</button>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {nearby.map((n, i) => (
            <div key={i} style={m3Styles.listCard}>
              <div style={{ ...m3Styles.listThumb, background: n.hue }}>
                <n.Icon size={28}/>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 500, color: MD.onSurface }}>{n.name}</div>
                <div style={{ fontSize: 12.5, color: MD.onSurfaceVar, marginTop: 2 }}>{n.tag}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 6 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 3 }}>
                    <StarIcon size={12}/><span style={{ fontSize: 12, fontWeight: 500, color: MD.onSurface }}>{n.rating}</span>
                  </div>
                  <div style={{ width: 3, height: 3, borderRadius: 99, background: MD.outlineVariant }}/>
                  <span style={{ fontSize: 12, color: MD.onSurfaceVar }}>{n.dist}</span>
                </div>
              </div>
              <ChevronRightIcon size={20} color={MD.outline}/>
            </div>
          ))}
        </div>
        <div style={{ height: 8 }}/>
      </div>

      <M3Nav active={tab} onChange={setTab}/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Variant B · Map-first w/ FAB
// ─────────────────────────────────────────────────────────────
function VariantAndroidB() {
  const [tab, setTab] = React.useState('home');
  const [filter, setFilter] = React.useState('all');

  const chips = [
    { id: 'all',   label: 'Tất cả',     Icon: null },
    { id: 'vet',   label: 'Phòng khám', Icon: VetIcon },
    { id: 'groom', label: 'Grooming',   Icon: GroomingIcon },
    { id: 'shop',  label: 'Pet Shop',   Icon: ShopIcon },
  ];
  const places = [
    { name: 'Spa Cún Cưng Sài Gòn', tag: 'Grooming · Đang mở',  dist: '1.2 km', rating: 4.9, hue: MD.secondaryContainer, Icon: GroomingIcon, selected: true },
    { name: 'Phòng khám PetCare',   tag: 'Phòng khám · Đang mở', dist: '2.5 km', rating: 4.8, hue: MD.primaryContainer,   Icon: VetIcon },
    { name: 'Pet Mart Lê Lợi',      tag: 'Pet Shop · 24/7',      dist: '0.8 km', rating: 4.6, hue: MD.secondaryContainer, Icon: ShopIcon },
  ];

  return (
    <div style={{ ...m3Styles.frame, position: 'relative' }}>
      {/* Map */}
      <div style={{ position: 'relative', flex: '0 0 360px', overflow: 'hidden' }}>
        <MapBackdrop/>
        <div style={{ position: 'absolute', left: '22%', top: '50%' }}><PinGlyph size={28} blue={MD.primary} green={PM_GREEN}/></div>
        <div style={{ position: 'absolute', left: '48%', top: '42%' }}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', filter: 'drop-shadow(0 4px 8px rgba(0,0,0,.2))' }}>
            <PinGlyph size={38} blue={MD.primary} green={PM_GREEN}/>
            <div style={{ marginTop: -4, padding: '4px 10px', background: '#fff', borderRadius: 10, fontSize: 11, fontWeight: 600, color: MD.onSurface, boxShadow: '0 2px 6px rgba(0,0,0,.15)' }}>Cún Cưng</div>
          </div>
        </div>
        <div style={{ position: 'absolute', left: '72%', top: '58%' }}><PinGlyph size={28} blue={MD.primary} green={PM_GREEN}/></div>
        <div style={{ position: 'absolute', left: '30%', top: '78%' }}><PinGlyph size={28} blue={MD.primary} green={PM_GREEN}/></div>
        <div style={{ position: 'absolute', left: '68%', top: '82%' }}><PinGlyph size={28} blue={MD.primary} green={PM_GREEN}/></div>

        {/* user dot */}
        <div style={{ position: 'absolute', left: '50%', top: '60%', transform: 'translate(-50%,-50%)' }}>
          <div style={{ position: 'absolute', top: -8, left: -8, width: 30, height: 30, borderRadius: 99, background: 'rgba(27,111,181,.25)', animation: 'pmpulse 1.8s ease-out infinite' }}/>
          <div style={{ width: 14, height: 14, borderRadius: 99, background: MD.primary, border: '3px solid #fff', boxShadow: '0 2px 6px rgba(0,0,0,.2)' }}/>
        </div>

        {/* M3 docked search bar */}
        <div style={m3Styles.dockedSearch}>
          <button style={{ ...m3Styles.iconBtn, width: 40, height: 40 }}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M4 6h16M7 12h10M10 18h4" stroke={MD.onSurface} strokeWidth="2" strokeLinecap="round"/></svg>
          </button>
          <input readOnly placeholder="Tìm địa điểm…" style={{ ...m3Styles.searchInput, fontSize: 14 }}/>
          <div style={m3Styles.avatarMini}><PawGlyph size={18} color={MD.primary}/></div>
        </div>

        {/* Floating action button — emergency */}
        <button style={m3Styles.fab}>
          <EmergencyIcon size={26}/>
        </button>
      </div>

      {/* Sheet */}
      <div style={m3Styles.sheet}>
        <div style={m3Styles.handle}/>

        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4 }}>
          {chips.map(c => {
            const on = filter === c.id;
            return (
              <button key={c.id} onClick={() => setFilter(c.id)}
                style={{ ...m3Styles.chip, ...(on ? m3Styles.chipOn : null) }}>
                {c.Icon && <c.Icon size={18}/>}
                {on && !c.Icon && <svg width="18" height="18" viewBox="0 0 24 24"><path d="m5 12 5 5 9-10" stroke={MD.onSecondaryContainer} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" fill="none"/></svg>}
                <span>{c.label}</span>
              </button>
            );
          })}
        </div>

        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '14px 4px 10px' }}>
          <div style={m3Styles.sectionTitle}>23 địa điểm gần bạn</div>
          <button style={m3Styles.textBtn}>Lọc</button>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {places.map((p, i) => (
            <div key={i} style={{ ...m3Styles.listCard, ...(p.selected ? { background: MD.primaryContainer } : null) }}>
              <div style={{ ...m3Styles.listThumb, background: p.selected ? '#fff' : p.hue }}>
                <p.Icon size={26}/>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 500, color: MD.onSurface }}>{p.name}</div>
                <div style={{ fontSize: 12.5, color: MD.onSurfaceVar, marginTop: 2 }}>{p.tag}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
                  <StarIcon size={12}/><span style={{ fontSize: 12, fontWeight: 500 }}>{p.rating}</span>
                  <div style={{ width: 3, height: 3, borderRadius: 99, background: MD.outlineVariant }}/>
                  <span style={{ fontSize: 12, color: MD.onSurfaceVar }}>{p.dist}</span>
                </div>
              </div>
              <button style={m3Styles.tonalBtn}>Đặt</button>
            </div>
          ))}
        </div>
        <div style={{ height: 8 }}/>
      </div>

      <M3Nav active={tab} onChange={setTab}/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Variant C · Material You expressive
// ─────────────────────────────────────────────────────────────
function VariantAndroidC() {
  const [tab, setTab] = React.useState('home');
  const [petIdx, setPetIdx] = React.useState(0);
  const pets = [
    { name: 'Milu', type: 'Poodle · 2 tuổi',  paw: MD.primary,   bg: MD.primaryContainer },
    { name: 'Bông', type: 'Mèo Anh · 1 tuổi', paw: PM_GREEN_DEEP, bg: MD.secondaryContainer },
  ];
  const pet = pets[petIdx];
  const services = [
    { id: 'vet', label: 'Phòng khám', Icon: VetIcon },
    { id: 'g',   label: 'Grooming',   Icon: GroomingIcon },
    { id: 'h',   label: 'Khách sạn',  Icon: HotelIcon },
    { id: 's',   label: 'Pet Shop',   Icon: ShopIcon },
    { id: 'w',   label: 'Dắt đi dạo', Icon: WalkIcon },
    { id: 't',   label: 'Huấn luyện', Icon: TrainingIcon },
  ];

  return (
    <div style={m3Styles.frame}>
      <div style={{ padding: '8px 16px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <PinGlyph size={32} blue={MD.primary} green={PM_GREEN}/>
          <div style={{ fontSize: 22, fontWeight: 500, color: MD.onSurface }}>PawMap</div>
        </div>
        <div style={{ display: 'flex', gap: 4 }}>
          <button style={m3Styles.iconBtn}><SearchIcon size={22} color={MD.onSurface}/></button>
          <button style={m3Styles.iconBtn}><BellIcon size={22} color={MD.onSurface} dot/></button>
        </div>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '8px 16px 8px' }}>
        {/* Expressive pet hero — wavy blob shape */}
        <div style={{ ...m3Styles.expressiveHero, background: pet.bg }}>
          <div style={{ position: 'absolute', right: -20, bottom: -24, opacity: .2 }}>
            <PawGlyph size={170} color={pet.paw}/>
          </div>
          <div style={{ position: 'relative', zIndex: 2 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
              <div style={{ width: 60, height: 60, borderRadius: 24, background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <PawGlyph size={32} color={pet.paw}/>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 12, color: MD.onSurfaceVar, fontWeight: 500 }}>Chào buổi sáng, Minh 👋</div>
                <div style={{ fontSize: 24, fontWeight: 500, color: MD.onSurface, letterSpacing: -.4 }}>{pet.name} khoẻ mạnh!</div>
                <div style={{ fontSize: 12.5, color: MD.onSurfaceVar }}>{pet.type}</div>
              </div>
            </div>

            <div style={m3Styles.apptCard}>
              <div style={{ ...m3Styles.apptDate, background: pet.paw }}>
                <div style={{ fontSize: 9, color: '#fff', fontWeight: 700, letterSpacing: .5 }}>THG 5</div>
                <div style={{ fontSize: 18, color: '#fff', fontWeight: 700, lineHeight: 1 }}>18</div>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 13.5, fontWeight: 500, color: MD.onSurface }}>Tiêm vắc-xin tổng hợp</div>
                <div style={{ fontSize: 12, color: MD.onSurfaceVar, display: 'flex', alignItems: 'center', gap: 4, marginTop: 2 }}>
                  <ClockIcon size={11}/>9:30 · PetCare
                </div>
              </div>
              <ChevronRightIcon size={20} color={MD.outline}/>
            </div>

            <div style={{ display: 'flex', gap: 6, marginTop: 14, justifyContent: 'center' }}>
              {pets.map((_, i) => (
                <button key={i} onClick={() => setPetIdx(i)} style={{ width: i === petIdx ? 22 : 8, height: 8, borderRadius: 99, background: i === petIdx ? pet.paw : 'rgba(0,0,0,.18)', border: 'none', cursor: 'pointer', transition: 'all .25s' }}/>
              ))}
            </div>
          </div>
        </div>

        {/* Services */}
        <div style={{ ...m3Styles.sectionHead, marginTop: 20 }}>
          <div style={m3Styles.sectionTitle}>Dịch vụ cho {pet.name}</div>
          <button style={m3Styles.textBtn}>Tất cả</button>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 10 }}>
          {services.map((s, i) => (
            <button key={s.id} style={m3Styles.servCard}>
              <div style={{ ...m3Styles.servCardTile, background: i % 2 === 0 ? MD.primaryContainer : MD.secondaryContainer }}>
                <s.Icon size={28}/>
              </div>
              <div style={{ fontSize: 12, fontWeight: 500, color: MD.onSurface, marginTop: 8 }}>{s.label}</div>
            </button>
          ))}
        </div>

        {/* Spotlight with mini map */}
        <div style={{ ...m3Styles.sectionHead, marginTop: 20 }}>
          <div style={m3Styles.sectionTitle}>Đề xuất cho bạn</div>
        </div>
        <div style={m3Styles.spotCard}>
          <div style={{ position: 'relative', height: 110 }}>
            <MiniMap/>
            <div style={{ position: 'absolute', left: '50%', top: '50%', transform: 'translate(-50%,-100%)' }}>
              <PinGlyph size={32} blue={MD.primary} green={PM_GREEN}/>
            </div>
            <div style={{ position: 'absolute', top: 10, left: 12, padding: '4px 10px', background: '#fff', borderRadius: 999, fontSize: 11.5, fontWeight: 600, boxShadow: '0 1px 4px rgba(0,0,0,.1)' }}>3 nơi gần bạn</div>
          </div>
          <div style={{ padding: '14px 16px 14px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <div style={{ width: 6, height: 6, borderRadius: 99, background: PM_GREEN }}/>
              <span style={{ fontSize: 11, fontWeight: 700, color: PM_GREEN_DEEP, letterSpacing: .5 }}>ĐANG MỞ CỬA</span>
            </div>
            <div style={{ fontSize: 17, fontWeight: 500, color: MD.onSurface, marginTop: 6 }}>Phòng khám PetCare</div>
            <div style={{ fontSize: 12.5, color: MD.onSurfaceVar, marginTop: 2 }}>2 Nguyễn Huệ · 2.5 km</div>
            <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
              <button style={m3Styles.filledBtnSm}>Đặt lịch khám</button>
              <button style={m3Styles.outlinedBtn}>Chỉ đường</button>
            </div>
          </div>
        </div>
        <div style={{ height: 8 }}/>
      </div>

      <M3Nav active={tab} onChange={setTab}/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Material 3 styles
// ─────────────────────────────────────────────────────────────
const m3Styles = {
  frame: { width: '100%', height: '100%', background: MD.surface, display: 'flex', flexDirection: 'column', fontFamily: 'Roboto, "Google Sans", system-ui, sans-serif' },
  appbar: { background: MD.surface, padding: '4px 4px 12px' },
  appbarRow: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '8px 8px 8px 12px' },
  logoSlot: { width: 40, height: 40, borderRadius: 12, background: MD.primaryContainer, display: 'flex', alignItems: 'center', justifyContent: 'center' },
  iconBtn: { width: 48, height: 48, borderRadius: 99, background: 'transparent', border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' },

  searchPill: { margin: '4px 16px 0', height: 56, background: MD.surfaceContainer, borderRadius: 28, display: 'flex', alignItems: 'center', gap: 12, padding: '0 14px' },
  searchInput: { flex: 1, border: 'none', outline: 'none', fontSize: 14, color: MD.onSurface, background: 'transparent', fontFamily: 'inherit' },
  avatarMini: { width: 32, height: 32, borderRadius: 99, background: MD.primaryContainer, display: 'flex', alignItems: 'center', justifyContent: 'center' },

  body: { flex: 1, overflow: 'auto', padding: '20px 16px 8px' },
  sectionHead: { display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 4px 12px' },
  sectionTitle: { fontSize: 18, fontWeight: 500, color: MD.onSurface, letterSpacing: 0 },
  textBtn: { background: 'transparent', border: 'none', color: MD.primary, fontSize: 13, fontWeight: 600, cursor: 'pointer', padding: '6px 10px', borderRadius: 99, fontFamily: 'inherit' },

  catGrid: { display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 10, marginBottom: 24 },
  catCell: { display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8, padding: '12px 4px', background: 'transparent', border: 'none', cursor: 'pointer', borderRadius: 16 },
  catTile: { width: 72, height: 72, borderRadius: 22, display: 'flex', alignItems: 'center', justifyContent: 'center' },
  catLabel: { fontSize: 12, fontWeight: 500, color: MD.onSurface, textAlign: 'center' },

  heroCard: { position: 'relative', overflow: 'hidden', background: 'linear-gradient(120deg, #155488 0%, #1B6FB5 100%)', borderRadius: 28, padding: '20px 22px 22px' },
  filledBtn: { marginTop: 14, height: 40, padding: '0 22px', borderRadius: 20, background: PM_GREEN, color: '#0F2740', fontSize: 14, fontWeight: 600, border: 'none', cursor: 'pointer', fontFamily: 'inherit' },

  listCard: { display: 'flex', alignItems: 'center', gap: 12, padding: 12, background: MD.surfaceContainerLow, borderRadius: 20 },
  listThumb: { width: 52, height: 52, borderRadius: 16, display: 'flex', alignItems: 'center', justifyContent: 'center', flex: '0 0 auto' },
  tonalBtn: { height: 38, padding: '0 16px', borderRadius: 20, background: MD.primaryContainer, color: MD.onPrimaryContainer, fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer', fontFamily: 'inherit' },

  dockedSearch: { position: 'absolute', top: 16, left: 16, right: 16, height: 52, background: '#fff', borderRadius: 26, display: 'flex', alignItems: 'center', gap: 8, padding: '0 8px 0 12px', boxShadow: '0 4px 14px rgba(0,0,0,.12)' },
  fab: { position: 'absolute', right: 16, bottom: 24, width: 56, height: 56, borderRadius: 16, background: MD.tertiaryContainer, border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', boxShadow: '0 4px 12px rgba(0,0,0,.18)' },

  sheet: { flex: 1, marginTop: -20, background: MD.surface, borderRadius: '28px 28px 0 0', padding: '6px 16px 6px', position: 'relative', zIndex: 2, overflow: 'auto', boxShadow: '0 -4px 14px rgba(0,0,0,.06)' },
  handle: { width: 32, height: 4, borderRadius: 4, background: MD.outlineVariant, margin: '0 auto 8px' },
  chip: { display: 'flex', alignItems: 'center', gap: 6, padding: '7px 14px', borderRadius: 10, background: 'transparent', border: `1px solid ${MD.outlineVariant}`, fontSize: 13, fontWeight: 500, color: MD.onSurface, whiteSpace: 'nowrap', cursor: 'pointer', fontFamily: 'inherit', flex: '0 0 auto' },
  chipOn: { background: MD.secondaryContainer, border: `1px solid transparent`, color: MD.onSecondaryContainer },

  expressiveHero: { borderRadius: 32, padding: 18, position: 'relative', overflow: 'hidden' },
  apptCard: { marginTop: 16, background: 'rgba(255,255,255,.85)', borderRadius: 16, padding: 10, display: 'flex', alignItems: 'center', gap: 12, border: '1px solid rgba(0,0,0,.06)' },
  apptDate: { width: 46, height: 46, borderRadius: 14, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 1 },

  servCard: { display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '14px 4px 12px', background: MD.surfaceContainerLow, borderRadius: 20, border: 'none', cursor: 'pointer', fontFamily: 'inherit' },
  servCardTile: { width: 56, height: 56, borderRadius: 18, display: 'flex', alignItems: 'center', justifyContent: 'center' },

  spotCard: { background: MD.surfaceContainerLow, borderRadius: 24, overflow: 'hidden' },
  filledBtnSm: { flex: 1, height: 40, borderRadius: 20, background: MD.primary, color: '#fff', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer', fontFamily: 'inherit' },
  outlinedBtn: { flex: 1, height: 40, borderRadius: 20, background: 'transparent', color: MD.primary, fontSize: 13, fontWeight: 600, border: `1px solid ${MD.outlineVariant}`, cursor: 'pointer', fontFamily: 'inherit' },

  nav: { height: 80, background: MD.surfaceContainer, display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', alignItems: 'center', padding: '12px 0 16px' },
  navBtn: { display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: 'transparent', border: 'none', cursor: 'pointer', padding: 0, fontFamily: 'inherit' },
  navPill: { width: 64, height: 32, borderRadius: 16, display: 'flex', alignItems: 'center', justifyContent: 'center', transition: 'background .2s' },
};

Object.assign(window, { MD, M3Nav, VariantAndroidA, VariantAndroidB, VariantAndroidC });
