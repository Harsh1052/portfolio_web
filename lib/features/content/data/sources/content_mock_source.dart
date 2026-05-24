import '../models/portfolio_content.dart';

/// In-memory mock — used during development and as a fallback if Firestore
/// is unavailable. Switch to ContentRemoteSource by setting useMock=false in
/// ContentRepositoryImpl once the Firestore document is populated.
class ContentMockSource {
  Future<PortfolioContent> getContent() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return const PortfolioContent(
      tagline:
          "I build mobile and web apps for people who don't have flagship phones. "
          '15,000 farmers across rural India use what I ship daily.',
      contact: ContactInfo(
        email: 'surejapatel@gmail.com',
        githubUrl: 'https://github.com/Harsh1052',
        linkedinUrl: 'https://www.linkedin.com/in/harsh-sureja-87a70b16a/',
        mediumUrl: 'https://medium.com/@surejapatel',
        // TODO: hosted PDF — copy Harsh_Sureja_Flutter_Developer.pdf → web/resume.pdf
        resumeUrl: '/resume.pdf',
      ),
      about: AboutContent(
        prose:
            'I joined FarmSetu because of the kind of opportunity that doesn\'t '
            'show up often this early in a career: sole engineer ownership of the '
            'whole mobile and web stack. Architecture, releases, performance, '
            'observability — all of it mine to figure out. That kind of '
            'responsibility forces you to grow faster than any tutorial or '
            'certification can.\n\n'
            'What I didn\'t expect was how much the job would change me as an '
            'engineer the moment I actually met the people using what I built. '
            'On one of my first field visits, a farmer told me the app was too '
            'slow on his phone and burned through his mobile data faster than '
            'other apps he used. We\'d been testing on WiFi, on good phones, in '
            'an office — so we\'d never felt any of it. That single conversation '
            'changed how I work. We started taking API payloads seriously, cut '
            'down on unnecessary calls, and cached unchanged data locally so we '
            'weren\'t burning through farmer data on every screen. The benchmarks '
            'I trusted before that field visit weren\'t real benchmarks. The '
            'farmer\'s phone was.\n\n'
            'The bigger lesson from being the sole engineer is harder to put on '
            'a resume, but it shapes everything I do now: when no one else is '
            'going to catch your bugs, you write code differently. You think '
            'harder about what could go wrong because the only safety net is the '
            'one you build yourself. You read your own pull requests like a '
            'stranger would. You over-document the things you\'ll forget. '
            'Ownership doesn\'t just mean responsibility — it changes your '
            'relationship with the code itself.\n\n'
            'Right now I\'m working toward full-stack. After four years of '
            'shipping mobile apps, I want to understand what\'s on the other '
            'side of the API — not just consume it, but design it. '
            'Currently learning: Python.',
      ),
      projects: [
        ProjectContent(
          slug: 'farmsetu',
          name: 'FarmSetu',
          description:
              'AgriTech + FinTech super app rebuilt from the inside — CI/CD '
              'automation, architecture overhaul, and the SetuBooks FinTech '
              'module, serving 15,000+ farmers across rural India.',
          metrics: ['15K+ farmers', '4h → 1-click releases'],
          techTags: ['Flutter', 'Firebase', 'BLoC'],
          caseStudy: CaseStudyContent(
            role: 'Senior Software Engineer · Sole Mobile & Web Engineer',
            timeline: 'June 2024 – present',
            stack:
                'Flutter · Flutter Web · Dart · Firebase · GraphQL · BLoC · Codemagic',
            summary:
                'I inherited a working but fragile mobile app serving farmers '
                'across rural India, and rebuilt the foundation — releases, '
                'architecture, performance — while shipping the FinTech module '
                "that became the product's anchor feature.",
            problem:
                "When I joined FarmSetu in June 2024, the app was already in farmers' hands. "
                'It worked. But "working" was hiding three problems that compounded each other.\n\n'
                'Releases were manual and risky. Every release meant creating builds from my local '
                'machine — manually editing the env file, choosing the right production configuration, '
                'uploading to both the Play Store and App Store by hand. Miss one step, and you\'d '
                'ship a dev build to production. The release process was a four-hour ritual where '
                'one wrong click could break things for thousands of farmers.\n\n'
                'Performance was uneven in ways that hurt real users. The map screen — used every '
                'time a farmer wanted to add a plot — had a memory leak. Controllers weren\'t being '
                'disposed, and worse, the full Google Maps SDK was being initialized even on screens '
                'that only needed a static map image. On low-end Android phones, which most of our '
                'farmers use, this meant jank, crashes, and a slow path to one of the app\'s core '
                'features.\n\n'
                "The architecture didn't handle the unexpected. The dynamic form system — used "
                'heavily across the app — broke when the backend sent a form configuration the '
                "frontend didn't recognize. There was no graceful failure, no fallback. One mismatch "
                'between frontend and backend assumptions and the form would crash, taking the screen '
                'with it.\n\n'
                'For an app meant to serve 15,000+ farmers in rural India — many on the lowest-end '
                'Android devices, on patchy connections, often visiting the app only a few times a '
                'week — none of this was acceptable.',
            approach:
                'I tackled the rebuild in deliberate order: CI/CD first, architecture next, '
                'performance last.\n\n'
                "CI/CD first, because you can't fix anything else safely without it. I set up "
                'Codemagic with three flavors (dev, qa, prod), triggered automatically on push to '
                'the release branch. Both platforms, both stores, both Firebase environments — all '
                'from a single trigger. What used to be a four-hour manual ceremony became one click. '
                'More importantly, it became reproducible. Same input, same output, every time.\n\n'
                "Architecture next, but not as a rewrite. Rewrites are how startups die. Instead, "
                'I established Clean Architecture and TDD as the standard going forward, and applied '
                'it to all new work — including SetuBooks, the FinTech module that would become the '
                "most important part of the product. Old features kept working in their existing "
                'form; new ones were built on the foundation that would scale. This let me ship '
                'value continuously instead of disappearing into a six-month refactor.\n\n'
                'Performance last, targeting the specific screens that hurt users. I didn\'t optimize '
                'abstractly — I went after the three screens I knew were bleeding. The map screen was '
                'reworked. Controllers were properly disposed in the widget lifecycle, and screens '
                'that only needed a static map were switched to render a map image instead of '
                'initializing the full Google Maps SDK. The dynamic form rebuild problem — where '
                'every keystroke triggered a full form rebuild because BLoC listeners were too broad '
                '— was fixed using buildWhen to restrict rebuilds to only the specific fields that '
                'changed. The finance charts in SetuBooks would jank when farmers with large '
                'transaction histories opened them. The bottleneck wasn\'t the chart library — it '
                'was the calculation work running on the main thread, blocking the animation. I moved '
                'that calculation to a Dart Isolate via compute(). The animation stays smooth because '
                'the UI thread stays free.',
            whatWasHard:
                "The thing I'm proudest of solving is the Dynamic Form system in SetuBooks — "
                'specifically the real-time calculation engine. In SetuBooks, financial forms aren\'t '
                'hardcoded in the app. The backend sends formula expressions as part of the form '
                'configuration. The app has to receive the formula, parse it, bind it to the relevant '
                'form fields, recalculate in real time as the user types, and render the result '
                'smoothly — all without rebuilding the form on every change.\n\n'
                "This wasn't just a UI problem. It was an architectural one. The formula evaluator "
                'needed to be safe (no eval-style holes), bound to BLoC state in a way that '
                "didn't cause cascading rebuilds, and resilient when the backend sent an unexpected "
                'formula shape. I built an evaluator that parses the expression into a typed AST, '
                "binds it to the form's field map, and recomputes only when its dependencies change.\n\n"
                'The payoff: new financial calculations can be added by backend changes alone, without '
                "an app release. For a startup shipping FinTech features fast, that's leverage.\n\n"
                'The runner-up "hard thing" was the counterparty ledger and invoicing system — months '
                'of work modeling how farmers actually track money owed to and from suppliers, getting '
                'the offline-first sync right, and making the cash flow analytics genuinely useful '
                'instead of decorative.',
            outcomes: [
              '15,000+ farmers using the app across rural India',
              'Release time cut from a 4-hour manual ceremony to a single click that ships to both stores and Firebase',
              'Map screen memory leak eliminated, full Maps SDK no longer initialized for static use cases',
              'Finance charts rendering smoothly on large datasets via background-thread calculation',
              'Dynamic forms with API-driven real-time calculations powering SetuBooks',
              'SetuBooks FinTech module shipped end-to-end: income/expense tracking, counterparty ledgers, invoicing, cash flow analytics',
              'Production observability added: Sentry + Firebase Crashlytics + graceful uncaught error handling',
            ],
            whatIdDoDifferently:
                'Three honest ones, with the benefit of hindsight.\n\n'
                'Error handling should have been universal from day one. I initially built error '
                'handling per API integration — each one had its own try/catch shape, its own logging '
                'path, its own retry logic. I later refactored to a configurable, universal error '
                "layer. If I started over, that's the layer I'd build before any feature work.\n\n"
                'The Dynamic Form base should have been abstract from day one. I built the first form, '
                'then the second one looked similar, then the third — and only then did I refactor to '
                'an abstract base class that new forms extend. The right move was to design for the '
                'second form before writing it.\n\n'
                "For the store release pipeline, I'd use Fastlane instead of Codemagic. Codemagic "
                'got us shipping fast under deadline pressure, which was the right call at the time. '
                'But Fastlane is the better long-term choice for store automation — more flexible, '
                'better community, more granular control over signing and metadata. '
                "I'd make the time investment upfront on the next greenfield project.",
          ),
        ),
        ProjectContent(
          slug: 'trovo',
          name: 'Trovo',
          description:
              'I built a complete technical POC for a location-based treasure '
              'hunt game — every piece of the stack working end-to-end — and '
              'discovered that the hardest problem wasn\'t engineering. '
              'It was content.',
          metrics: [],
          techTags: ['Flutter', 'Firebase', 'RevenueCat'],
          caseStudy: CaseStudyContent(
            role: 'Solo developer · Side project',
            timeline: '2024 – present (POC, not yet publicly launched)',
            stack: 'Flutter · Firebase · BLoC · Google Maps · RevenueCat',
            summary:
                'I built a complete technical POC for a location-based treasure '
                'hunt game — every piece of the stack working end-to-end — and '
                'discovered that the hardest problem wasn\'t engineering. '
                'It was content.',
            problem:
                'I saw a government tourism post promoting state landmarks — '
                'places worth visiting, but most people don\'t because there\'s '
                'no obvious reason to go. That sparked an idea: what if '
                'exploring those places could be a game?\n\n'
                'The concept was simple. Pre-designed treasure hunts for '
                'specific locations. Players unlock checkpoints by physically '
                'reaching them. After every checkpoint, a piece of the place\'s '
                'history or culture unfolds — so you don\'t just visit, you '
                'learn. Complete a hunt within the time limit and you earn a '
                'small reward. Premium hunts paid to play, free hunts paid '
                'players for finishing — a two-sided economy meant to drive both '
                'engagement and revenue.\n\n'
                'It was meant to make tourism feel like a game, and to nudge '
                'people toward places they\'d otherwise skip.',
            approach:
                'I built Trovo as a complete vertical slice — every system a '
                'real product would need, working end-to-end.\n\n'
                'Authentication via Google Sign-In and Firebase Auth. Hunt '
                'selection from a browsable list. GPS-based checkpoint unlocking '
                'via Haversine geofencing — players have to be physically at a '
                'location to progress. Story delivery that unlocks after each '
                'checkpoint, the educational layer that makes it more than a '
                'scavenger hunt. Two checkpoint types: clue-answer riddles and '
                'photo-task captures. A race-against-the-clock timer mechanic '
                'for stakes and finish bonuses. Real-time Firestore syncing so '
                'progress survives app closures and could later support '
                'multiplayer. RevenueCat subscriptions for the premium hunt '
                'paywall. A reward/payout system for players who complete '
                'qualifying hunts.\n\n'
                'The UI is functional but still rough — the polish layer '
                'hasn\'t gotten the same attention as the systems work, and '
                'that\'s a deliberate trade-off. Engineering first, design '
                'second, content last.',
            whatWasHard:
                'The honest answer is the one I least expected when I started: '
                'the engineering wasn\'t the bottleneck. The content was.\n\n'
                'Every technical piece — geofencing accuracy, Firestore quota '
                'management, RevenueCat edge cases, the reward calculation, the '
                'timer — I could solve. Each one took some work, but none of '
                'them were the wall.\n\n'
                'The wall is content. To make Trovo actually useful, I need a '
                'steady supply of well-designed treasure hunts for real places. '
                'Each hunt requires researched historical content, working clues '
                'that aren\'t too easy or too hard, valid GPS coordinates, photo '
                'task locations, calibrated reward economics. It\'s a production '
                'problem, not a code problem. And the platform I built doesn\'t '
                'yet have an admin tool to make content creation easy — every '
                'hunt would currently have to be entered manually.\n\n'
                'This was the surprise of the project, and the most useful '
                'lesson I took from it. I spent months making sure every '
                'technical edge case was solid. Meanwhile, the actual question '
                '— "can we produce enough quality hunts to make this worth '
                'playing?" — was the one I should have answered first.\n\n'
                'It\'s an obvious lesson in retrospect. It wasn\'t obvious when '
                'I was writing the code.',
            outcomes: [
              'Complete POC built — Auth, hunt selection, GPS checkpoint unlocking, story delivery, dual checkpoint types, timer, real-time Firestore sync, RevenueCat subscriptions, and reward system, all working end-to-end',
              'Cross-platform — iOS and Android, single Flutter codebase',
              'All engineering risks proven out — geofencing, subscriptions, real-time sync all confirmed buildable',
              'The real product risk identified — content production, not engineering',
            ],
            whatIdDoDifferently:
                'I\'d start smaller, and I\'d validate before building.\n\n'
                'Specifically: one hunt, one city, manually run on top of the '
                'simplest possible technical foundation. Skip the subscription '
                'system, skip the reward economics, skip the polish — just see '
                'if real people in one place would play one hunt and ask for '
                'another. That\'s the question that decides whether Trovo is a '
                'product or an interesting POC.\n\n'
                'I\'d also talk to potential players before writing the platform '
                'code. I imagined who Trovo was for; I never confirmed. '
                'Engineers default to building the thing because building is the '
                'part we know how to do. The discipline I\'m taking away from '
                'Trovo is the one I\'ve heard described as "find the riskiest '
                'assumption and test that first" — and the riskiest assumption '
                'was almost never on the engineering side.\n\n'
                'The code held up. The systems work. If I rebuilt Trovo today, '
                'the engineering decisions are mostly the same. The '
                'non-engineering decisions are the ones I\'d revisit.',
          ),
        ),
        ProjectContent(
          slug: 'nug',
          name: 'NUG',
          description:
              'US-based e-commerce app. Payment provider had no Flutter SDK — '
              'I shipped a working checkout flow using Chrome Custom Tabs and '
              'deeplink return instead.',
          metrics: ['10K+ downloads'],
          techTags: ['Flutter', 'Firebase', 'Deeplinks'],
          caseStudy: CaseStudyContent(
            role: 'Flutter Developer · Client project at Elision Infotech',
            timeline: '2023',
            stack:
                'Flutter · FlutterFlow (scaffolding) · Firebase · Deeplinks · Chrome Custom Tabs',
            summary:
                'A US-based e-commerce client needed payments through a provider '
                'with no Flutter SDK. I designed a workaround using the system '
                'browser and deeplink return — and learned more about iOS '
                'Universal Links than I ever wanted to.',
            problem:
                'NUG is a US-based e-commerce app built for a client at Elision. '
                'We needed to integrate a payment provider, but ran into the kind '
                'of constraint engineers don\'t usually talk about: the provider '
                'only supported the US market, and they didn\'t ship a Flutter SDK. '
                'No package on pub.dev, no community wrapper, no obvious path.\n\n'
                'The first instinct was to render the payment page in an in-app '
                'webview. Standard pattern. It didn\'t work — the payment site had '
                'navigation quirks that webviews don\'t handle cleanly: redirects '
                'between domains, third-party cookies, popups that didn\'t render '
                'properly. The user would get partway through the flow and the page '
                'would break.\n\n'
                'Webview wasn\'t going to work, and there was no native SDK to fall '
                'back on. We needed a different approach.',
            approach:
                'The solution wasn\'t elegant, but it was reliable: skip the webview '
                'entirely and use the user\'s actual browser.\n\n'
                'The flow: the backend generates a payment URL when the user hits '
                'checkout. The app opens that URL in Chrome (or Safari on iOS) using '
                'a Custom Tab — not a webview. The user completes payment in their '
                'real browser, where the payment site works correctly. On payment '
                'success, the payment provider redirects to a URL we control. That '
                'URL is registered as a deeplink — an App Link on Android, a '
                'Universal Link on iOS. The deeplink fires, reopens NUG, and routes '
                'the user directly to the order details screen.\n\n'
                'Once I figured out this approach, the architecture was clean. The '
                'hard part wasn\'t the design — it was getting the iOS half of it to '
                'actually work.',
            whatWasHard:
                'iOS Universal Links. If you\'ve shipped Universal Links to '
                'production, you already know. If you haven\'t: it\'s one of the '
                'most fragile, hostile-to-debug systems Apple ships. Get it right '
                'and it\'s invisible. Get any one thing wrong and the whole flow '
                'silently fails — no error, no log, just a deeplink that doesn\'t '
                'open the app.\n\n'
                'To make a Universal Link work, you have to host an '
                'apple-app-site-association file at the exact right path on your '
                'domain, served with the exact right MIME type, with the exact right '
                'JSON shape, signed against the exact right team ID and bundle ID. '
                'Then you have to configure Associated Domains in your app '
                'entitlements. Then you have to wait — because iOS caches '
                'verification aggressively, and a fresh install on a test device '
                'might or might not pick up the latest version of your association '
                'file.\n\n'
                'I spent more time debugging this than I spent on every other part '
                'of the deeplink flow combined. The pattern of "works on my device, '
                'doesn\'t work on the tester\'s" came up multiple times. The fix '
                'wasn\'t usually code — it was waiting for a cache to expire, '
                'reinstalling on a clean device, or finding one more configuration '
                'mismatch between Xcode, the entitlements file, and the JSON on '
                'the server.\n\n'
                'It worked in the end. But the lesson was less about deeplinks and '
                'more about Apple\'s tooling: you don\'t really learn Universal '
                'Links so much as accumulate scars.',
            outcomes: [
              '10,000+ downloads on the Play Store',
              'Payment flow shipped to production — workaround approach handling a constraint where no Flutter SDK existed',
              'End-to-end deeplink integration across iOS and Android, with cold-start routing into the correct order screen',
              'FlutterFlow used to scaffold auth and basic screens for speed; deeplink and payment work written manually in Flutter/Dart where the real engineering was',
            ],
            whatIdDoDifferently:
                'I\'d verify the iOS Universal Links setup before writing any of '
                'the deeplink return logic, not in parallel with it. I lost time '
                'chasing bugs in routing code that turned out to be Universal Link '
                'verification failures upstream. The fix on the routing code didn\'t '
                'matter while Apple still didn\'t trust the association file.\n\n'
                'The general lesson: when integrating with a system that has its own '
                'verification or caching layer, prove the verification works on a '
                'blank slate first. Build the rest of the flow only after that '
                'foundation is green. I now treat Universal Links and App Links '
                'setup as Phase Zero on any project that needs them.',
          ),
        ),
      ],
      articles: [
        ArticleContent(
          title:
              'AI Pair Programming as a Solo Flutter Dev: 5 Workflows That Stuck',
          summary:
              'How I use AI tools as a solo engineer to move faster without '
              'sacrificing code quality.',
          publishedDate: '2025',
          url:
              'https://medium.com/@surejapatel/ai-pair-programming-as-a-solo-flutter-dev-5-workflows-that-stuck-651dff01a7d0',
        ),
      ],
    );
  }
}
