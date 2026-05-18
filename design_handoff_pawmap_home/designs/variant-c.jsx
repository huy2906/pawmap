// variant-c.jsx — Warm pet-companion
// Light cream base, gentle blue/green accents, pet-personality first.
// Hero: pet avatar card with next-appointment. Then services row, featured spotlight,
// nearby with maps thumbnail. Friendly, illustrative.

function VariantC() {
  const [tab, setTab] = React.useState('home');
  const [petIdx, setPetIdx] = React.useState(0);

  const pets = [
    { name: 'Milu',  type: 'Poodle · 2 tuổi',     bg: '#E8F1FB', accent: PM_BLUE,  pawColor: PM_BLUE },
    { name: 'Bông',  type: 'Mèo Anh · 1 tuổi',    bg: '#F0F8DE', accent: PM_GREEN, pawColor: PM_GREEN },
  ];
  const pet = pets[petIdx];

  const services = [
    { id: 'vet',    label: 'Phòng khám', Icon: VetIcon,       tint: '#E8F1FB' },
    { id: 'groom',  label: 'Grooming',   Icon: GroomingIcon,  tint: '#F0F8DE' },
    { id: 'hotel',  label: 'Khách sạn',  Icon: HotelIcon,     tint: '#E8F1FB' },
    { id: 'shop',   label: 'Pet Shop',   Icon: ShopIcon,      tint: '#F0F8DE' },
    { id: 'walk',   label: 'Dắt đi dạo', Icon: WalkIcon,      tint: '#E8F1FB' },
    { id: 'train',  label: 'Huấn luyện', Icon: TrainingIcon,  tint: '#F0F8DE' },
  ];

  return (
    <div style={vcStyles.frame}>
      {/* Header */}
      <div style={vcStyles.header}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={vcStyles.logoMark}>
            <PinGlyph size={26} blue={PM_BLUE} green={PM_GREEN}/>
          </div>
          <div>
            <div style={{ fontSize: 17, fontWeight: 800, color: '#0F2740', letterSpacing: -.3 }}>PawMap</div>
            <div style={{ fontSize: 10.5, color: '#5A6B7C', fontWeight: 500, marginTop: -1 }}>Bạn đồng hành của thú cưng</div>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <button style={vcStyles.iconBtn}><SearchIcon size={20} color="#0F2740"/></button>
          <button style={vcStyles.iconBtn}><BellIcon size={20} color="#0F2740" dot/></button>
        </div>
      </div>

      <div style={vcStyles.body}>
        {/* Pet hero card */}
        <div style={{ ...vcStyles.petHero, background: pet.bg }}>
          {/* paw watermark */}
          <div style={{ position: 'absolute', right: -16, bottom: -18, opacity: .15 }}>
            <PawGlyph size={160} color={pet.accent}/>
          </div>

          <div style={{ position: 'relative', zIndex: 2 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{ ...vcStyles.petAvatar, background: '#fff', boxShadow: '0 4px 12px rgba(0,0,0,.08)' }}>
                <PawGlyph size={32} color={pet.pawColor}/>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 11, color: '#5A6B7C', fontWeight: 600, letterSpacing: .4 }}>CHÀO BUỔI SÁNG, MINH 👋</div>
                <div style={{ fontSize: 20, fontWeight: 800, color: '#0F2740', letterSpacing: -.4, marginTop: 2 }}>{pet.name} đang khoẻ mạnh!</div>
                <div style={{ fontSize: 12, color: '#5A6B7C', marginTop: 1 }}>{pet.type}</div>
              </div>
            </div>

            {/* next appt */}
            <div style={vcStyles.apptCard}>
              <div style={{ ...vcStyles.apptDate, background: pet.accent }}>
                <div style={{ fontSize: 9, color: '#fff', fontWeight: 700, letterSpacing: .5 }}>THG 5</div>
                <div style={{ fontSize: 18, color: '#fff', fontWeight: 800, lineHeight: 1 }}>18</div>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 12.5, fontWeight: 700, color: '#0F2740' }}>Tiêm vắc-xin tổng hợp</div>
                <div style={{ fontSize: 11.5, color: '#5A6B7C', marginTop: 2, display: 'flex', alignItems: 'center', gap: 4 }}>
                  <ClockIcon size={11}/>9:30 · Phòng khám PetCare
                </div>
              </div>
              <ChevronRightIcon size={18} color="#9AA7B4"/>
            </div>

            {/* pet dots */}
            <div style={{ display: 'flex', gap: 6, marginTop: 12, justifyContent: 'center' }}>
              {pets.map((_, i) => (
                <button key={i} onClick={() => setPetIdx(i)} style={{ width: i === petIdx ? 18 : 6, height: 6, borderRadius: 99, background: i === petIdx ? pet.accent : 'rgba(15,39,64,.18)', border: 'none', cursor: 'pointer', transition: 'all .25s' }}/>
              ))}
            </div>
          </div>
        </div>

        {/* Services row */}
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', margin: '20px 4px 12px' }}>
          <div style={vcStyles.sectionTitle}>Dịch vụ cho {pet.name}</div>
          <div style={vcStyles.seeAll}>Tất cả</div>
        </div>

        <div style={vcStyles.servRow}>
          {services.map(s => (
            <button key={s.id} style={vcStyles.servCell}>
              <div style={{ ...vcStyles.servTile, background: s.tint }}>
                <s.Icon size={28}/>
              </div>
              <div style={vcStyles.servLabel}>{s.label}</div>
            </button>
          ))}
        </div>

        {/* Spotlight card */}
        <div style={vcStyles.spotlight}>
          <div style={vcStyles.spotMap}>
            <MiniMap/>
            <div style={vcStyles.spotPin}><PinGlyph size={32} blue={PM_BLUE} green={PM_GREEN}/></div>
            <div style={vcStyles.spotBadge}>3 nơi gần bạn</div>
          </div>
          <div style={{ padding: '14px 14px 12px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <div style={{ width: 6, height: 6, borderRadius: 99, background: PM_GREEN }}/>
              <div style={{ fontSize: 11, fontWeight: 700, color: PM_GREEN_DEEP, letterSpacing: .5 }}>ĐANG MỞ CỬA</div>
            </div>
            <div style={{ fontSize: 16, fontWeight: 800, color: '#0F2740', marginTop: 6, letterSpacing: -.2 }}>Phòng khám PetCare</div>
            <div style={{ fontSize: 12, color: '#5A6B7C', marginTop: 2 }}>2 Nguyễn Huệ, Quận 1 · Cách bạn 2.5 km</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 10 }}>
              <div style={vcStyles.tag}><StarIcon size={11}/><span>4.8 · 124 đánh giá</span></div>
              <div style={vcStyles.tag}><LocationDotIcon size={11} color={PM_BLUE}/><span>2.5 km</span></div>
            </div>
            <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
              <button style={vcStyles.primaryBtn}>Đặt lịch khám</button>
              <button style={vcStyles.ghostBtn}>Chỉ đường</button>
            </div>
          </div>
        </div>

        {/* Community strip */}
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', margin: '22px 4px 12px' }}>
          <div style={vcStyles.sectionTitle}>Cộng đồng yêu thú cưng</div>
        </div>
        <div style={vcStyles.commCard}>
          <div style={{ display: 'flex', marginRight: 12 }}>
            {[PM_BLUE, PM_GREEN, '#F5A623'].map((c, i) => (
              <div key={i} style={{ ...vcStyles.commAv, background: c, marginLeft: i ? -10 : 0, zIndex: 3 - i }}>
                <PawGlyph size={14} color="#fff"/>
              </div>
            ))}
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: '#0F2740' }}>2,840 chủ nuôi quanh bạn</div>
            <div style={{ fontSize: 11.5, color: '#5A6B7C', marginTop: 1 }}>Hỏi đáp, chia sẻ kinh nghiệm</div>
          </div>
          <ChevronRightIcon size={18} color="#9AA7B4"/>
        </div>
        <div style={{ height: 12 }}/>
      </div>

      <BottomNav active={tab} onChange={setTab}/>
    </div>
  );
}

