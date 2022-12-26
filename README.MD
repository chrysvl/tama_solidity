
# Tama
Smart Contract for a simple tamagochi app.

## Features
#### Tama
- As a Tama, I can get EXP Point from getting feed
- As a Tama, I can only eat once in 1 minutes
- As a Tama, I can get EXP Point from training
- As a Tama, I can only train once in 5 minutes
- As a Tama, I can level up from EXP points I get
- As a Tama, I will have new owner when I'm bought in the market
- As a Tama, I will write diary when I do activity

#### All User
- As a user, I can create Tama
- As a user, I can get Tama detail
- As a user, I can browse Tama Market
- As a user, I can buy Tama in the Market

#### Tama Owner
- As an owner, I can feed my Tama
- As an owner, I can train my Tama
- As an owner, I can buy EXP for my Tama
- As an owner, I can kill my Tama
- As an owner, I can list my Tama to Market (in ETH)
- As an owner, I can cancel listing my Tama from Market
- As an owner, I can check my Tama Diary (history log)

#### Admin/Initiator
- As an admin, I can give bonus EXP to all Tama registered

---

#### EXP & Leveling System

Formula : `Level = (25 + √(625 + 100 * EXP)) / 50`

EXP Table
| Level | Total EXP    |
| :---:   | :---: |
| 1 | 0   |
| 2 | 50   |
| 3 | 150   |
| 4 | 300   |
| 5 | 500   |
| ... | ...   |

#### Values of Parameter
| Case | Input Example    |
| :---:   | :---: |
| createTama | Tamago   |
| feedTama | Tamago   |
| trainTama | Tamago   |
| listInETH | Tamago,3   |
| buyEXP | Tamago   |
| giveBonus | 100 (EXP)   |
| getTama | Tamago   |
