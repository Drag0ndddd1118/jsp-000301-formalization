# The Justin Sun Prize (孙宇晨奖) - Lean 4 Formal Proofs

本仓库位于外置存储设备 `/Volumes/Drag0ndddd/JustinSunPrize_Proofs/`，用于存放孙宇晨数学奖（The Justin Sun Prize）中高可行性题目的 Lean 4 形式化代码、定理证明与提报材料。

---

## 一、 环境配置与安装记录

1. **安装 Lean 4 版本管理器 (elan)**：
   ```bash
   curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
   ```
2. **配置环境变量**：
   ```bash
   export PATH="$HOME/.elan/bin:$PATH"
   ```
3. **已安装版本**：
   - **Lean**：v4.34.0 (arm64-apple-darwin, Release)
   - **Lake**：v5.0.0 (Lake 构建与包管理工具)
   - **Mathlib**：已在工程目录 `jsp_proofs` 中集成，支持 Mathlib 庞大定理库与 `cache` 预编译二进制。

---

## 二、 首个攻克与完成验证的题目：JSP-000301

### 1. 题目背景
* **题目编号**：`JSP-000301`
* **数学领域**：数论 / 强大数（Number theory / Powerful numbers）
* **原题表述**：
  > *If two consecutive positive integers are powerful, must at least one be a perfect square?*
  > （若两个连续正整数都是强大数，其中是否至少有一个是完全平方数？）
* **数学结论**：**已解决（证伪）**。

### 2. 数学反例
根据 Golomb (1970) 的数论经典定义，一个正整数是强大数（powerful number / square-full）当且仅当它可以表示为 $a^2 \cdot b^3$（$a, b \in \mathbb{N}^+$）。

反例为：
* $n = 12167 = 23^3 = 1^2 \times 23^3$（强大数）
* $n + 1 = 12168 = 2^3 \times 3^2 \times 13^2 = 39^2 \times 2^3$（强大数）
* $110^2 = 12100 < 12167 < 12168 < 12321 = 111^2$
因此，12167 与 12168 是两个连续正整数且均为强大数，但**两者都不是完全平方数**。原猜想被严格否定。

---

## 三、 Lean 4 证明代码与检验

完整独立证明源码位于：[`JSP_000301.lean`](./JSP_000301.lean)

### 核心定义与定理：
1. `IsPowerful (n : Nat) : Prop := ∃ a b : Nat, a > 0 ∧ b > 0 ∧ n = a^2 * b^3`
2. `IsSquare (n : Nat) : Prop := ∃ k : Nat, n = k^2`
3. `powerful_12167 : IsPowerful 12167`（证毕）
4. `powerful_12168 : IsPowerful 12168`（证毕）
5. `not_square_12167 : ¬ IsSquare 12167`（通过 `omega` 与区间夹逼证毕）
6. `not_square_12168 : ¬ IsSquare 12168`（通过 `omega` 与区间夹逼证毕）
7. **最终核心否定定理**：
   ```lean
   theorem disproof_conjecture :
       ¬ (∀ n : Nat, IsPowerful n → IsPowerful (n + 1) → (IsSquare n ∨ IsSquare (n + 1)))
   ```

### 机器自动化核验命令：
在外置盘执行：
```bash
export PATH="$HOME/.elan/bin:$PATH"
lean /Volumes/Drag0ndddd/JustinSunPrize_Proofs/JSP_000301.lean
```
**核验结果**：`Exit code 0`，0 警告、0 错误、无任何 `sorry` 占位符、无未经审查的公理，完全通过 Lean 4 严格内核校验！

---

## 四、 奖金提报操作指南

1. **Fork 官方仓库**：
   访问 [github.com/TheJustinSunPrize/awards](https://github.com/TheJustinSunPrize/awards) 并 Fork。
2. **提交 Pull Request**：
   - 目标文件：`problems/catalog-0301-0400.md`
   - 将 `JSP-000301` 行的 `Lean proof` 从 `No` 更新为 `Yes` 并附上本代码仓库/提交哈希；
   - 将 `Eligible to claim` 从 `No` 改为 `Yes`；
   - 附上机器验证构建记录。
3. **申报形式化者（Formalizer）身份**：
   根据孙宇晨奖《Evaluation Rules》，你将作为 Formalizer 参与该题目 30% 奖金的评定与划拨！
