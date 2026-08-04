return {
    descriptions = {
        Joker = {
            j_unprv_hailstone = {
                name = "冰雹猜想",
                text = {
                    "每张计分数字牌的{C:attention}3n+1{}序列",
                    "每走 {C:attention}1{} 步，{C:mult}+1{} 倍率",
                    "{C:inactive}同手牌计分 2 与 7 时，{X:mult,C:white}X2.7{C:inactive} 倍率{}",
                },
            },
            j_unprv_pythagoras = {
                name = "毕达哥拉斯",
                text = {
                    "每张{C:attention}计分牌{}获得",
                    "{C:chips}+点数²{}筹码（A²=196、K²=169…）",
                    "如 5²=25、7²=49",
                    "{C:inactive}万物皆数。{}",
                },
            },
            j_unprv_riemann = {
                name = "黎曼",
                text = {
                    "每手牌结束后，按本手牌张数",
                    "{C:mult}+#1#{} 倍率/张（黎曼和：积分累加）",
                    "{C:inactive}ζ(s) 的非平凡零点都在临界线上。{}",
                },
            },
            j_unprv_poincare = {
                name = "庞加莱",
                text = {
                    "打出 {C:attention}3{} 张牌时：{C:mult}+#1#{} 倍率",
                    "{C:inactive}佩雷尔曼在场时改为 {X:mult,C:white}X#2#{}（猜想已被证明）{}",
                },
            },
            j_unprv_godel = {
                name = "哥德尔",
                text = {
                    "每手牌结束 {C:mult}+#1#{} 倍率",
                    "累计倍率首次超过 {C:attention}#2#{} 时 {X:mult,C:white}X2{}",
                    "{C:inactive}本语句不可证明。{}",
                },
            },
            j_unprv_hilbert = {
                name = "希尔伯特旅馆",
                text = {
                    "手牌上限 {C:attention}+#1#{}",
                    "回合结束手牌{C:attention}恰好满员{}时，随机{C:attention}1{}张手牌获得",
                    "{C:dark_edition}随机版本{}（闪箔/全息/多彩）",
                    "{C:inactive}旅馆永远满员，永远有房间。{}",
                },
            },
            j_unprv_fields = {
                name = "菲尔兹奖",
                text = {
                    "每有 {C:attention}1{} 张数学家小丑：",
                    "{C:mult}+#1#{} 倍率、{C:chips}+#2#{} 筹码",
                    "回合结束每张{C:money}+$1{}",
                    "当前数学家 {C:attention}#3#{}",
                    "{C:inactive}数学界的最高荣誉。{}",
                },
            },
            j_unprv_goldbach = {
                name = "哥德巴赫猜想",
                text = {
                    "若打出的牌中两张{C:attention}质数牌{}之和",
                    "等于另一张{C:attention}偶数牌{}：{X:mult,C:white}X#1#{}",
                    "{C:inactive}质数：2/3/5/7/J · 偶数：4/6/8/10/Q/A{}",
                    "{C:inactive}每个大于 2 的偶数，都是两个质数的相遇{}",
                },
            },
            j_unprv_catalan = {
                name = "卡塔兰猜想",
                text = {
                    "打出的牌同时含 {C:attention}8{} 和 {C:attention}9{}",
                    "：{X:mult,C:white}X4{} 倍率",
                    "{C:inactive}2³ 和 3²，全世界仅此一对{}",
                },
            },
            j_unprv_margin = {
                name = "页边太窄",
                text = {
                    "我有一个绝妙的证明，",
                    "但页边太窄，写不下。",
                },
            },
            j_unprv_galois = {
                name = "决斗前夜",
                text = {
                    "仅剩 {C:attention}1{} 次出牌机会时",
                    "本手牌 {X:mult,C:white}X3{} 倍率",
                    "{C:inactive}我没有时间了。{}",
                },
            },
            j_unprv_zhang = {
                name = "蛰伏七年",
                text = {
                    "蛰伏 {C:attention}#1#/#2#{} 回合，无任何效果",
                    "期满后：获得 {C:attention}#3#{} 张{C:dark_edition}负片{}传奇小丑",
                    "与 {C:attention}#4#{} 张{C:dark_edition}负片{}消耗牌（仅一次）",
                    "{C:inactive}七年没有一篇论文，然后是一篇震动世界的{}",
                },
            },
            j_unprv_zhang_awake = {
                name = "蛰伏七年",
                text = {
                    "{C:attention}蛰伏结束{}：回报已一次性发放",
                    "此卡不再生效，可出售",
                    "{C:inactive}七年没有一篇论文，然后是一篇震动世界的{}",
                },
            },
            j_unprv_perelman = {
                name = "拒领百万",
                text = {
                    "{C:attention}无法出售{}",
                    "利息与跳过的盲注奖励被拒领：",
                    "每 {C:money}$1{} → {C:mult}+2{} 倍率",
                    "累计少吃 {C:money}$100{} → {X:mult,C:white}X10000{}",
                    "已少吃 {C:money}$#1#{} · {C:mult}+#2#{} 倍率",
                    "{C:inactive}我不需要被承认{}",
                },
            },
            j_unprv_zuratio = {
                name = "密率",
                text = {
                    "打出的牌同时含 {C:attention}3{}、{C:attention}5{}、{C:attention}A{}",
                    "{X:mult,C:white}X1.5{} 倍率",
                    "{C:inactive}355/113，领先世界千年{}",
                },
            },
            j_unprv_calabiyau = {
                name = "卡拉比-丘流形",
                text = {
                    "每回合輪換一個「視角」：",
                    "{C:chips}+100{} 籌碼 → {C:mult}+20{} 倍率 → {X:mult,C:white}X2{} 倍率 → {C:money}+$8{}",
                    "當前視角：#1#",
                    "「落花人獨立，微雨燕雙飛。」",
                },
            },
            j_unprv_maxwell = {
                name = "麦克斯韦妖",
                text = {
                    "{C:attention}5{} 张计分牌点数严格单调",
                    "（递增或递减）：{X:mult,C:white}X4{} 倍率",
                    "{C:inactive}它坐在门边，只放快的过去{}",
                },
            },
            j_unprv_heatdeath = {
                name = "热寂",
                text = {
                    "每回合首次出牌获得",
                    "{X:mult,C:white}X4{} ~ {X:mult,C:white}X12{} 随机倍率",
                    "之后每次出牌减半（最低 {X:mult,C:white}X1{}）",
                    "{C:inactive}所有温差终将消失{}",
                },
            },
            j_unprv_shannon = {
                name = "香农熵",
                text = {
                    "打出的牌中每种",
                    "{C:attention}不同点数{}：{C:mult}+6{} 倍率",
                    "{C:inactive}信息量，就是意外的程度{}",
                },
            },
            j_unprv_binary = {
                name = "二进制",
                text = {
                    "计分{C:attention}偶数{}牌：筹码 {C:attention}×2{}（左移一位）",
                    "计分{C:attention}奇数{}牌：{C:mult}+1{} 倍率",
                    "{C:inactive}万物皆比特{}",
                },
            },
            j_unprv_notice = {
                name = "注意到……",
                text = {
                    "每回合随机“注意到” {C:attention}1{} 张手牌",
                    "该牌本回合计分 {X:mult,C:white}X2{}",
                    "{C:inactive}注意到：这张牌能赢{}",
                },
            },
            j_unprv_wlog = {
                name = "不妨设",
                text = {
                    "每回合一次：{C:attention}点击本卡{}，再点击",
                    "一张手牌，将其点数{C:attention}设{}为任意值",
                    "{C:inactive}不妨设这张是 K{}",
                    "{C:red}#1#{}",
                },
            },
            j_unprv_symmetry = {
                name = "由对称性",
                text = {
                    "打出的牌呈{C:attention}回文{}排列",
                    "（如 5、8、3、8、5）：{X:mult,C:white}X2{} 倍率",
                    "{C:inactive}由对称性，显然成立{}",
                },
            },
            j_unprv_oneten = {
                name = "1+1=10",
                text = {
                    "打出的牌含 {C:attention}两张以上 A{} 时",
                    "每张 A：{C:chips}+10{} 筹码",
                    "{C:inactive}世界上有 10 种人：懂二进制的和不懂的{}",
                },
            },
            j_unprv_nines = {
                name = "0.999…=1",
                text = {
                    "打出的牌全部是 {C:attention}9{}：{C:chips}+10{} 筹码",
                    "{C:inactive}这是定理，不服憋着{}",
                },
            },
            j_unprv_montecarlo = {
                name = "蒙特卡洛方法",
                text = {
                    "每手牌随机撒点估算 {C:attention}π{}",
                    "估值越准，倍率越高（最高 {X:mult,C:white}X3{}）",
                    "{C:inactive}在赌场算 π，专业对口{}",
                },
            },
            j_unprv_seventythree = {
                name = "73",
                text = {
                    "打出的牌同时含 {C:attention}7{} 和 {C:attention}3{}",
                    "{X:mult,C:white}X4.73{} 倍率",
                    "{C:inactive}73 是最好的数字{}",
                },
            },
            j_unprv_oddeven = {
                name = "奇变偶不变",
                text = {
                    "每回合第一手牌最多 {C:attention}3{} 张奇数",
                    "永久 {C:attention}+1{} 变偶（牌堆有奇数则必抽到）",
                    "每转换 1 张牌，出售价 {C:money}+$#1#{}",
                    "{C:inactive}……符号看象限{}",
                },
            },
            j_unprv_euler = {
                name = "e",
                text = {
                    "出牌时以 {C:attention}e/出牌数{} 的概率",
                    "将{C:chips}筹码{}或{C:mult}倍率{}取 {C:attention}e{} 次幂",
                    "再乘以{C:attention}出牌数{}",
                    "{C:inactive}含 2/7/A/8 必触发；连续 3 手得分递增 + $27 利息后入店{}",
                    "{C:inactive}lim(1+1/n)ⁿ，n 越大，越接近神{}",
                },
            },
            j_unprv_zero = {
                name = "零",
                text = {
                    "每回合一次：{C:attention}点击本卡{}再点击手牌",
                    "令其不存在：牌型判定中视为{C:attention}任意点数{}",
                    "每零化一张永久 {C:chips}+25{} 筹码",
                    "已零化 {C:attention}#1#{} 张 · {C:chips}+#2#{} 筹码",
                    "{C:red}#3#{}",
                    "{C:inactive}佛罗伦萨曾立法禁用这个数字{}",
                },
            },
            j_unprv_wheat = {
                name = "棋盘麦粒",
                text = {
                    "{C:mult}+1{} 倍率，每回合{C:attention}翻倍{}",
                    "达到 {C:attention}64{} 时被国库没收：{C:money}+$64{}",
                    "{C:inactive}国王以为自己占了便宜{}",
                },
            },
            j_unprv_kaprekar = {
                name = "数字黑洞 6174",
                text = {
                    "{C:attention}4{} 张计分牌重排之差 ÷100",
                    "转为{C:chips}筹码{}",
                    "打出 6、1、7、4：{X:mult,C:white}X6.174{}",
                    "{C:inactive}所有四位数都逃不进来{}",
                },
            },
            j_unprv_phi = {
                name = "φ · 黄金分割",
                text = {
                    "打出的牌含{C:attention}斐波那契{}连续两项",
                    "（1,2 / 2,3 / 3,5 / 5,8）：{X:mult,C:white}X1.618{}",
                },
            },
            j_unprv_seven77 = {
                name = "777",
                text = {
                    "打出的牌含 {C:attention}三张以上 7{}",
                    "{X:mult,C:white}X7.77{} 且 {C:money}+$7{}",
                    "{C:inactive}老虎机的圣音{}",
                },
            },
            j_unprv_point24 = {
                name = "24 点",
                text = {
                    "打出的 {C:attention}4{} 张牌能用 +−×÷",
                    "算出 {C:attention}24{}：{X:mult,C:white}X2.4{} 倍率",
                    "{C:inactive}头不用拍，口算就行{}",
                },
            },
            j_unprv_pareto = {
                name = "二八定律",
                text = {
                    "本手牌只打出 {C:attention}1{} 张牌",
                    "{X:mult,C:white}X4{} 倍率",
                    "{C:inactive}20% 的牌，干了 80% 的活{}",
                },
            },
            j_unprv_centrallimit = {
                name = "中心极限定理",
                text = {
                    "点数越接近{C:attention}均值 7{} 奖励越高",
                    "7：+8 · 6/8：+6 · 5/9：+4 · 4/10：+2 倍率",
                    "{C:inactive}样本多了，世界就是一口钟{}",
                },
            },
            j_unprv_ramanujan = {
                name = "1729",
                text = {
                    "打出的牌含 {C:attention}1、7、2、9{}",
                    "{X:mult,C:white}X17.29{} 倍率",
                    "{C:inactive}出租车数：两种立方和的相遇{}",
                },
            },
            j_unprv_euler_identity = {
                name = "欧拉恒等式",
                text = {
                    "每张计分 {C:attention}3{}(π)：{X:mult,C:white}X#1#{}",
                    "场上持有 e：{X:mult,C:white}X#2#{}（e^π）",
                    "{C:inactive}e + 3 + A = e^{iπ}+1=0：{X:mult,C:white}X#3#{}",
                },
            },
            j_unprv_margin_proven = {
                name = "页边太窄",
                text = {
                    "计分牌含{C:attention}勾股数{}(如 3、4、5)：",
                    "{X:mult,C:white}X#1#{} 倍率",
                    "{C:inactive}怀尔斯证明了它：a²+b²=c²{}",
                },
            },
            j_unprv_wiles = {
                name = "怀尔斯",
                text = {
                    "计分牌含{C:attention}勾股数{}(3,4,5 等)：",
                    "{X:mult,C:white}X2{} 倍率",
                    "{C:inactive}费马说写不下，怀尔斯写了 108 页。{}",
                },
            },
            j_unprv_g2inbox = {
                name = "G2 in box",
                text = {
                    "若打出的牌可解{C:attention}鸡兔同笼{}：",
                    "头数=牌数，脚数=点数总和{C:attention}(A=1){}",
                    "兔=(脚−2头)/2：每只兔 {X:mult,C:white}X(1+兔){}",
                    "每只鸡 {C:chips}+#1#{} 筹码",
                    "{C:inactive}G 谐音鸡、2 念 two、in box 是笼子{}",
                },
            },
            j_unprv_chen = {
                name = "陈景润 1+2",
                text = {
                    "持有{C:attention}哥德巴赫猜想{}时：",
                    "其效果升至 {X:mult,C:white}X#3#{}，本卡 {X:mult,C:white}X#1#{}",
                    "且每手牌塞入 {C:attention}1{} 张{C:attention}质数牌{}",
                    "{C:inactive}未持有：{C:mult}+#2#{} 倍率（还在证）{}",
                    "{C:inactive}他把 1+2 证出来了，把 1+1 留给了后来人{}",
                },
            },
            j_unprv_gauss = {
                name = "高斯求和",
                text = {
                    "打出的牌含 {C:attention}A、2、3、4、5{}",
                    "（1+2+3+4+5=15）：",
                    "{C:chips}+#1#{} 筹码，且 {X:mult,C:white}X#2#{} 倍率",
                    "{C:inactive}老师问 1 加到 100，高斯十岁就算完了{}",
                },
            },
        },
        Tarot = {
            c_unprv_monty = {
                name = "蒙提霍尔问题",
                text = {
                    "获得 {C:attention}1{} 张随机牌",
                    "{C:green}50%{} 概率再获得 {C:attention}1{} 张",
                    "{C:inactive}你换门了吗？{}",
                },
            },
            c_unprv_entropy = {
                name = "熵增",
                text = {
                    "本回合下一手牌：",
                    "高牌 {X:mult,C:white}X3{}，对子 {X:mult,C:white}X2{}",
                    "{C:inactive}宇宙趋向无序，你也不例外{}",
                },
            },
            c_unprv_fourcolor = {
                name = "四色定理 1976",
                text = {
                    "手牌集齐{C:attention}四花色{}时可用：",
                    "随机 {C:attention}1{} 张牌变为{C:dark_edition}多彩版{}",
                },
            },
        },
        Spectral = {
            c_unprv_banach = {
                name = "巴拿赫-塔斯基悖论",
                text = {
                    "销毁 {C:attention}1{} 张手牌",
                    "加入 {C:attention}2{} 张它的完全复制",
                    "{C:inactive}体积不守恒，直觉不作数{}",
                },
            },
            c_unprv_russell = {
                name = "罗素的信",
                text = {
                    "指定 {C:attention}1{} 个小丑失效 {C:attention}1{} 回合",
                    "下一手牌 {X:mult,C:white}X2{} 倍率",
                    "{C:inactive}亲爱的弗雷格，很遗憾地通知您……{}",
                },
            },
        },
        Blind = {
            bl_unprv_konigsberg = {
                name = "七桥问题",
                text = {
                    "每种花色本回合",
                    "只能计分一次",
                },
            },
        },
        Other = {
            p_unprv_mathpack = {
                name = "数学小丑包",
                text = {
                    "从最多{C:attention}#2#张{C:joker}数学小丑{}中",
                    "选择{C:attention}#1#{}张",
                },
            },
            p_unprv_mega_mathpack = {
                name = "超级数学小丑包",
                text = {
                    "从最多{C:attention}#2#张{C:joker}数学小丑{}中",
                    "选择{C:attention}#1#{}张",
                },
            },
        },
        Edition = {
            e_unprv_dual = {
                name = "对偶",
                text = {
                    "{C:chips}+筹码{} 与 {C:mult}+倍率{}",
                    "效果互换",
                    "{C:inactive}谁规定筹码不能是倍率？{}",
                },
            },
        },
    },
    misc = {
        challenge_names = {
            c_unprv_tour = "未证之旅",
        },
        v_text = {
            ch_c_unprv_tour_start = {
                "开局：{C:attention}菲尔兹奖{} + {C:attention}3{} 张随机负片数学家",
            },
            ch_c_unprv_tour_explore = {
                "其余数学内容请在{C:attention}商店{}与{C:attention}Boss 盲注{}中探索",
            },
        },
        dictionary = {
            k_unprv_conjecturer = "猜想者",
            k_unprv_paradox = "悖论",
            k_unprv_counterintuitive = "反直觉",
            unprv_e_chips = "筹码^e",
            unprv_e_mult = "倍率^e",
            unprv_wlog_title = "将这张牌设为……",
            unprv_wlog_target = "点选点数（2~A）",
            unprv_wlog_hint = "选择一张手牌",
            unprv_wlog_used = "本回合已使用",
            unprv_wlog_done = "已设为",
            unprv_wlog_cancel = "取消",
            unprv_wlog_canceled = "已取消",
            unprv_calabiyau_v0 = "+100 籌碼",
            unprv_calabiyau_v1 = "+20 倍率",
            unprv_calabiyau_v2 = "X2 倍率",
            unprv_calabiyau_v3 = "+$8",
            unprv_zero_done = "已令其不存在",
            unprv_zero_already = "这张牌已不存在",
            unprv_entropy_pending = "熵增蓄势",
            unprv_russell_pending = "信已寄出，逻辑被击穿",
            k_booster_group_p_unprv_mathpack = "数学小丑包",
            k_booster_group_p_unprv_mega_mathpack = "超级数学小丑包",
        },
    },
}
