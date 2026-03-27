# CLAUDE.md - Project Guide for Claude Code

## Project Overview

D&D Doc is a Rails 7.2 application for generating and managing Dungeons & Dragons magical items. It features a power-based item generation system with effects, categories, rarities, and weapons.

## Tech Stack

- Ruby 3.3.0, Rails 7.2.1, PostgreSQL
- Frontend: Bootstrap 5.3, Stimulus.js, jQuery, Webpacker
- Testing: Minitest, Capybara

## Common Commands

```bash
# Development
rails server                    # Start dev server on port 3000
rails db:migrate                # Run pending migrations
rails db:seed                   # Seed database (destructive - destroys existing data first)

# Testing
rails test                      # Run all tests
rails test test/models          # Run model tests
rails test test/controllers     # Run controller tests
rails test:system               # Run system tests (requires browser driver)

# Code Quality
bundle exec rubocop             # Run linter
bundle exec brakeman            # Run security scanner

# Assets
rails assets:precompile         # Compile assets for production
```

## Architecture

### Models & Relationships

- **Item** (`belongs_to :category, :rarity; has_many :effects through :item_effects`) - Core entity with name, description, power, weight, price, requires_attunement
- **Category** (`has_many :items; has_and_belongs_to_many :effects`) - 26 item types (Weapons, Armor, Potions, etc.)
- **Effect** (`has_many :items through :item_effects; has_and_belongs_to_many :categories`) - Magical effects with type and power_level
- **Rarity** (`has_many :items`) - 6 tiers (Common→Ancestral) with min/max price and power ranges
- **Weapon** (standalone) - D&D weapon stats (name, cost, damage, weight, properties)
- **ItemEffect** - Join table for items↔effects

### Key Controllers

- **ItemsController** - Most complex controller. Handles CRUD plus random item generation, name generation, and AJAX endpoints (`create_item`, `update_item`, `get_item`, `get_item_name`)
- **EffectsController** - CRUD + `get_effects_by_category` AJAX endpoint
- **RaritiesController** - CRUD + `get_rarities` AJAX endpoint
- Other controllers (Categories, Weapons, Main) are standard CRUD

### Routes

- Root: `main#index`
- Standard resources: `items`, `categories`, `effects`, `rarities`, `weapons`
- Custom item routes: `random_create`, `create_random`, `get_item_name`, `create_item`, `get_item`, `update_item`
- Nested: `items/:id/effects`

### Frontend JavaScript

- Main logic in `app/javascript/controllers/create_objects.js` (Stimulus controller, ~586 lines)
- Handles dynamic form interactions, effect selection, power tracking, name generation
- Uses jQuery AJAX calls to backend endpoints with CSRF token handling

## Database

- PostgreSQL with 7 tables: items, categories, effects, rarities, weapons, item_effects, categories_effects
- Seeds file is destructive (deletes all data before re-seeding)
- Config in `config/database.yml`, production uses `DNDOC_DATABASE_PASSWORD` env var

## Code Conventions

- ERB templates for views
- Bootstrap 5 for styling with SCSS
- Stimulus.js for JavaScript behavior
- Standard Rails MVC patterns
- RuboCop with Rails Omakase style
- Controller actions use `respond_to` with HTML and JSON formats for AJAX endpoints