function MiniMap() {
  return (
    <svg width="100%" height="100%" viewBox="0 0 360 120" preserveAspectRatio="xMidYMid slice" style={{ position: 'absolute', inset: 0 }}>
      <rect width="360" height="120" fill="#EAF1F7"/>
      <ellipse cx="60" cy="40" rx="36" ry="24" fill="#D8EBB1"/>
      <ellipse cx="300" cy="80" rx="40" ry="22" fill="#D8EBB1"/>
      <path d="M0 60 L360 55" stroke="#fff" strokeWidth="10"/>
      <path d="M180 0 L185 120" stroke="#fff" strokeWidth="8"/>
      <path d="M0 90 Q90 80 180 90 T 360 88" stroke="#fff" strokeWidth="6" fill="none"/>
    </svg>
  );
}

const vcStyles = {
  frame: { width: '100%', height: '100%', background: '#FBF9F4', display: 'flex', flexDirection: 'column', fontFamily: 'Inter, -apple-system, system-ui, sans-serif', position: 'relative' },
  header: { padding: '58px 18px 12px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: '#FBF9F4' },
  logoMark: { width: 40, height: 40, borderRadius: 12, background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 3px 8px rgba(15,39,64,.08)' },
  iconBtn: { width: 40, height: 40, borderRadius: 12, background: '#fff', border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', boxShadow: '0 3px 8px rgba(15,39,64,.08)' },
  body: { flex: 1, overflow: 'auto', padding: '4px 16px 4px' },
  petHero: { borderRadius: 24, padding: 16, position: 'relative', overflow: 'hidden', boxShadow: '0 4px 16px rgba(15,39,64,.06)' },
  petAvatar: { width: 56, height: 56, borderRadius: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', flex: '0 0 auto' },
  apptCard: { marginTop: 14, background: 'rgba(255,255,255,.85)', backdropFilter: 'blur(8px)', borderRadius: 14, padding: 10, display: 'flex', alignItems: 'center', gap: 10, border: '1px solid rgba(15,39,64,.06)' },
  apptDate: { width: 44, height: 44, borderRadius: 12, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 1 },
  sectionTitle: { fontSize: 15, fontWeight: 800, color: '#0F2740', letterSpacing: -.2 },
  seeAll: { fontSize: 12, fontWeight: 700, color: PM_BLUE, cursor: 'pointer' },
  servRow: { display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 6, scrollbarWidth: 'none' },
  servCell: { display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8, background: 'transparent', border: 'none', cursor: 'pointer', flex: '0 0 auto', minWidth: 64 },
  servTile: { width: 62, height: 62, borderRadius: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 2px 6px rgba(15,39,64,.05)' },
  servLabel: { fontSize: 11.5, fontWeight: 600, color: '#0F2740', textAlign: 'center' },

  spotlight: { marginTop: 18, background: '#fff', borderRadius: 22, overflow: 'hidden', boxShadow: '0 4px 16px rgba(15,39,64,.06)' },
  spotMap: { position: 'relative', height: 120, overflow: 'hidden' },
  spotPin: { position: 'absolute', left: '50%', top: '50%', transform: 'translate(-50%,-100%)', filter: 'drop-shadow(0 4px 6px rgba(0,0,0,.18))' },
  spotBadge: { position: 'absolute', top: 10, left: 12, background: '#fff', padding: '4px 10px', borderRadius: 999, fontSize: 11, fontWeight: 700, color: '#0F2740', boxShadow: '0 2px 6px rgba(0,0,0,.08)' },
  tag: { display: 'flex', alignItems: 'center', gap: 4, fontSize: 11.5, fontWeight: 600, color: '#0F2740', background: '#F2F5F8', padding: '4px 9px', borderRadius: 999 },
  primaryBtn: { flex: 1, height: 40, borderRadius: 12, background: PM_BLUE, color: '#fff', border: 'none', fontSize: 13, fontWeight: 700, cursor: 'pointer', boxShadow: '0 4px 10px rgba(27,111,181,.25)' },
  ghostBtn: { flex: 1, height: 40, borderRadius: 12, background: '#fff', color: PM_BLUE, border: `1.5px solid ${PM_BLUE}`, fontSize: 13, fontWeight: 700, cursor: 'pointer' },

  commCard: { display: 'flex', alignItems: 'center', padding: 12, background: '#fff', borderRadius: 16, boxShadow: '0 2px 8px rgba(15,39,64,.05)' },
  commAv: { width: 30, height: 30, borderRadius: 99, display: 'flex', alignItems: 'center', justifyContent: 'center', border: '2px solid #fff' },
};

window.VariantC = VariantC;
window.MiniMap = MiniMap;
window.vcStyles = vcStyles;
