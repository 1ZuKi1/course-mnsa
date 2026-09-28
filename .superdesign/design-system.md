# Design System — "Warm Paper" (Хичээлийн үнэлгээ)

Product: internal course-review site for ~50 Mongolian students at Peking University. Users browse a grid of courses, open a course to read reviews, and submit a review (3 score sliders + optional details). UI text mixes Mongolian Cyrillic and Chinese. Used often on phones, often late at night while choosing courses.

Goal: calm, low-glare, highly legible, WCAG 2.2 AA (aim AAA for body text). Nothing pure white, nothing pure black, no saturated neon accents, no decorative gradients or glows.

## Color tokens (all text pairs verified ≥4.5:1)
| Token | Value | Use |
|---|---|---|
| --bg | #f5f1ea | page background (warm paper) |
| --surface | #fbf9f5 | cards, modals, nav |
| --surface-sunken | #efe9df | input wells, info blocks, hover rows |
| --text | #2a2723 | primary text (13.2:1) |
| --text-secondary | #5c554c | meta, descriptions (6.5:1) |
| --text-muted | #6f675c | hints, placeholders (≥4.9:1 — never lighter) |
| --border | #e2dbcf | card/divider hairlines (decorative) |
| --border-control | #8a7f6f | input/select/checkbox borders (3.7:1 non-text) |
| --accent | #2f6f6a | deep muted teal — primary buttons, links, focus, active slider (white text 5.8:1) |
| --accent-hover | #255954 | |
| --accent-soft | #e3eeeb | selected/soft fills |
| --accent-ink | #1f4f4b | text on accent-soft (7.8:1) |
| --good / --good-soft | #356b40 / #e6efe3 | positive verdicts, "reviewed" |
| --mid / --mid-soft | #7a5717 / #f5ead3 | neutral verdicts |
| --bad / --bad-soft | #9a3f35 / #f6e3de | negative verdicts, delete |
| --star | #9c6a14 | rating star (muted amber) |
| --focus | 0 0 0 3px #fbf9f5, 0 0 0 5px #2f6f6a | visible focus ring on every interactive element |

Verdict chips must never rely on color alone: each carries an icon or symbol (▲ good / ● mid / ▼ bad) plus text.

## Typography
- One family: **Inter** (400/500/600/700) with system CJK fallback ("PingFang SC", "Noto Sans SC", "Microsoft YaHei"). No Montserrat, no display/serif fonts.
- Base body 16px, line-height 1.65. Minimum text size anywhere: 14px (chips/tags 14px/500).
- Scale: page title 32px/700 (mobile 26px), modal title 24px/700, card title 18px/600, section heading 18px/600, body 16px, meta 15px, small 14px.
- Letter-spacing normal (no tight negative tracking). Max line length ~70ch in reading areas (reviews, comments).

## Spacing, shape, elevation
- 4px grid; card padding 20–24px; grid gap 20px; section gaps 32–40px.
- Radius: controls 10px, cards 14px, modals 18px, chips 8px (not full pills — pills only for the search field).
- Elevation: borders do most of the work. Shadow only on hover/modal: 0 1px 2px rgba(60,45,30,.06), modal 0 20px 40px -16px rgba(60,45,30,.22). Overlay scrim rgba(42,39,35,.45).
- Motion: 150–200ms ease, no translateY bounce on cards (use border/background shift); respect prefers-reduced-motion.

## Components
- **Buttons**: min height 44px (touch target), radius 10px, 16px/600. Primary = teal fill, white text. Secondary = surface + 1px border-control. Ghost = text only with underline-on-hover. Danger ghost = --bad text.
- **Inputs/selects/textarea**: 44px min height, 16px text (prevents iOS zoom), background --surface, 1px --border-control, radius 10px, visible label ABOVE field (never placeholder-only), helper text 14px --text-muted below, focus = --focus ring.
- **Score input**: 0–10 as a segmented row of 11 tappable buttons (or a slider with large 24px thumb + visible numeric value and endpoint labels on both ends). Selected value in teal.
- **Toggle switch**: 44px hit area, clear "Байгаа / Байхгүй" text state next to it, not color-only.
- **Course card**: surface, 1px border, radius 14px. Title 18px/600, meta 15px secondary, rating row (star + score bold + count), footer with category chip + reviewed chip. Whole card is a button/link with focus ring; hover = border-color accent + surface-sunken tint.
- **Review card**: author + term + date header, verdict chips row, key-value details as a 2-column definition list on sunken background, comment as readable 16px paragraph (no italic, no icon bubble), actions right-aligned.
- **Modal**: max-width 720px (course) / 440px (login, add course), sticky header with title + close (44px, labelled "Хаах"), scrollable body, on mobile becomes full-height bottom sheet.
- **Nav**: solid --surface, 1px bottom border, 64px, brand mark = teal rounded square with book icon.

## Accessibility rules
- Contrast AA minimum, aim AAA for body. Never gray-on-gray below 4.5:1.
- All interactive targets ≥44×44px, visible focus, logical tab order, aria-labels for icon buttons.
- No information by color alone. Support prefers-reduced-motion.
