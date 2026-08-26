/// All UI + TTS cue strings. Keys are stable; values are per language label.
const Map<String, Map<String, String>> appStrings = {
  // Navigation
  'nav_home': {
    'English': 'Home',
    'Hindi': 'होम',
    'Japanese': 'ホーム',
  },
  'nav_schedule': {
    'English': 'Schedule',
    'Hindi': 'अनुसूची',
    'Japanese': 'スケジュール',
  },
  'nav_settings': {
    'English': 'Settings',
    'Hindi': 'सेटिंग्स',
    'Japanese': '設定',
  },
  'nav_profile': {
    'English': 'Profile',
    'Hindi': 'प्रोफ़ाइल',
    'Japanese': 'プロフィール',
  },

  // Home
  'home_title': {
    'English': 'Chakra Levels',
    'Hindi': 'चक्र स्तर',
    'Japanese': 'チャクラのレベル',
  },
  'load_failed': {
    'English': 'Failed to load: {error}',
    'Hindi': 'लोड नहीं हो सका: {error}',
    'Japanese': '読み込みに失敗しました: {error}',
  },
  'no_chakras': {
    'English': 'No chakras found',
    'Hindi': 'कोई चक्र नहीं मिला',
    'Japanese': 'チャクラが見つかりません',
  },

  // Detail
  'label_element': {
    'English': 'Element',
    'Hindi': 'तत्त्व',
    'Japanese': '要素',
  },
  'label_location': {
    'English': 'Location',
    'Hindi': 'स्थान',
    'Japanese': '位置',
  },
  'label_function': {
    'English': 'Function',
    'Hindi': 'कार्य',
    'Japanese': '働き',
  },
  'label_mantra': {
    'English': 'Mantra',
    'Hindi': 'मंत्र',
    'Japanese': 'マントラ',
  },
  'label_color': {
    'English': 'Color',
    'Hindi': 'रंग',
    'Japanese': '色',
  },
  'btn_yogasana': {
    'English': 'Yogasana',
    'Hindi': 'योगासन',
    'Japanese': 'ヨガアーサナ',
  },
  'btn_meditate': {
    'English': 'Meditate',
    'Hindi': 'ध्यान',
    'Japanese': '瞑想',
  },
  'detail_hint': {
    'English': 'Open a practice from the buttons above.',
    'Hindi': 'ऊपर दिए बटन से अभ्यास शुरू करें।',
    'Japanese': '上のボタンから練習を始めましょう。',
  },

  // Color names (display only; JSON keeps English keys)
  'color_red': {
    'English': 'Red',
    'Hindi': 'लाल',
    'Japanese': '赤',
  },
  'color_orange': {
    'English': 'Orange',
    'Hindi': 'नारंगी',
    'Japanese': 'オレンジ',
  },
  'color_yellow': {
    'English': 'Yellow',
    'Hindi': 'पीला',
    'Japanese': '黄',
  },
  'color_green': {
    'English': 'Green',
    'Hindi': 'हरा',
    'Japanese': '緑',
  },
  'color_blue': {
    'English': 'Blue',
    'Hindi': 'नीला',
    'Japanese': '青',
  },
  'color_indigo': {
    'English': 'Indigo',
    'Hindi': 'नील',
    'Japanese': '藍',
  },
  'color_violet': {
    'English': 'Violet',
    'Hindi': 'बैंगनी',
    'Japanese': '紫',
  },

  // Schedule
  'schedule_title': {
    'English': 'Schedule',
    'Hindi': 'अनुसूची',
    'Japanese': 'スケジュール',
  },
  'day_streak': {
    'English': '{n} day streak',
    'Hindi': '{n} दिन की स्ट्रीक',
    'Japanese': '{n}日連続',
  },
  'schedule_mock_hint': {
    'English': 'Mock progress — wire this to storage later.',
    'Hindi': 'नकली प्रगति — बाद में स्टोरेज से जोड़ें।',
    'Japanese': '仮の進捗です。後で保存と連携できます。',
  },
  'freeze_streak': {
    'English': 'Freeze streak',
    'Hindi': 'स्ट्रीक फ्रीज',
    'Japanese': '連続記録フリーズ',
  },
  'left_count': {
    'English': '{n} left',
    'Hindi': '{n} बचे',
    'Japanese': '残り{n}',
  },
  'total_xp': {
    'English': 'Total XP',
    'Hindi': 'कुल XP',
    'Japanese': '合計XP',
  },
  'weekday_m': {'English': 'M', 'Hindi': 'सो', 'Japanese': '月'},
  'weekday_t': {'English': 'T', 'Hindi': 'मं', 'Japanese': '火'},
  'weekday_w': {'English': 'W', 'Hindi': 'बु', 'Japanese': '水'},
  'weekday_th': {'English': 'T', 'Hindi': 'गु', 'Japanese': '木'},
  'weekday_f': {'English': 'F', 'Hindi': 'शु', 'Japanese': '金'},
  'weekday_sa': {'English': 'S', 'Hindi': 'श', 'Japanese': '土'},
  'weekday_su': {'English': 'S', 'Hindi': 'र', 'Japanese': '日'},

  // Settings
  'settings_title': {
    'English': 'Settings',
    'Hindi': 'सेटिंग्स',
    'Japanese': '設定',
  },
  'notifications': {
    'English': 'Notifications',
    'Hindi': 'सूचनाएँ',
    'Japanese': '通知',
  },
  'notifications_sub': {
    'English': 'Enable reminders',
    'Hindi': 'रिमाइंडर चालू करें',
    'Japanese': 'リマインダーを有効にする',
  },
  'sound': {
    'English': 'Sound',
    'Hindi': 'ध्वनि',
    'Japanese': 'サウンド',
  },
  'sound_sub': {
    'English': 'Session sounds & TTS',
    'Hindi': 'सत्र ध्वनि और TTS',
    'Japanese': 'セッション音と読み上げ',
  },
  'language': {
    'English': 'Language',
    'Hindi': 'भाषा',
    'Japanese': '言語',
  },
  'select_language': {
    'English': 'Select language',
    'Hindi': 'भाषा चुनें',
    'Japanese': '言語を選択',
  },
  'about_title': {
    'English': 'About Dchakra',
    'Hindi': 'Dchakra के बारे में',
    'Japanese': 'Dchakraについて',
  },
  'about_sub': {
    'English': 'Chakra yoga & meditation',
    'Hindi': 'चक्र योग और ध्यान',
    'Japanese': 'チャクラのヨガと瞑想',
  },
  'about_legalese': {
    'English': 'Local practice app — no accounts.',
    'Hindi': 'स्थानीय अभ्यास ऐप — कोई खाता नहीं।',
    'Japanese': 'ローカル練習アプリ — アカウント不要。',
  },

  // Profile
  'profile_title': {
    'English': 'Profile',
    'Hindi': 'प्रोफ़ाइल',
    'Japanese': 'プロフィール',
  },
  'guest': {
    'English': 'Guest',
    'Hindi': 'अतिथि',
    'Japanese': 'ゲスト',
  },
  'no_account': {
    'English': 'No account connected',
    'Hindi': 'कोई खाता जुड़ा नहीं',
    'Japanese': 'アカウント未接続',
  },
  'streak': {
    'English': 'Streak',
    'Hindi': 'स्ट्रीक',
    'Japanese': '連続記録',
  },
  'days_count': {
    'English': '{n} days',
    'Hindi': '{n} दिन',
    'Japanese': '{n}日',
  },
  'meditations': {
    'English': 'Meditations',
    'Hindi': 'ध्यान',
    'Japanese': '瞑想',
  },
  'practice_time': {
    'English': 'Practice time',
    'Hindi': 'अभ्यास समय',
    'Japanese': '練習時間',
  },
  'hours_count': {
    'English': '{n} hrs',
    'Hindi': '{n} घंटे',
    'Japanese': '{n}時間',
  },

  // Yoga session UI
  'hold_pose': {
    'English': 'HOLD POSE',
    'Hindi': 'आसन पकड़ें',
    'Japanese': 'ポーズを保持',
  },
  'rest_chip': {
    'English': 'REST',
    'Hindi': 'आराम',
    'Japanese': '休憩',
  },

  // TTS cues (also used via t())
  'start_pose': {
    'English': '3, 2, 1, start. The next {seconds} seconds {name}.',
    'Hindi': '3, 2, 1, शुरू। अगले {seconds} सेकंड {name}।',
    'Japanese': '3、2、1、スタート。次の{seconds}秒は{name}。',
  },
  'rest': {
    'English': 'Take a rest',
    'Hindi': 'आराम करें',
    'Japanese': '休んでください',
  },
  'half_time': {
    'English': 'Half time',
    'Hindi': 'आधा समय',
    'Japanese': '半分です',
  },
  'stop': {
    'English': '3, 2, 1, stop',
    'Hindi': '3, 2, 1, रुकें',
    'Japanese': '3、2、1、ストップ',
  },
  'session_complete': {
    'English': 'Session complete. Well done.',
    'Hindi': 'सत्र पूरा हुआ। बहुत अच्छा।',
    'Japanese': 'セッション完了。よくできました。',
  },
  'meditation_complete': {
    'English': 'Meditation complete.',
    'Hindi': 'ध्यान पूरा हुआ।',
    'Japanese': '瞑想が完了しました。',
  },
};
