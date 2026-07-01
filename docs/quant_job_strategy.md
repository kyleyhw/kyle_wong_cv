# Industry (Quant) CV: Assessment, Target Firms & Odds

*Prepared July 2026. A candid strategy companion to the `industry` / `industry-quant` CV variant. This is a working document — edit freely.*

> **Scope.** The `industry-quant` branch is currently **byte-identical to `industry`**, so the industry CV *is* the quant CV. This document assesses that variant and maps out where to aim. It is deliberately blunt where bluntness is useful — flattery doesn't get you interviews.

---

## 1. TL;DR

- **The profile is genuinely strong for a no-PhD candidate**: Cambridge Part III + Toronto physics/maths, real statistical-inference research (MCMC, power-spectrum estimation), *and* self-directed trading systems with live P&L. That last part is rarer than the degrees and is your edge.
- **Aim primarily at Quant Trader (QT) and Tier-2 prop/market-making roles**, not PhD-gated Quant Research (QR) seats at the elite funds. QT is the most credential-agnostic role and rewards exactly what you have.
- **Play your niche**: prediction markets (Polymarket) + weather derivatives + crypto-adjacent trading is a real differentiator. It opens crypto-native and energy/commodity/weather desks where the physics-grad crowd is thinner.
- **Citizenship is a strategic asset**: US citizen (no US sponsorship needed — big deal), HK citizen (Asia access), Cambridge grad (UK Graduate visa → London is open). Few candidates can apply on three continents without a visa headache.
- **Entry-level full-time only** (you've graduated, so internships with return-to-study requirements are out). That matters: most elite firms fill their full-time seats via **intern→FT conversion**, a funnel now closed to you — so weight your effort toward firms that hire full-time new-grads *directly* and toward off-cycle/niche openings (Tier B/C below).
- **Timing**: the autumn campus cycle opens **~August–October 2026** (full-time new-grad roles for 2027 starts), reviewed rolling — apply in the first two weeks. Off-cycle entry-level roles at Tier-2/3, banks, and niche shops appear year-round; check and apply to anything live *now*.
- **Honest odds**: any *single* Tier-1 seat is low-single-digit %. But landing *a* good quant/quant-adjacent offer over a full, broad, well-prepped cycle is meaningfully better than even — call it **60–75%**, and that number is mostly within your control (interview grind + application breadth), not fixed by pedigree.

---

## 2. How the CV looks

### What's working
- **Target-school pedigree, twice.** Cambridge MASt/Part III (Astrophysics) and Toronto HBSc Physics & Maths (High Distinction) are both on quant recruiters' target lists. Part III especially carries weight.
- **The research is quant-relevant, not generic physics.** High-dimensional MCMC parameter estimation, statistical priors in an estimator, simulation validation — this is the *inference-under-uncertainty* skillset firms actually want, not just "did physics."
- **You have skin in the game.** `quant_core` (backtesting engine + IBKR execution + risk), `mercury_strategies` (event-driven, AWS, Kelly sizing, 4 months live trading), plus `agent_evolve`. A backtested strategy with live P&L beats an identical CV with no projects every time. This is your single biggest differentiator over the modal physics applicant.
- **Coursework signals numeracy**: Astrostatistics, Computational Physics/Astrophysics, PDEs, Numerical Relativity.

### What to fix (in rough priority order)
1. **No internships / no prior industry experience — and you can't intern now.** This is the single biggest gap, and it's compounded by the entry-level-only constraint: at firms that fill full-time seats almost entirely via intern conversion (Jane Street, Optiver, SIG, IMC lean this way), you're applying into the *residual* full-time pool. Mitigate by (a) leaning on the trading projects and on **QT**, which cares least about pedigree/internships; (b) targeting firms that run **direct full-time new-grad hiring** and off-cycle roles (Tier B/C, banks, crypto/energy shops); and (c) making the projects and market interest *loud* — they are your substitute for an internship line.
2. **"Graduated with Good Honours equivalent" quietly undersells or confuses.** Recruiters read grades closely, and "Good" (roughly a merit) next to Toronto's "High Distinction" invites the question you don't want asked. Options: (a) if the classification is genuinely strong, state it plainly; (b) if it's middling, consider dropping the qualifier and letting "MASt/Part III, University of Cambridge" stand — the admission bar itself is signal. Don't volunteer a soft grade.
3. **Name your languages and tools.** The Skills section lists "scientific computing, ML, HPC" but not a single language. Quant screens filter on **Python** and, for dev/low-latency, **C++**. State them explicitly (Python, C++, whatever's real), plus the stack (NumPy/pandas, PyTorch/JAX, etc.). Right now a keyword filter could miss you.
4. **Steal your own best engineering detail.** Ironically the `industry-quantum-consulting` variant's `sound_simulation` bullet is *more* impressive than anything on the quant CV — "fused numba-JIT with prange parallelism for ~65× speedup." That quantified, concrete performance-engineering is catnip for quant dev/trading screens. Put a bullet like it on the quant variant.
5. **Quantify the research and project bullets.** "Improving signal inference," "enabling efficient forecasting" are vague. Add numbers: dataset size, dimensionality of the MCMC, % / ×-fold improvements, latency, Sharpe or hit-rate ranges on backtests (even rough). Firms think in numbers; speak their language.
6. **Reconsider "Counter-Strike skins."** It's a *real* market and a great **interview story** (liquidity, arbitrage, adverse selection). But on paper, next to "prediction markets," a conservative first-round screener may read it as unserious. Suggestion: lead with Polymarket/prediction-markets, and either reframe skins as "secondary-market arbitrage" or hold it for the conversation.
7. **Trim the "AI Tools" bullet.** Listing Claude Code / Gemini / ChatGPT as a skill reads as filler-to-junior on a quant CV. Fold it into one line or cut it; it's not the signal you think it is here.
8. **Drop "(work in progress)" on `mercury_strategies`.** "WIP" undercuts your headline project. It's private anyway, so the claims must be interview-defensible regardless — present it as built, be ready to whiteboard it.
9. **Competition pedigree, if any, should be loud.** Firms explicitly recruit Putnam / olympiad medalists. If you have anything (maths olympiad, Putnam, physics olympiad), surface it near the top. If not, just know it's a line the modal Tier-1 hire often has.

### Format
Clean, two-page, sensibly ordered. One structural thought for the quant variant: your trading **projects** are the quant-relevant signal, so consider surfacing them right after Education (or even a compact "Selected Projects" callout in the header region) rather than after the research block — recruiters skim the top third.

---

## 3. Where you fit: pick the right role

| Role | Degree reality | Fit for you | Verdict |
|---|---|---|---|
| **Quant Trader (QT)** | Most credential-agnostic; values mental math, probability, decision-under-uncertainty, commercial instinct. Undergrads get in. | Your trading projects + markets curiosity + numeracy map directly. | **Primary target.** |
| **Quant Research (QR)** | Masters "usually sufficient," but elite-fund QR is **PhD-dominated**. | Strong Masters, but you'd be competing against PhDs for the same seat. | **Reach** at Tier-1; realistic at Tier-2 / banks. |
| **Quant Developer (QD)** | Programming > credentials; C++/low-latency prized. | Real projects, but CV under-evidences C++/systems depth today. | **Viable** if you foreground engineering (see §2.4) and can show C++. |

**Strategy:** apply as **QT first**, QR/QD where the firm blurs them or where your project story fits, and treat elite-fund pure-QR as a bonus lottery ticket rather than the plan.

---

## 4. Target firms

Apply **broadly** — this is a portfolio game, not a sniper shot. 30–50 serious applications across the tiers below is normal and correct. Every firm listed runs (or feeds into) a structured graduate route.

### Tier A — Reach (apply anyway; QT > QR odds; ~1–5% each)
The elite prop/market-makers and multi-strats. Sub-1% for QR grad seats; QT is your better door.
- **Jane Street** (London + NYC) — mathematically strong generalists; US citizenship helps the NYC office.
- **Citadel / Citadel Securities** — QT and dev; heavy filtering.
- **Optiver** (Amsterdam / London / Chicago) — **mental-math-heavy, explicitly no-PhD-friendly** → one of your better Tier-A shots.
- **Hudson River Trading, Jump Trading, Two Sigma, D. E. Shaw** — lean QR/PhD; bigger reach, but Two Sigma/DES also hire strong dev.

### Tier B — Best expected value (genuinely gettable with prep)
Where a strong no-PhD Masters with real projects lands. **Spend most of your energy here.**
- **Prop / market-making, no-PhD culture, structured grad programs:** **SIG, IMC, DRW, Five Rings, Akuna Capital, Wolverine, Maven Securities, Flow Traders, Tower Research, Old Mission, Optiver-London.** SIG and IMC in particular run strong new-grad QT pipelines and are the highest-EV "aim high" targets.
- **London systematic funds (Cambridge is on their doorstep):** **G-Research, Man Group / AHL, Marshall Wace, Qube RT, XTX Markets, Squarepoint, Quadrature, Aquatic Capital, Cubist/Point72.** G-Research and Man AHL are especially receptive to strong physics/maths Masters.

### Tier C — Broaden the net / play your niche
- **Bank quant-strats desks** (Goldman Strats, JPMorgan, Morgan Stanley): more QR-analyst, take strong Masters, excellent training, softer bar than elite prop. A very sensible floor.
- **Crypto-native & prediction-market quant** — *your niche.* Your Polymarket + crypto-adjacent work puts you **ahead of the modal physics grad** here: **Wintermute, GSR, Cumberland/DRW Crypto, Kraken/Coinbase quant, Amber**, plus prediction-market-native shops. Thinner competition, direct relevance.
- **Energy / commodity / weather trading** — `mercury_strategies` is literally a **weather-derivative** engine. That maps onto weather/energy desks at commodity houses and energy prop shops (e.g., **Trafigura, Vitol, Trailstone, energy-focused funds**). Almost no other physics grad can say "I built a weather-derivatives trading system."

> **Niche is leverage.** Against Jane Street you're one of thousands of physics grads. Against a crypto/prediction-market or weather-derivatives desk, your self-directed work is *on-topic* and the applicant pool is far smaller. Weight your effort accordingly.

---

## 5. Geography — a genuine advantage

- **United States (US citizen):** no visa sponsorship required. This is a *material* advantage — many firms filter non-citizens on cost/friction. Apply freely to NYC/Chicago.
- **United Kingdom (Cambridge grad):** the **Graduate visa** (2 years post-study) means London firms can hire you without immediate sponsorship. London is Europe's quant hub and your current base — lean into it.
- **Asia (HK citizen):** Hong Kong / Singapore desks (Jane Street HK, Optiver APAC, IMC APAC, Citadel Securities HK, crypto shops) are open to you with local work rights.

Few candidates can credibly apply in New York, London, *and* Hong Kong without a sponsorship conversation. Use all three funnels — it multiplies your shots on goal.

---

## 6. Timing — two funnels, act now on both

You're applying **entry-level full-time only** (internships are out — hard graduation-date limits). Two funnels feed that:

1. **The autumn campus cycle (~August–October 2026)** — full-time new-grad roles for 2027 starts open at Jane Street, Optiver, G-Research, and peers, reviewed **rolling**; slots fill by October/November. Apply in the **first two weeks**. Caveat: at intern-conversion-heavy firms the *full-time* new-grad allocation is smaller than the intern one, so don't stake the cycle on them.
2. **Off-cycle full-time roles (year-round)** — Tier-2/3 prop shops, bank quant desks (banks genuinely hire off-cycle), and crypto/energy/prediction-market shops post entry-level roles continuously. **Check these today and apply to anything live** — this funnel doesn't wait for autumn and is where the entry-level-only path often pays off fastest.

- You graduated Sept 2025, so you're a **recent grad**, ~10 months out — normal and fine for full-time entry-level; the projects explain the interim.
- **Between now and August:** grind interview prep (§8), fix the CV per §2, and pre-write materials so you can fire the moment autumn roles post while working the off-cycle funnel in parallel.

---

## 7. Honest odds

Framed as a portfolio, not a single bet:

- **Any specific Tier-1 seat (Jane Street QR, Citadel, etc.):** low single digits each, and a notch lower still because you're in the *full-time* pool rather than the intern-conversion pipeline these firms mostly hire from. Real, but a lottery ticket. QT doors beat QR doors for you.
- **A strong Tier-2 / niche offer (SIG, IMC, DRW, G-Research, Man AHL, a crypto/energy quant desk):** genuinely attainable — these are where your profile is *competitive*, not merely *present*.
- **Landing *a* good quant/quant-adjacent offer across a full, broad, well-prepped cycle (30–50 apps, all three geographies, niche included):** **~60–75%**, and that figure is mostly a function of things you control.

**The two binding constraints are both within your control:**
1. **The interview gauntlet** — mental math, probability, brainteasers, market-making games. Eminently trainable; you must *grind* it (months, not weeks).
2. **Breadth + timing** — apply wide, apply early in the cycle, don't self-reject from Tier-A but don't stake the cycle on it.

Your pedigree is *not* the bottleneck. The bottleneck is reps on interviews and a wide, early, niche-aware application campaign.

---

## 8. Action plan

**Now → August 2026**
- [ ] Fix the CV per §2 (name languages/tools; quantify bullets; import the numba/65× style detail; resolve the "Good Honours" line; reconsider CS-skins & AI-tools bullets; drop "WIP").
- [ ] Consider spinning up an `industry-quant-crypto` and/or `industry-energy` variant branch to foreground the Polymarket/weather-derivatives work for those niche applications (the branch architecture is built for exactly this).
- [ ] Start the interview grind: mental-math (Zetamac/arithmetic drills), probability & expected-value, brainteasers, market-making games (*Optiver 80-in-8*, trading games), and core stats/ML. Aim for daily reps.
- [ ] Pre-draft applications and shortlist ~40 firms across Tier A/B/C and all three geographies.
- [ ] Make `quant_core` presentable (README, results, a clear write-up) and be able to whiteboard `mercury_strategies` end-to-end.
- [ ] **Apply to off-cycle entry-level roles that are already live *now*** (Tier-2/3 prop, bank quant desks, crypto/energy/prediction-market shops) — don't wait for autumn for these.

**August–October 2026 (autumn campus cycle opens)**
- [ ] Apply in the **first two weeks**, prioritizing rolling-review firms (Jane Street, Optiver, SIG, IMC, G-Research, Man AHL) — targeting their **full-time new-grad** postings specifically.
- [ ] Fire the niche applications (crypto/prediction-market, energy/weather) in parallel — smaller pools, faster processes, and often off-cycle anyway.

**Ongoing**
- [ ] Track every application (firm, role, date, stage) in a simple sheet.
- [ ] After each interview, log what was asked and drill the gaps before the next one.
- [ ] Network: alumni (Cambridge/Toronto) at target firms, quant Discords/forums, referrals — a referral often beats the cold funnel.

---

*Sources consulted (July 2026): firm graduate-program pages and cycle-timing write-ups (Jane Street, Optiver, G-Research, IMC), and role/degree-requirement and hiring-climate analyses from Quant Blueprint, Quantt, OpenQuant, CMU MSCF, Wall Street Oasis, and Young & Calculated. Firm lists and timelines shift year to year — verify each firm's current cycle dates and role definitions on their careers page before applying.*
