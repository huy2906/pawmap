// icons.jsx — PawMap icon set
// Two-tone, flat silhouette style picked up from the logo.
// Blue = primary structure, Green = signal/accent.
// All icons render in a 24×24 viewBox by default, tinted via currentColor + accent prop.

const PM_BLUE = '#1B6FB5';
const PM_BLUE_DEEP = '#155488';
const PM_GREEN = '#8DC63F';
const PM_GREEN_DEEP = '#6FA82C';

// ─── primitive: paw print (the brand mark) ───────────────────
function PawGlyph({ size = 24, color = PM_GREEN, accent }) {
  const c = accent || color;
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <ellipse cx="6.2" cy="9.5" rx="2.1" ry="2.7" fill={c}/>
      <ellipse cx="17.8" cy="9.5" rx="2.1" ry="2.7" fill={c}/>
      <ellipse cx="9.5" cy="5.5" rx="1.7" ry="2.3" fill={c}/>
      <ellipse cx="14.5" cy="5.5" rx="1.7" ry="2.3" fill={c}/>
      <path d="M12 11.5c-3.2 0-5.6 2.3-5.6 4.9 0 2 1.6 3.4 3.5 3.4 1 0 1.4-.4 2.1-.4s1.1.4 2.1.4c1.9 0 3.5-1.4 3.5-3.4 0-2.6-2.4-4.9-5.6-4.9Z" fill={c}/>
    </svg>
  );
}

// ─── primitive: location pin (logo motif) ────────────────────
function PinGlyph({ size = 24, blue = PM_BLUE, green = PM_GREEN }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M12 2c-4.4 0-8 3.5-8 7.9 0 5.4 6.6 11.3 7.4 12 .3.3.9.3 1.2 0 .8-.7 7.4-6.6 7.4-12C20 5.5 16.4 2 12 2Z" fill={blue}/>
      <circle cx="12" cy="9.7" r="4.5" fill="#fff"/>
      <g transform="translate(7.5 5.2) scale(0.375)">
        <ellipse cx="6.2" cy="9.5" rx="2.1" ry="2.7" fill={green}/>
        <ellipse cx="17.8" cy="9.5" rx="2.1" ry="2.7" fill={green}/>
        <ellipse cx="9.5" cy="5.5" rx="1.7" ry="2.3" fill={green}/>
        <ellipse cx="14.5" cy="5.5" rx="1.7" ry="2.3" fill={green}/>
        <path d="M12 11.5c-3.2 0-5.6 2.3-5.6 4.9 0 2 1.6 3.4 3.5 3.4 1 0 1.4-.4 2.1-.4s1.1.4 2.1.4c1.9 0 3.5-1.4 3.5-3.4 0-2.6-2.4-4.9-5.6-4.9Z" fill={green}/>
      </g>
    </svg>
  );
}

// ─── Category icons ─────────────────────────────────────────
// All sized 28 inside a 56×56 tile. Two-tone silhouettes.

function VetIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {/* cross plaque */}
      <rect x="4" y="4" width="24" height="24" rx="7" fill={PM_BLUE}/>
      <path d="M14 9h4v5h5v4h-5v5h-4v-5H9v-4h5V9Z" fill="#fff"/>
      {/* paw stamp */}
      <circle cx="24" cy="24" r="5" fill={PM_GREEN}/>
      <ellipse cx="22.2" cy="23.2" rx=".7" ry=".9" fill="#fff"/>
      <ellipse cx="25.8" cy="23.2" rx=".7" ry=".9" fill="#fff"/>
      <ellipse cx="23" cy="21.5" rx=".55" ry=".75" fill="#fff"/>
      <ellipse cx="25" cy="21.5" rx=".55" ry=".75" fill="#fff"/>
      <path d="M24 23.5c-1.1 0-1.9.8-1.9 1.7 0 .7.5 1.2 1.2 1.2.3 0 .5-.1.7-.1s.4.1.7.1c.7 0 1.2-.5 1.2-1.2 0-.9-.8-1.7-1.9-1.7Z" fill="#fff"/>
    </svg>
  );
}

function GroomingIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {/* scissors */}
      <circle cx="9" cy="22" r="4" stroke={PM_BLUE} strokeWidth="2.2" fill="none"/>
      <circle cx="23" cy="22" r="4" stroke={PM_BLUE} strokeWidth="2.2" fill="none"/>
      <path d="M11.5 19.2 22 7M20.5 19.2 10 7" stroke={PM_BLUE} strokeWidth="2.2" strokeLinecap="round"/>
      {/* bow */}
      <circle cx="16" cy="13" r="2" fill={PM_GREEN}/>
    </svg>
  );
}

function HotelIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {/* house */}
      <path d="M16 4 4 13v15h24V13L16 4Z" fill={PM_BLUE}/>
      <path d="M4 13 16 4l12 9" stroke={PM_BLUE_DEEP} strokeWidth="1.5" strokeLinejoin="round" fill="none"/>
      {/* door cutout w/ paw */}
      <rect x="11" y="16" width="10" height="12" rx="2" fill="#fff"/>
      <g transform="translate(11 16) scale(0.42)">
        <ellipse cx="6.2" cy="11" rx="1.9" ry="2.4" fill={PM_GREEN}/>
        <ellipse cx="17.8" cy="11" rx="1.9" ry="2.4" fill={PM_GREEN}/>
        <ellipse cx="9.5" cy="7" rx="1.5" ry="2" fill={PM_GREEN}/>
        <ellipse cx="14.5" cy="7" rx="1.5" ry="2" fill={PM_GREEN}/>
        <path d="M12 13c-3 0-5.2 2.1-5.2 4.5 0 1.8 1.5 3.2 3.3 3.2.9 0 1.3-.4 1.9-.4s1 .4 1.9.4c1.8 0 3.3-1.4 3.3-3.2 0-2.4-2.2-4.5-5.2-4.5Z" fill={PM_GREEN}/>
      </g>
    </svg>
  );
}

function ShopIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {/* bag */}
      <path d="M8 11h16l-1.4 16.2A2 2 0 0 1 20.6 29H11.4a2 2 0 0 1-2-1.8L8 11Z" fill={PM_BLUE}/>
      <path d="M12 12V9a4 4 0 0 1 8 0v3" stroke={PM_BLUE} strokeWidth="2.2" strokeLinecap="round" fill="none"/>
      {/* bone tag */}
      <g transform="translate(11 16)">
        <rect x="0" y="0" width="10" height="6" rx="3" fill={PM_GREEN}/>
        <circle cx="1.6" cy="1.4" r="1.4" fill={PM_GREEN}/>
        <circle cx="1.6" cy="4.6" r="1.4" fill={PM_GREEN}/>
        <circle cx="8.4" cy="1.4" r="1.4" fill={PM_GREEN}/>
        <circle cx="8.4" cy="4.6" r="1.4" fill={PM_GREEN}/>
      </g>
    </svg>
  );
}

function EmergencyIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      <circle cx="16" cy="16" r="12" fill="#E94545"/>
      <path d="M16 8v9M16 21v2.5" stroke="#fff" strokeWidth="2.6" strokeLinecap="round"/>
    </svg>
  );
}

function WalkIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      <path d="M9 26c2-5 4-7 7-7s5 2 7 7" stroke={PM_BLUE} strokeWidth="2.4" strokeLinecap="round" fill="none"/>
      <circle cx="9" cy="14" r="3" fill={PM_BLUE}/>
      <circle cx="22" cy="11" r="3.5" fill={PM_GREEN}/>
      <circle cx="20.5" cy="9.5" r=".7" fill="#fff"/>
      <circle cx="23.5" cy="9.5" r=".7" fill="#fff"/>
    </svg>
  );
}

function TrainingIcon({ size = 28 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {/* whistle / award medal */}
      <circle cx="16" cy="19" r="8" fill={PM_BLUE}/>
      <circle cx="16" cy="19" r="4" fill="#fff"/>
      <path d="M11 5l5 7M21 5l-5 7" stroke={PM_GREEN} strokeWidth="2.4" strokeLinecap="round"/>
    </svg>
  );
}

// ─── UI line icons (used by nav, search, chevrons) ──────────
function HomeLineIcon({ size = 24, color = 'currentColor', filled = false }) {
  if (filled) return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M3.5 11 12 4l8.5 7v9a1.5 1.5 0 0 1-1.5 1.5h-3.5v-6h-7v6H5A1.5 1.5 0 0 1 3.5 20v-9Z" fill={color}/>
    </svg>
  );
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M3.5 11 12 4l8.5 7v9a1.5 1.5 0 0 1-1.5 1.5h-3.5v-6h-7v6H5A1.5 1.5 0 0 1 3.5 20v-9Z" stroke={color} strokeWidth="1.8" strokeLinejoin="round" fill="none"/>
    </svg>
  );
}

