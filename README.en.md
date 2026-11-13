# Unproven (未证之牌)

[中文](README.md) | **English**

A math-themed Balatro content mod: conjectures, great moments in mathematical history, entropy, memes and named numbers — the whole mathematical universe pressed into jokers.

**v1.4.2**: 56 jokers + 6 consumables + a 4-voucher chain + 1 custom deck + 8 achievements. The achievement system, Prime Deck, Green–Tao Theorem, four-volume voucher chain and the legendary joker Kun are all live. v1.4.2 reworks Kun (practise with a 2+5 hand or a lone K; every scoring hand picks up the current multiplier) and adds three new custom card arts (von Neumann, Ada Lovelace, Kun). Playtesting, feedback and art contributions are all welcome.

## Installation

1. Install [Steamodded (SMODS)](https://github.com/Steamodded/smods) and [Lovely](https://github.com/ethangreen-dev/lovely-injector). Requires Lovely + SMODS 1.0+; Talisman is not needed.
2. Drop this folder into `%APPDATA%/Balatro/Mods/`.
3. Launch the game — **UNPROVEN** should appear in the MODS menu.

## Contents

*v1.4.2 · 56 jokers + 6 consumables + 4 vouchers + 1 deck + 8 achievements + 1 Boss + 1 challenge + 2 joker packs*

**Conjectures**: Collatz Conjecture, Goldbach's Conjecture, Catalan's Conjecture

**Great moments**: Milü (355/113), Margin Too Narrow ⭐, Wiles, The Night Before the Duel, Seven Years in Hiding, Euler's Identity, Declining the Million, Calabi–Yau Manifold

**Entropy**: Shannon Entropy, Binary, Heat Death, Maxwell's Demon

**Memes**: `e`, 73, 0.999…=1, 1+1=10, By Symmetry, Odd Changes Even Doesn't, Monte Carlo Method, Pareto Principle, Central Limit Theorem, Note That…, WLOG, Kun (two and a half years of practice: scores with a 2 and a 5 in the hand, or a lone K, stacking a permanent X2.5; every scoring hand picks up the current multiplier; on the board together with G2 in Box it triggers the "Ji Ni Tai Mei" easter egg)

**Named numbers**: 777, φ (Golden Ratio), 24 Game, 1729, Wheat on a Chessboard, 6174 (Kaprekar's constant), Zero

**Mathematicians**: Pythagoras, Riemann, Poincaré, Gödel, Hilbert's Hotel, Fields Medal (a mathematician-counting engine)

**Addenda**: G2 in Box (chickens and rabbits in one cage), Chen Jingrun 1+2, Gauss Summation

**Machines**: von Neumann (self-replication plus a 29-state tape), Ada Lovelace (pairs with von Neumann, X(1.01)^M), EDVAC (loads one program per round), Attention Is All You Need (self-attention at O(n²))

**Legacy chains**: Yuelü 22/7 (destroyed when surpassed → Milü enters the shop), √2 (thrown into the sea → spawns the Age of Irrationals), The Night Before the Duel (destroyed or sold → spawns Group Theory)

**Rivalries**: Newton (+0.25 X-mult per hand), Leibniz (+30 chips per hand), the Bernoulli family (a random member each round, counted as all 8 mathematicians toward the Fields Medal)

**Mystery cards**: 1984 / 1Q84 (hidden conditions — Big Brother is watching you)

**Number theory**: Green–Tao Theorem (3+ prime cards in arithmetic progression → X3, e.g. 3, 5, 7 or 3, 7, J)

**Paradoxes** (consumables · Tarot slot): Entropy Increase, Four Colour Theorem 1976, Monty Hall Problem, Draft (a marked card copies a random rank from another card in the hand when played, then reverts after scoring)

**Spectrals** (consumables · Spectral slot): Banach–Tarski Paradox (destroy 1 card in hand → 2 exact copies), Russell's Letter (a chosen joker is disabled for 1 round → next hand X2)

**Boss blind**: Seven Bridges of Königsberg (each suit can only score once this round)

**Challenge "The Unproven Journey"**: start with the Fields Medal and 3 random negative mathematicians; explore the rest of the mod through the shop

**Math joker packs**: small pack 3-choose-1 / super pack 5-choose-2, containing only this mod's math jokers

**Prime Deck**: a 24-card deck of primes only (2/3/5/7/J/K × four suits), starting with Goldbach's Conjecture

**Voucher chain**: *Elements* (hand size +1) → *Disquisitiones Arithmeticae* (+4 mult per scoring prime card); *Principia Mathematica* (all Aces +2 chips) → *GEB* (all Aces X2). You must buy the prerequisite before the successor appears.

**Achievements (8)**: Big Brother Is Watching, Chickens and Rabbits, Group Theory Immortal, Universal Constructor, Eight of a House, Mathematicians Assemble, The Limit of e, Math Pack Collector

> Notes: `e` only enters the shop pool after 3 consecutive hands of increasing score plus $27 in accumulated interest. `Seven Years in Hiding` waits 7 rounds, then hands out 5 negative legendary jokers plus 8 negative consumables in one go — after which the card is spent. `Zero` only appears in the shop once your deck is 6 cards smaller than at the start (it works as a wildcard placeholder for any rank).

## Status and Known Issues

- 5 custom card arts are enabled (Fields Medal, Calabi–Yau Manifold, von Neumann, Ada Lovelace, Kun — the `unprv_jokers` atlas); the rest are still vanilla placeholders, and contributions are welcome.
- Some card values are first drafts; balance will be unified after full-run integration testing.
- The v1.5 update is scheduled: a Chinese Mathematics Gallery (Yang Hui's Triangle / twelve-tone equal temperament), a duality version, more card art, and more.
- `Note That…`'s corner sticker is likewise a placeholder icon (a frame from the vanilla stickers atlas).

## Art Wanted 🎨

If you enjoy this mod, original card art contributions are very welcome:

- Style: Balatro card art — heavy black outlines, flat fills, high-saturation clashing colours, **no text on the art** (all copy lives in localization).
- Size: 71×95 per frame (1x) / 142×190 (2x).
- Template: the repo's `assets/template/` contains blank numbered grid templates (1x and 2x).
- Submit frames by pos index as a PR, or open an Issue with your layered source file. Accepted art gets enabled as a custom atlas and replaces every placeholder.

## License

Mod content and code © jasperwang614. Balatro © LocalThunk. This is fan-made content, unaffiliated with the official game.
