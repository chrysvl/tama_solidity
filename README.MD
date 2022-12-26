
# Tama
Smart Contract for a simple tamagochi app.

Tama Attributes

<img width="252" alt="Screen Shot 2022-12-26 at 14 49 48" src="https://user-images.githubusercontent.com/42406957/209520642-b87aae1d-a0c5-4dc2-8ec0-3f3e28f5b09a.png">

Market (Tama <> Price in ETH)

<img width="256" alt="Screen Shot 2022-12-26 at 14 49 29" src="https://user-images.githubusercontent.com/42406957/209520653-1bda200c-1a89-4d47-9b0b-e928c387bba4.png">

Tama Diary(History Log)

<img width="252" alt="Screen Shot 2022-12-26 at 14 50 54" src="https://user-images.githubusercontent.com/42406957/209520786-fd27c610-b3a8-4de5-a80f-375a7c6dbc38.png">


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
