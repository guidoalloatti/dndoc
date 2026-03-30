module ItemsHelper
  def sort_link(column, title)
    col = column.to_s
    current = params[:sort] == col
    next_dir = if current && params[:dir] == "asc"
                 "desc"
               elsif current && params[:dir] == "desc"
                 nil # third click removes sort
               else
                 "asc"
               end

    icon = if current && params[:dir] == "asc"
             "bi-sort-up"
           elsif current && params[:dir] == "desc"
             "bi-sort-down"
           else
             "bi-arrow-down-up opacity-25"
           end

    new_params = request.params.except("controller", "action")
    if next_dir
      new_params = new_params.merge("sort" => col, "dir" => next_dir)
    else
      new_params = new_params.except("sort", "dir")
    end

    css = current ? "text-decoration-none text-primary fw-semibold" : "text-decoration-none text-muted"

    link_to new_params, class: css do
      "#{title} <i class=\"bi #{icon} small\"></i>".html_safe
    end
  end

  def category_icon(name)
    {
      "Ammunition" => "bullseye",
      "Amulets" => "gem",
      "Armor" => "shield-shaded",
      "Artifacts" => "trophy",
      "Books" => "book",
      "Boots" => "chevron-compact-down",
      "Bracelet" => "circle",
      "Candle" => "brightness-high",
      "Cloak" => "wind",
      "Elixirs" => "droplet-half",
      "Food" => "basket2",
      "Gems" => "diamond",
      "Gloves" => "hand-index-thumb",
      "Helms" => "shield",
      "Horns" => "megaphone",
      "Miscellaneous" => "box-seam",
      "Potent Ingredients" => "flower1",
      "Potions" => "cup-hot",
      "Rings" => "record-circle",
      "Scrolls" => "file-earmark-text",
      "Shields" => "shield-fill",
      "Staffs" => "slash-lg",
      "Tools" => "wrench-adjustable",
      "Trinkets" => "puzzle",
      "Wands" => "magic",
      "Weapons" => "hammer"
    }.fetch(name, "question-circle")
  end

  def armor_icon(armor)
    case armor.armor_type
    when "Light"   then "person"
    when "Medium"  then "shield-half"
    when "Heavy"   then "shield-fill"
    when "Shield"  then "shield-check"
    else "shield"
    end
  end

  def weapon_icon(name)
    icons = {
      "Club" => "tree",
      "Dagger" => "slash-lg",
      "Greatclub" => "tree-fill",
      "Handaxe" => "tools",
      "Javelin" => "arrow-up-right",
      "Light Hammer" => "hammer",
      "Mace" => "record-btn",
      "Quarterstaff" => "slash-lg",
      "Sickle" => "moon",
      "Spear" => "caret-up-fill",
      "Crossbow, light" => "bullseye",
      "Dart" => "arrow-up-right",
      "Shortbow" => "bullseye",
      "Sling" => "circle",
      "Battleaxe" => "tools",
      "Flail" => "link-45deg",
      "Glaive" => "slash-lg",
      "Greataxe" => "tools",
      "Greatsword" => "lightning",
      "Halberd" => "slash-lg",
      "Lance" => "caret-up-fill",
      "Longsword" => "lightning",
      "Maul" => "hammer",
      "Morningstar" => "star-fill",
      "Pike" => "caret-up-fill",
      "Rapier" => "slash-lg",
      "Scimitar" => "slash-lg",
      "Shortsword" => "lightning",
      "Trident" => "caret-up-fill",
      "War Pick" => "tools",
      "Warhammer" => "hammer",
      "Whip" => "dash-lg",
      "Blowgun" => "arrow-up-right",
      "Crossbow, hand" => "bullseye",
      "Crossbow, heavy" => "bullseye",
      "Longbow" => "bullseye",
      "Net" => "grid-3x3"
    }.freeze

    icons[name] || icons.find { |k, _| k.casecmp?(name) }&.last || "hammer"
  end

  def effect_type_icon(type)
    {
      "Attack Bonus"   => "bullseye",
      "Attack Damage"  => "fire",
      "Defense"        => "shield-shaded",
      "Healing"        => "heart-pulse",
      "Material"       => "gem",
      "Stealth"        => "eye-slash",
      "Speed"          => "wind",
      "Protection"     => "shield-check",
      "Resistance"     => "shield-fill-exclamation",
      "Conjuration"    => "stars",
      "Flight"         => "cloud-arrow-up",
      "Frosting"       => "snow",
      "Lightning"      => "lightning-charge",
      "Vision"         => "eye",
      "Luck"           => "dice-5",
      "Control"        => "diagram-3",
      "Minding"        => "brain",
      "Summoning"      => "door-open",
      "Enhance"        => "arrow-up-circle",
      "Utility"        => "wrench-adjustable",
      "Understanding"  => "translate",
      "Absortion"      => "magnet",
      "Buff"           => "arrow-up-circle",
      "Debuff"         => "arrow-down-circle",
      "Damage"         => "fire",
    }.fetch(type, "magic")
  end

  def effect_type_color(type)
    {
      "Attack Bonus"   => "warning",
      "Attack Damage"  => "danger",
      "Defense"        => "secondary",
      "Healing"        => "primary",
      "Material"       => "info",
      "Stealth"        => "dark",
      "Speed"          => "info",
      "Protection"     => "success",
      "Resistance"     => "success",
      "Conjuration"    => "primary",
      "Flight"         => "info",
      "Frosting"       => "info",
      "Lightning"      => "warning",
      "Vision"         => "primary",
      "Luck"           => "warning",
      "Control"        => "danger",
      "Minding"        => "primary",
      "Summoning"      => "primary",
      "Enhance"        => "success",
      "Utility"        => "info",
      "Understanding"  => "primary",
      "Absortion"      => "danger",
      "Buff"           => "success",
      "Debuff"         => "danger",
      "Damage"         => "warning",
    }.fetch(type, "primary")
  end

  def power_badge_class(power)
    case power
    when 0..2  then "bg-secondary"
    when 3..4  then "bg-success"
    when 5..6  then "bg-info"
    when 7..8  then "bg-warning text-dark"
    else            "bg-danger"
    end
  end

  def power_bar_color(power)
    case power
    when 0..2  then "#6c757d"
    when 3..4  then "#198754"
    when 5..6  then "#0dcaf0"
    when 7..8  then "#ffc107"
    else            "#dc3545"
    end
  end

  def rarity_css_class(name)
    {
      "Common" => "common",
      "Uncommon" => "uncommon",
      "Rare" => "rare",
      "Very Rare" => "very-rare",
      "Legendary" => "legendary",
      "Ancestral" => "ancestral"
    }.fetch(name, "common")
  end

  def rarity_badge_class(name)
    {
      "Common" => "bg-secondary",
      "Uncommon" => "bg-success",
      "Rare" => "bg-info",
      "Very Rare" => "bg-primary",
      "Legendary" => "bg-warning text-dark",
      "Ancestral" => "bg-danger"
    }.fetch(name, "bg-secondary")
  end
end
