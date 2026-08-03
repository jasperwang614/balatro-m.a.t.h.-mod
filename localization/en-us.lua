return {
    descriptions = {
        Joker = {
            j_unprv_hailstone = {
                name = "Hailstone",
                text = {
                    "Each scoring number card gives",
                    "{C:mult}+1{} Mult per step of its {C:attention}3n+1{} sequence",
                    "{C:inactive}Score 2 and 7 together: {X:mult,C:white}X2.7{C:inactive} Mult{}",
                },
            },
            j_unprv_goldbach = {
                name = "Goldbach",
                text = {
                    "If two {C:attention}prime{} cards in your played hand",
                    "sum to another {C:attention}even{} card: {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}Primes: 2/3/5/7/J · Evens: 4/6/8/10/Q/A{}",
                    "{C:inactive}Every even number > 2 is two primes meeting.{}",
                },
            },
            j_unprv_catalan = {
                name = "Catalan",
                text = {
                    "If your played hand contains {C:attention}8{} and {C:attention}9{}:",
                    "{X:mult,C:white}X4{} Mult",
                    "{C:inactive}2^3 and 3^2, the only consecutive powers{}",
                },
            },
            j_unprv_shannon = {
                name = "Shannon Entropy",
                text = {
                    "{C:mult}+6{} Mult for each",
                    "{C:attention}distinct rank{} in played hand",
                },
            },
            j_unprv_binary = {
                name = "Binary",
                text = {
                    "Scoring {C:attention}even{} cards: {C:chips}Chips x2{} (left shift)",
                    "Scoring {C:attention}odd{} cards: +{C:mult}1{} Mult",
                    "{C:inactive}Everything is bits.{}",
                },
            },
            j_unprv_symmetry = {
                name = "By Symmetry",
                text = {
                    "If your played cards form a {C:attention}palindrome{}",
                    "(e.g. 5, 8, 3, 8, 5): {X:mult,C:white}X2{} Mult",
                },
            },
            j_unprv_oneten = {
                name = "1+1=10",
                text = {
                    "If your played hand has {C:attention}2+ Aces{}:",
                    "each Ace gives {C:chips}+10{} Chips",
                    "{C:inactive}There are 10 kinds of people{}",
                },
            },
            j_unprv_nines = {
                name = "0.999... = 1",
                text = {
                    "If every played card is a {C:attention}9{}: {C:chips}+10{} Chips",
                    "{C:inactive}It's a theorem. Deal with it.{}",
                },
            },
            j_unprv_seventythree = {
                name = "73",
                text = {
                    "If your played hand contains {C:attention}7{} and {C:attention}3{}:",
                    "{X:mult,C:white}X4.73{} Mult",
                    "{C:inactive}73 is the best number{}",
                },
            },
            j_unprv_zuratio = {
                name = "Zu's Ratio",
                text = {
                    "If your played hand contains {C:attention}3{}, {C:attention}5{} and {C:attention}Ace{}:",
                    "{X:mult,C:white}X1.5{} Mult",
                    "{C:inactive}355/113, a millennium ahead{}",
                },
            },
            j_unprv_euler = {
                name = "e",
                text = {
                    "With {C:attention}e/played cards{} chance, raise",
                    "{C:chips}Chips{} or {C:mult}Mult{} to the power of {C:attention}e{}",
                    "then multiply by {C:attention}played cards{}",
                    "{C:inactive}2/7/A/8 guarantees; enters shop after 3 hands scoring higher in a row + $27 interest{}",
                    "{C:inactive}lim(1+1/n)ⁿ, ever closer to god{}",
                },
            },
            j_unprv_seven77 = {
                name = "777",
                text = {
                    "If your played hand has {C:attention}3+ sevens{}:",
                    "{X:mult,C:white}X7.77{} and {C:money}+$7{}",
                },
            },
            j_unprv_oddeven = {
                name = "Odd to Even",
                text = {
                    "Up to {C:attention}3{} odd cards in your first hand",
                    "of each round gain +{C:attention}1{} rank (odds guaranteed if in deck)",
                    "gains {C:money}+$#1#{} sell value per transformed card",
                    "{C:inactive}Odd changes, even stays - check the quadrant.{}",
                },
            },
            j_unprv_phi = {
                name = "phi - Golden Ratio",
                text = {
                    "If your played hand has {C:attention}consecutive Fibonacci{} ranks",
                    "(1,2 / 2,3 / 3,5 / 5,8): {X:mult,C:white}X1.618{} Mult",
                },
            },
            j_unprv_montecarlo = {
                name = "Monte Carlo",
                text = {
                    "Randomly darts to estimate {C:attention}pi{} each hand",
                    "closer estimate = higher Mult (up to {X:mult,C:white}X3{})",
                    "{C:inactive}Calculating pi in a casino. On theme.{}",
                },
            },
            j_unprv_point24 = {
                name = "24 Game",
                text = {
                    "If 4 of your played cards can make",
                    "{C:attention}24{} with +-x/: {X:mult,C:white}X2.4{} Mult",
                },
            },
            j_unprv_pareto = {
                name = "Pareto",
                text = {
                    "If you play exactly {C:attention}1{} card:",
                    "{X:mult,C:white}X4{} Mult",
                    "{C:inactive}20% of the cards do 80% of the work.{}",
                },
            },
            j_unprv_centrallimit = {
                name = "Central Limit Theorem",
                text = {
                    "Ranks closer to the {C:attention}mean (7){} give more Mult",
                    "7: +8, 6/8: +6, 5/9: +4, 4/10: +2",
                    "{C:inactive}With enough samples, the world is a bell curve.{}",
                },
            },
            j_unprv_ramanujan = {
                name = "1729",
                text = {
                    "If your played hand contains {C:attention}1, 7, 2, 9{}:",
                    "{X:mult,C:white}X17.29{} Mult",
                    "{C:inactive}The taxicab number: two cubes, two ways.{}",
                },
            },
            j_unprv_euler_identity = {
                name = "Euler's Identity",
                text = {
                    "Each scoring {C:attention}3{} (pi): {X:mult,C:white}X#1#{} Mult",
                    "While holding e: {X:mult,C:white}X#2#{} (e^pi)",
                    "{C:inactive}e + 3 + A = e^{i*pi}+1=0: {X:mult,C:white}X#3#{} Mult",
                },
            },
            j_unprv_heatdeath = {
                name = "Heat Death",
                text = {
                    "First hand each round gains a random",
                    "{X:mult,C:white}X4{}-{X:mult,C:white}X12{} Mult, halving",
                    "each hand after (min {X:mult,C:white}X1{})",
                    "{C:inactive}All temperature differences will fade.{}",
                },
            },
            j_unprv_wheat = {
                name = "Wheat on Chessboard",
                text = {
                    "{C:mult}+1{} Mult, {C:attention}doubling{} each round",
                    "at {C:attention}64{} it is seized: {C:money}+$64{}",
                    "{C:inactive}The king thought he got a deal.{}",
                },
            },
            j_unprv_margin = {
                name = "Fermat's Margin",
                text = {
                    "I have a truly marvelous proof",
                    "which this margin is too narrow to contain.",
                },
            },
            j_unprv_margin_proven = {
                name = "Fermat's Margin",
                text = {
                    "If your played hand contains a {C:attention}Pythagorean triple{}",
                    "(e.g. 3, 4, 5): {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}Proven by Wiles: a^2+b^2=c^2{}",
                },
            },
            j_unprv_wiles = {
                name = "Wiles",
                text = {
                    "If your played hand contains a {C:attention}Pythagorean triple{}:",
                    "{X:mult,C:white}X2{} Mult",
                    "{C:inactive}Fermat couldn't fit it; Wiles wrote 108 pages.{}",
                },
            },
            j_unprv_g2inbox = {
                name = "G2 in box",
                text = {
                    "If your played hand solves the {C:attention}chickens & rabbits{} puzzle:",
                    "heads = cards played, feet = total ranks {C:attention}(A=1){}",
                    "rabbits = (feet - 2*heads)/2: each rabbit {X:mult,C:white}X(1+rabbit){}",
                    "each chicken {C:chips}+#1#{} Chips",
                    "{C:inactive}G (ji = chicken) + 2 (two = tu = rabbit) + in box = the cage.{}",
                },
            },
            j_unprv_chen = {
                name = "Chen 1+2",
                text = {
                    "While holding {C:attention}Goldbach{}:",
                    "it rises to {X:mult,C:white}X#3#{}, this Joker {X:mult,C:white}X#1#{},",
                    "and each hand adds {C:attention}1{} {C:attention}prime{} card to your hand",
                    "{C:inactive}Without it: {C:mult}+#2#{} Mult (still proving){}",
                    "{C:inactive}He proved 1+2; he left 1+1 for those after him.{}",
                },
            },
            j_unprv_gauss = {
                name = "Gauss Sum",
                text = {
                    "If your played hand contains {C:attention}A, 2, 3, 4, 5{}",
                    "(1+2+3+4+5=15):",
                    "{C:chips}+#1#{} Chips and {X:mult,C:white}X#2#{} Mult",
                    "{C:inactive}Sum 1 to 100? Gauss did it at age ten.{}",
                },
            },
            j_unprv_galois = {
                name = "Galois' Last Night",
                text = {
                    "If you only have {C:attention}1{} hand left:",
                    "this hand gains {X:mult,C:white}X3{} Mult",
                    "{C:inactive}I have no time.{}",
                },
            },
            j_unprv_zhang = {
                name = "Zhang's Seven Years",
                text = {
                    "Dormant for {C:attention}#1#/#2#{} rounds, no effect",
                    "When complete: gain {C:attention}#3#{} {C:dark_edition}Negative{} Legendary Jokers",
                    "and {C:attention}#4#{} {C:dark_edition}Negative{} Consumables (once)",
                    "{C:inactive}Seven years of silence, then a world-shaking paper.{}",
                },
            },
            j_unprv_zhang_awake = {
                name = "Zhang's Seven Years",
                text = {
                    "{C:attention}Dormancy over{}: payoff granted once",
                    "This Joker is spent",
                    "{C:inactive}Seven years of silence, then a world-shaking paper.{}",
                },
            },
            j_unprv_maxwell = {
                name = "Maxwell's Demon",
                text = {
                    "If your {C:attention}5{} scoring cards are strictly",
                    "{C:attention}monotonic{} in rank (up or down):",
                    "{X:mult,C:white}X4{} Mult",
                    "{C:inactive}It sits at the gate, letting only the fast through.{}",
                },
            },
            j_unprv_notice = {
                name = "Notice That...",
                text = {
                    "Each round, randomly {C:attention}notice{} 1 card",
                    "in your hand. It scores {X:mult,C:white}X2{} this round",
                    "{C:inactive}Notice: this card can win.{}",
                },
            },
            j_unprv_kaprekar = {
                name = "6174",
                text = {
                    "Rearrange your {C:attention}4{} scoring cards:",
                    "descending - ascending, {C:chips}÷100{} Chips",
                    "Play 6, 1, 7, 4: {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}Every 4-digit number falls into the hole.{}",
                },
            },
            j_unprv_wlog = {
                name = "WLOG",
                text = {
                    "Once per round: {C:attention}click this joker{}, then click",
                    "a card in hand to {C:attention}set its rank{} to any value",
                    "{C:inactive}WLOG, this card is a K.{}",
                    "{C:red}#1#{}",
                },
            },
            j_unprv_perelman = {
                name = "Perelman",
                text = {
                    "{C:attention}Cannot be sold{}",
                    "Interest and skipped blind rewards are refused:",
                    "each {C:money}$1{} → {C:mult}+2{} Mult",
                    "Refuse {C:money}$100{} total → {X:mult,C:white}X10000{} Mult",
                    "Refused {C:money}$#1#{} · {C:mult}+#2#{} Mult",
                    "{C:inactive}I don't need to be recognized.{}",
                },
            },
            j_unprv_calabiyau = {
                name = "Calabi–Yau Manifold",
                text = {
                    "Each round, rotate to a new \"view\":",
                    "{C:chips}+100{} Chips → {C:mult}+20{} Mult → {X:mult,C:white}X2{} Mult → {C:money}+$8{}",
                    "Current view: #1#",
                    "「落花人獨立，微雨燕雙飛。」",
                },
            },
            j_unprv_zero = {
                name = "Zero",
                text = {
                    "Once per round: {C:attention}click this joker{}, then click",
                    "a card in hand to make it {C:attention}nonexistent{}:",
                    "counts as {C:attention}any rank{} for hand type, never scores",
                    "Each zeroed card: permanent {C:chips}+25{} Chips",
                    "Zeroed {C:attention}#1#{} · {C:chips}+#2#{} Chips",
                    "{C:red}#3#{}",
                    "{C:inactive}Florence once banned this number by law.{}",
                },
            },
        },
        Tarot = {
            c_unprv_entropy = {
                name = "Entropy",
                text = {
                    "Your next hand this round:",
                    "High Card {X:mult,C:white}X3{}, Pair {X:mult,C:white}X2{}",
                    "{C:inactive}The universe tends toward disorder. You are no exception.{}",
                },
            },
            c_unprv_fourcolor = {
                name = "Four Color Theorem 1976",
                text = {
                    "Usable when your hand has {C:attention}all four suits{}:",
                    "randomly turn {C:attention}1{} card into a {C:dark_edition}Polychrome{}",
                },
            },
            c_unprv_monty = {
                name = "Monty Hall Problem",
                text = {
                    "Add {C:attention}1{} random card to your hand",
                    "{C:green}50%{} chance to add {C:attention}1{} more",
                    "{C:inactive}Do you switch?{}",
                },
            },
        },
    },
    misc = {
        dictionary = {
            unprv_e_chips = "Chips^e",
            unprv_e_mult = "Mult^e",
            unprv_wlog_title = "Set this card to...",
            unprv_wlog_target = "Pick a rank (2~A)",
            unprv_wlog_hint = "Select a card in hand",
            unprv_wlog_used = "Already used this round",
            unprv_wlog_done = "Set to",
            unprv_wlog_cancel = "Cancel",
            unprv_wlog_canceled = "Cancelled",
            unprv_calabiyau_v0 = "+100 Chips",
            unprv_calabiyau_v1 = "+20 Mult",
            unprv_calabiyau_v2 = "X2 Mult",
            unprv_calabiyau_v3 = "+$8",
            unprv_zero_done = "Made it nonexistent",
            unprv_zero_already = "Already nonexistent",
            unprv_entropy_pending = "Entropy building",
        },
    },
}
