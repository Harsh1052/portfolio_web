# Portfolio v2 (Beta) — "The City of Code"

> **Status: BETA READY** — Phases 0–4 shipped.
> Built: journey engine + primitives · The City Gate · Harvest Valley ·
> The Exchange · sky stitching · QA (reduced motion, keyboard, semantics).
> Next: Phase 5+ districts (Foundation Square → The Harbor) + passport finale.
>
> **Launch checklist:** `flutter test` (5 suites) → `flutter analyze` →
> `flutter run -d chrome` manual pass (scroll both directions, motion toggle,
> keyboard nav, mobile size, stamps) → merge to master (CI deploys rules +
> hosting) → verify `/#/beta` live → watch `v2_*` dwell + stamp events in
> `/#/analytics`.

A scroll-driven, story-based portfolio inspired by [Wonderous](https://wonderous.app/web/)
(gskinner's Flutter showcase). The visitor doesn't read a resume — they **visit a city**,
and every district is a chapter of Harsh's career. v1 stays live; v2 grows at `/beta`.

---

## 1. The Story

> *"Every engineer builds a city no one sees — one project, one lesson, one late night
> at a time. Welcome to mine. Eight districts, eight chapters. Start at the gate,
> and scroll your way through."*

The journey is **chronological** — the city literally grows richer as you scroll,
mirroring the career. Each district has: a unique visual identity, a scroll-choreographed
scene, a short narrative panel (first person, same voice as the v1 About story), 2–3
proof-points from the resume, and one hidden **city stamp** (collectible).

| # | District | Chapter (from resume) | Visual identity | Signature moment |
|---|----------|----------------------|-----------------|------------------|
| 1 | **The City Gate** | Welcome — name, title, "5+ yrs, 15+ apps, 75K users" | Monumental gate, layered skyline silhouette, time-of-day sky (reuses v1 Ambience engine) | Gates swing open as you scroll; name carved into the arch |
| 2 | **Foundation Square** | 2017–2021 · GTU Computer Engineering + internship @ Across the Glob | Construction site: blueprint grid, cranes, scaffolding, dawn light | Blueprint lines draw themselves into the city map |
| 3 | **Craftsman's Lane** | 2021–2022 · Tagline Infotech — 10+ apps, custom animations, offline-first (SQLite/Hive) | Artisan workshop street: warm lanterns, gears, neon shop signs | Shop signs flicker on one by one; a gear train spins with scroll |
| 4 | **Enterprise Heights** | 2023–2024 · Elision Infotech — 8+ enterprise apps, 50K users, payments, −60% crashes, led 3 devs | Downtown glass towers, elevators, night grid of lit windows | Tower windows light up to form "50K"; crash-rate graph falls as you scroll |
| 5 | **Harvest Valley** | 2024–2026 · FarmSetu — sole engineer, 15K farmers, CI/CD 4h→1-click, SetuBooks | Golden wheat fields, sunrise, monsoon clouds, dirt road | The farmer story told in 3 scroll panels; rain falls during the "field visit" beat (reuses v1 weather overlay tech) |
| 6 | **The Exchange** | 2026–now · Kotak Securities — real-time trading, WebSockets, BLoC, GetIt | Candlestick-chart skyline, neon green/red pulses, ticker tape, night | A live (simulated) price stream flows through the scene; skyline IS a chart |
| 7 | **Tinkerers' Park** | Side quests — Trovo, this portfolio (analytics/ambience/bug game), Medium writing, learning Python | Playground/fairground: ferris wheel, string lights, workshop tents | Mini bug from v1's bug game crawls through; ferris wheel = tech-stack icons |
| 8 | **The Harbor** | Contact & departure — "no visitor leaves without a connection" | Docks at dusk, lighthouse, paper boats, visitor map projected on water | Paper boat sails off with your "message"; resume = boarding pass download |

**Collectible mechanic:** one stamp hidden per district (subtle interactive object).
Collect all 8 → passport completion animation + a personal thank-you card easter egg.
Every stamp find fires an analytics event — you'll literally measure engagement depth.

**Beta scope (first public drop):** Gate (#1) + Harvest Valley (#5) + The Exchange (#6),
with a charming "under construction 🏗️" sign for the rest. These two districts are the
strongest chapters (flagship story + current fintech role) and prove the full pattern.

---

## 2. UX Flow

1. **Arrival** — `/beta` loads the Gate full-screen. Name, title, three headline stats.
   Animated sky matches visitor's local time (Ambience engine). A pulsing
   "scroll to enter the city" hint with mouse-wheel / swipe iconography.
2. **The journey** — one continuous vertical scroll. Sky gradient interpolates across
   the entire journey (dawn at Foundation Square → night at The Exchange → dusk at
   the Harbor), stitching districts into one world.
3. **Navigation rail** — a minimal "city map" dot rail (right edge desktop / bottom
   mobile): current district highlighted, tap = smooth-scroll to district. Also serves
   as progress indicator.
4. **Story panels** — each district reveals its narrative in 2–3 beats as the scene
   plays; text is choreographed, never a wall.
5. **Exit ramps** — persistent subtle header: "← classic site" (v1) + resume download.
   The Harbor ends with contact actions.
6. **v1 → v2 bridge** — small animated banner on v1: "🏗️ A new city is being built — visit the beta".

**Accessibility / motion:** a reduced-motion toggle (and `prefers-reduced-motion`
respect) swaps choreography for gentle fades; all narrative content readable without
animation. Semantics labels on every interactive object.

---

## 3. Visual Design System

- **Palette:** each district owns a 3-color scheme derived from one shared base ramp so
  transitions blend (e.g. Valley `#F59E0B/#84CC16/#FEF3C7`, Exchange `#10B981/#EF4444/#0B1220`).
  Sky ramp is global and time-of-day aware.
- **Typography:** keep Space Grotesk (display) + Inter (body) from v1 for brand
  continuity; add one decorative weight for district titles.
- **Motion language:** everything scroll-driven (scrub, not autoplay) — the visitor is
  the director. Standard curve set (`easeOutCubic` reveals, `easeInOutSine` parallax),
  120–400ms micro-interactions, long choreographies mapped to scroll distance not time.
- **Art pipeline (validated against Wonderous's actual assets):** each wonder in
  Wonderous is only **3–5 flat-shape illustration PNGs** (hero + 1–2 foreground
  pieces + sun) over a code-painted background with a tiled grain texture. Our pipeline
  reproduces exactly that:
  1. **Claude-drawn hero illustrations** — flat-shape SVG art in the Wonderous shape
     language (organic blob foliage, limited palette, architectural detail), authored
     per district, iterated via PNG previews. Proven with `valley_hero_textured.png`.
  2. **Rasterize + grain script** — `cairosvg` renders @1x/2x/3x, Python applies
     Wonderous-style speckle grain clipped to alpha, exports WebP. Lives in `scripts/`.
  3. **Procedural grain + textures** — our own `speckles.png` equivalent generated
     procedurally, tinted and tiled in code (their `IllustrationTexture` technique).
  4. **Code-drawn dynamics** — particles, rain, tickers, counters as CustomPainters.

---

## 4. Technical Architecture

```
lib/features/v2/
├── core/
│   ├── journey_scroll_engine.dart   # maps global offset → per-district progress 0..1
│   ├── district.dart                # contract: id, palette, height, builder(progress)
│   ├── sky_gradient.dart            # global scroll-interpolated sky
│   ├── motion_tokens.dart           # curves, durations, reduced-motion switch
│   └── stamps_controller.dart       # collectible state (localStorage) + analytics
├── districts/
│   ├── gate/       gate_district.dart, gate_skyline_painter.dart, ...
│   ├── valley/     valley_district.dart, wheat_parallax_painter.dart, ...
│   └── exchange/   exchange_district.dart, candlestick_skyline_painter.dart, ticker_stream.dart
├── widgets/
│   ├── story_panel.dart             # choreographed narrative beats
│   ├── city_map_rail.dart           # dot navigation + progress
│   ├── stat_counter.dart            # scroll-triggered animated numbers
│   ├── stamp.dart                   # hidden collectible + found animation
│   └── under_construction.dart      # placeholder for unbuilt districts
└── pages/
    └── city_page.dart               # /beta — CustomScrollView of district slivers
```

**Key decisions**

- **Deferred loading:** `/beta` is imported with `deferred as` so v1 visitors download
  zero v2 code. District image assets precache as the visitor approaches (one district ahead).
- **Scroll engine:** single `ScrollController`; each district declares its scroll length
  (e.g. 2.5 × viewport); engine emits normalized local progress that districts consume —
  no district ever touches raw offsets. This is the contract that keeps 8 districts sane.
- **Performance budget:** 60fps desktop / ≥30fps mid-range mobile. Rules:
  `RepaintBoundary` per parallax layer, painters repaint only on progress change,
  particle counts halve below 700px width, no `Opacity` widgets in scroll path
  (use color alpha), DevTools timeline check before each district ships.
- **Responsive:** same scenes both form factors; mobile gets fewer layers/particles,
  larger hit targets, bottom rail. Breakpoints reuse v1 `responsive_layout.dart`.
- **State:** GetX (consistency with v1). Ambience + Analytics services are shared —
  v2 districts are wrapped in `TrackedSection`s, so district dwell time flows into the
  existing `/analytics` dashboard automatically. New events: `v2_stamp_found`,
  `v2_district_complete`, `v2_journey_complete`.
- **Reference:** Wonderous is open source (github.com/gskinner/flutter-wonderous-app) —
  study their scroll choreography and performance patterns; borrow techniques, not visuals.

**Wonderous mechanics adopted (from source dissection of the local copy)**

1. **`scrollPos` as a `ValueNotifier<double>`** — one ScrollController listener writes
   the notifier; scattered `ValueListenableBuilder`s derive opacity/translate per
   element. Targeted rebuilds, zero setState in the scroll path (editorial_screen.dart).
2. **Content scrolls OVER the art** — the illustration sits underneath in a Stack; the
   CustomScrollView's first sliver is an invisible spacer the height of the scene, so
   scrolling reveals content sliding over it while the scene fades out
   (`opacity = 1 − scrollPos/700`) and the title parallaxes at 0.3× scroll speed.
3. **Pinned collapsing `SliverAppBar`** per district for the section header.
4. **`AnimatedListItem` / `ScalingListItem`** — computes a widget's global position vs
   viewport each scroll tick → `pctVisible` 0..1 → scale 1.35→1 / fade as items enter.
   Their scroll-into-view effect, no extra packages. Port as `v2/widgets/`.
5. **`IllustrationPiece` contract** — declarative scene pieces with `heightFactor` +
   `minHeight` (responsive sizing), `fractionalOffset`, entrance animation
   (`initialOffset`/`initialScale` driven by a shared `Animation`), `zoomAmt` for
   gesture-linked depth, `dynamicHzOffset` (wide-screen parallax), optional `Hero` tag.
   Port nearly verbatim as `ScenePiece`.
6. **bg/mg/fg builder trio** (`WonderIllustrationBuilder` + config toggles) — one scene
   widget usable full, or single-layer for transitions. Port as `SceneBuilder`.
7. **Scroll-driven depth zoom** — Wonderous maps vertical swipe → `config.zoom`; each
   piece multiplies `zoomAmt × zoom` (fg ≈ .25–.4, mg ≈ .05) so layers separate with
   depth. We map district-local scroll progress to the same `zoom` input.
8. **Texture layer** — `FadeColorTransition` solid color + tiled tinted grain texture
   (`ImageRepeat.repeat`, `color:` tint) = the painterly background. Port as-is.
9. **`AnimatedClouds`** — seed-randomized cloud placement per scene, animating in/out
   on scene change. Adapt with our ambience tint.
10. **Global `disableAnimations` switch** — maps to our reduced-motion toggle.
11. **Dependency:** add `flutter_animate` (they lean on it for entrance choreography).

---

## 5. Roadmap (daily-commit sized)

**Phase 0 — Foundations (~6 commits)**
1. `/beta` deferred route + `city_page` shell + district contract
2. Journey scroll engine (scrollPos notifier + local progress) + unit tests
3. Port Wonderous primitives: `ScenePiece`, `SceneBuilder`, `IllustrationTexture`,
   `AnimatedListItem`/`ScalingListItem` (+ `flutter_animate` dep)
4. Grain/texture generator script + rasterize pipeline in `scripts/`
5. Motion tokens, sky gradient, reduced-motion switch
6. City-map rail + under-construction placeholder + v1 beta banner

**Phase 1 — The City Gate (~5 commits)**
5. Layered skyline CustomPainter (procedural, ambience-tinted)
6. Gate geometry + scroll-driven opening choreography
7. Name/title/stats typography reveal + scroll hint
8. Gate particles + polish pass
9. Mobile tuning + perf pass (timeline capture)

**Phase 2 — Harvest Valley (~6 commits)**
10. Wheat-field parallax painter (3 depth layers) + AI backdrop
11. Story panel system + Valley narrative (3 beats, incl. farmer story)
12. Stat counters (15K farmers, 4h→1-click) scroll-triggered
13. Monsoon beat — rain overlay tied to story moment
14. Stamp #1 + analytics events
15. Mobile + perf pass

**Phase 3 — The Exchange (~6 commits)**
16. Candlestick skyline painter + night palette
17. Simulated market stream (broadcast Stream, Kotak-safe fake data) + ticker tape
18. Exchange narrative panels (fintech chapter)
19. Green/red pulse choreography + skyline-as-chart moment
20. Stamp #2 + analytics events
21. Mobile + perf pass

**Phase 4 — Beta launch (~3 commits)**
22. Journey-wide sky stitching + district transitions
23. QA sweep: reduced motion, semantics, 3 device sizes, Lighthouse
24. Deploy behind `/beta`, announce banner on v1

**Phase 5+ — one district at a time (each ≈ 4–6 commits)**
Foundation Square → Craftsman's Lane → Enterprise Heights → Tinkerers' Park →
The Harbor → stamps finale/passport. Ship each as its own drop — perpetual
fresh content and a steady commit graph.

**Estimated beta:** ~24 daily commits ≈ 3–4 weeks.

---

## 6. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Scope creep per district | District contract + fixed beat count (max 3 story beats, 1 signature moment, 1 stamp) |
| Art style inconsistency | Generate all AI backdrops in one batch with one style prompt; procedural work uses shared palette tokens |
| Mobile jank | Perf pass is a *required* final commit of every district; auto-reduced particle/layer counts |
| Wonderous clone accusations | Borrow patterns (scroll scrub, collectibles), never assets/visuals; the city metaphor + personal story is original |
| Losing steam mid-journey | Beta ships after 2 districts; every district afterwards is an independent, announceable drop |
| Kotak confidentiality | Exchange district uses only JD-level public phrasing + simulated market data |
