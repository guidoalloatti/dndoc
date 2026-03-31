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

  # Returns an <img> tag if the category has an uploaded image,
  # otherwise a styled placeholder div with the category icon.
  def category_image_or_placeholder(category, opts = {})
    size   = opts.fetch(:size, 80)
    klass  = opts.fetch(:class, "")
    style  = opts.fetch(:style, "")

    if category&.image&.attached?
      image_tag category.image,
        class: "category-img #{klass}",
        style: "width:#{size}px;height:#{size}px;object-fit:cover;border-radius:12px;#{style}"
    else
      icon  = category_icon(category&.name.to_s)
      color = category_placeholder_color(category&.name.to_s)
      content_tag :div,
        content_tag(:i, "", class: "bi bi-#{icon}"),
        class: "category-img-placeholder #{klass}",
        style: "width:#{size}px;height:#{size}px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:#{size * 0.4}px;#{color}#{style}"
    end
  end

  def category_placeholder_color(name)
    palette = {
      "Weapons"             => "background:linear-gradient(135deg,#dc354522,#dc354511);color:#dc3545;",
      "Armor"               => "background:linear-gradient(135deg,#0d6efd22,#0d6efd11);color:#0d6efd;",
      "Shields"             => "background:linear-gradient(135deg,#0d6efd22,#0d6efd11);color:#0d6efd;",
      "Potions"             => "background:linear-gradient(135deg,#19875422,#19875411);color:#198754;",
      "Elixirs"             => "background:linear-gradient(135deg,#19875422,#19875411);color:#198754;",
      "Scrolls"             => "background:linear-gradient(135deg,#6f42c122,#6f42c111);color:#6f42c1;",
      "Books"               => "background:linear-gradient(135deg,#6f42c122,#6f42c111);color:#6f42c1;",
      "Rings"               => "background:linear-gradient(135deg,#ffc10722,#ffc10711);color:#b08800;",
      "Amulets"             => "background:linear-gradient(135deg,#ffc10722,#ffc10711);color:#b08800;",
      "Gems"                => "background:linear-gradient(135deg,#0dcaf022,#0dcaf011);color:#0aa2ba;",
      "Wands"               => "background:linear-gradient(135deg,#6f42c122,#6f42c111);color:#6f42c1;",
      "Staffs"              => "background:linear-gradient(135deg,#6f42c122,#6f42c111);color:#6f42c1;",
      "Artifacts"           => "background:linear-gradient(135deg,#fd7e1422,#fd7e1411);color:#fd7e14;",
      "Trinkets"            => "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;",
      "Miscellaneous"       => "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;",
      "Boots"               => "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;",
      "Gloves"              => "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;",
      "Helms"               => "background:linear-gradient(135deg,#0d6efd22,#0d6efd11);color:#0d6efd;",
      "Cloak"               => "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;",
      "Tools"               => "background:linear-gradient(135deg,#19875422,#19875411);color:#198754;",
      "Ammunition"          => "background:linear-gradient(135deg,#dc354522,#dc354511);color:#dc3545;",
      "Food"                => "background:linear-gradient(135deg,#19875422,#19875411);color:#198754;",
      "Candle"              => "background:linear-gradient(135deg,#ffc10722,#ffc10711);color:#b08800;",
      "Horns"               => "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;",
      "Bracelet"            => "background:linear-gradient(135deg,#ffc10722,#ffc10711);color:#b08800;",
      "Potent Ingredients"  => "background:linear-gradient(135deg,#19875422,#19875411);color:#198754;",
    }
    palette[name] || "background:linear-gradient(135deg,#6c757d22,#6c757d11);color:#6c757d;"
  end

  def origin_icon(origin)
    {
      "Divino"      => "brightness-high-fill",
      "Elfico"      => "tree-fill",
      "Enano"       => "hammer",
      "Humano"      => "person-fill",
      "Desconocido" => "question-circle"
    }.fetch(origin, "question-circle")
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
