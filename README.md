# D&D Doc - Dungeons & Dragons Item Generator & Manager

A web application for generating and managing magical items for Dungeons & Dragons campaigns. Create items manually or let the system generate randomized magical items with effects, rarities, and proper D&D-style naming.

## Features

- **Random Item Generation** - Generate magical items with randomized properties based on power level and category
- **Item Management** - Full CRUD for items with attributes like power, weight, price, and attunement requirements
- **Effect System** - Manage magical effects (attack bonuses, defense, healing, etc.) that can be applied to items
- **Category System** - 26+ item categories (Weapons, Armor, Potions, Rings, Scrolls, Wands, etc.)
- **Rarity System** - 6 tiers from Common to Ancestral, each with associated power and price ranges
- **Weapon Database** - 38+ pre-seeded D&D weapons with damage, weight, and properties
- **Power Level Tracking** - Real-time power budget management when creating items
- **Dynamic Name Generation** - Automatically generates D&D-style names (e.g., "Legendary Longsword of Fire")

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Ruby 3.3.0 |
| **Framework** | Rails 7.2.1 |
| **Database** | PostgreSQL 9.3+ |
| **Web Server** | Puma |
| **Frontend** | Bootstrap 5.3, Stimulus.js (Hotwire), jQuery 3.7.1 |
| **Assets** | Webpacker 5.4.4, Sprockets, ImportMap |
| **CSS** | SCSS (sass-rails) |
| **Testing** | Minitest, Capybara, Selenium WebDriver |
| **Security** | Brakeman (static analysis) |
| **Linting** | RuboCop (Rails Omakase) |
| **Deployment** | Docker |

## Getting Started

### Prerequisites

- Ruby 3.3.0
- PostgreSQL 9.3+
- Node.js and npm/yarn

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd dndoc

# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
npm install
# or
yarn install

# Create and setup the database
rails db:create
rails db:migrate
rails db:seed

# Start the server
rails server
```

The application will be available at `http://localhost:3000`.

### Docker

```bash
docker build -t dndoc .
docker run -p 3000:3000 -e DNDOC_DATABASE_PASSWORD=your_password dndoc
```

## Database Schema

```
items ──────────┐
  belongs_to category
  belongs_to rarity
  has_many effects (through item_effects)

categories ─────┐
  has_many items
  has_and_belongs_to_many effects

effects ────────┐
  has_many items (through item_effects)
  has_and_belongs_to_many categories

rarities ───────┐
  has_many items

weapons ────────── (standalone)

item_effects ───── (join table: items <-> effects)
categories_effects ── (join table: categories <-> effects)
```

## Item Generation Algorithm

1. Select a category (or random)
2. Set a power level (0-10)
3. System determines rarity based on power
4. For weapon categories, auto-adds attack bonus effects
5. Adds compatible effects from the category until power budget is exhausted
6. Prevents duplicate effect types on the same item
7. Generates a D&D-style name based on rarity, effects, and category
8. Calculates price based on rarity range

## Testing

```bash
# Run all tests
rails test

# Run model tests
rails test test/models

# Run controller tests
rails test test/controllers

# Run system tests
rails test:system
```

## Seeds

The seed file (`db/seeds.rb`) populates the database with:
- 38 D&D weapons (Longsword, Greataxe, Crossbow, etc.)
- 26 item categories (Ammunition, Amulets, Armor, Artifacts, Books, Boots, etc.)
- 6 rarity tiers (Common, Uncommon, Rare, Very Rare, Legendary, Ancestral)
- 100+ magical effects linked to appropriate categories