function MapLineIcon({ size = 24, color = 'currentColor', filled = false }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M9 4 3.5 5.8a1 1 0 0 0-.7 1V19a1 1 0 0 0 1.3 1L9 18l6 2 5.2-1.8a1 1 0 0 0 .7-1V5a1 1 0 0 0-1.3-1L15 6 9 4Z"
        stroke={color} strokeWidth="1.8" strokeLinejoin="round" fill={filled ? color : 'none'}/>
      <path d="M9 4v14M15 6v14" stroke={color} strokeWidth="1.8" fill="none"/>
    </svg>
  );
}

function CalendarLineIcon({ size = 24, color = 'currentColor', filled = false }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="3.5" y="5" width="17" height="15.5" rx="2.5" stroke={color} strokeWidth="1.8" fill={filled ? color : 'none'}/>
      <path d="M3.5 10h17" stroke={color} strokeWidth="1.8"/>
      <path d="M8 3v4M16 3v4" stroke={color} strokeWidth="1.8" strokeLinecap="round"/>
      {filled && <circle cx="12" cy="15" r="1.6" fill="#fff"/>}
    </svg>
  );
}

function ProfileLineIcon({ size = 24, color = 'currentColor', filled = false }) {
  if (filled) return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="8.5" r="4" fill={color}/>
      <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7v.5H4V20Z" fill={color}/>
    </svg>
  );
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="8.5" r="4" stroke={color} strokeWidth="1.8" fill="none"/>
      <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke={color} strokeWidth="1.8" strokeLinecap="round" fill="none"/>
    </svg>
  );
}

function SearchIcon({ size = 20, color = 'currentColor' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="11" cy="11" r="6.5" stroke={color} strokeWidth="2" fill="none"/>
      <path d="m16 16 4 4" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  );
}

function BellIcon({ size = 22, color = 'currentColor', dot = false }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M6 18V11a6 6 0 0 1 12 0v7l1.5 2h-15L6 18Z" stroke={color} strokeWidth="1.8" strokeLinejoin="round" fill="none"/>
      <path d="M10 22a2 2 0 0 0 4 0" stroke={color} strokeWidth="1.8" strokeLinecap="round"/>
      {dot && <circle cx="17" cy="6.5" r="3" fill={PM_GREEN} stroke="#fff" strokeWidth="1.5"/>}
    </svg>
  );
}

function ChevronRightIcon({ size = 18, color = 'currentColor' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="m9 6 6 6-6 6" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    </svg>
  );
}

function StarIcon({ size = 14, color = '#F5A623' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24">
      <path d="m12 2 3 6.6 7 .8-5.2 4.8 1.5 7L12 17.8 5.7 21.2l1.5-7L2 9.4l7-.8L12 2Z" fill={color}/>
    </svg>
  );
}

function LocationDotIcon({ size = 14, color = PM_BLUE }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M12 2c-4 0-7 3.1-7 7 0 5 7 13 7 13s7-8 7-13c0-3.9-3-7-7-7Z" fill={color}/>
      <circle cx="12" cy="9" r="2.5" fill="#fff"/>
    </svg>
  );
}

function ClockIcon({ size = 14, color = '#5A6B7C' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="12" r="9" stroke={color} strokeWidth="1.8" fill="none"/>
      <path d="M12 7v5l3 2" stroke={color} strokeWidth="1.8" strokeLinecap="round"/>
    </svg>
  );
}

Object.assign(window, {
  PM_BLUE, PM_BLUE_DEEP, PM_GREEN, PM_GREEN_DEEP,
  PawGlyph, PinGlyph,
  VetIcon, GroomingIcon, HotelIcon, ShopIcon, EmergencyIcon, WalkIcon, TrainingIcon,
  HomeLineIcon, MapLineIcon, CalendarLineIcon, ProfileLineIcon,
  SearchIcon, BellIcon, ChevronRightIcon, StarIcon, LocationDotIcon, ClockIcon,
});
