let totalPower = 0;
let maxPower = 10;
let selectedEffect = ""
let effectPower = ""
let weaponSelectContainer = ""
let startRarity = 6
const succesNotificationTimeout = 10000
const errorNotificationTimeout = 15000

// Guard against double-init (turbo:load + document.ready both fire on initial page load)
let _coInitCalls = {};
document.addEventListener('turbo:before-visit', function() { _coInitCalls = {}; });

// Power button color map
function powerBtnClass(p) {
  if (p <= 1) return 'btn-secondary';
  if (p <= 3) return 'btn-success';
  if (p <= 5) return 'btn-info';
  if (p <= 7) return 'btn-warning';
  if (p <= 9) return 'btn-danger';
  return 'btn-dark';
}

// Rarity color map
const rarityColors = {
  'Common': { bg: 'btn-outline-secondary', active: 'btn-secondary' },
  'Uncommon': { bg: 'btn-outline-success', active: 'btn-success' },
  'Rare': { bg: 'btn-outline-info', active: 'btn-info' },
  'Very Rare': { bg: 'btn-outline-primary', active: 'btn-primary' },
  'Legendary': { bg: 'btn-outline-warning', active: 'btn-warning' },
  'Ancestral': { bg: 'btn-outline-danger', active: 'btn-danger' }
};

// Effect group map — every known effect_type → group name
const effectGroupMap = {
  // combat
  'Attack': 'combat', 'Attack Bonus': 'combat', 'Attack Damage': 'combat',
  'Assassination': 'combat', 'Cleaving': 'combat', 'Knocking': 'combat',
  'Proning': 'combat', 'Precision': 'combat', 'Ammunition Magic': 'combat',
  // defense
  'Defense': 'defense', 'Defensive': 'defense', 'Protection': 'defense',
  'Resistance': 'defense', 'Immunity': 'defense', 'Absorption': 'defense',
  'Saving Throws': 'defense', 'Durability': 'defense',
  // magic
  'Conjuration': 'magic', 'Summoning': 'magic', 'Control': 'magic',
  'Minding': 'magic', 'Understanding': 'magic', 'Sentient': 'magic',
  'Morality': 'magic', 'Weirdness': 'magic', 'Change': 'magic', 'Eternity': 'magic',
  // movement
  'Speed': 'movement', 'Movement': 'movement', 'Flight': 'movement',
  'Climbing': 'movement', 'Jumping': 'movement', 'Reach': 'movement',
  'Flexibility': 'movement', 'Initiative': 'movement',
  // healing
  'Healing': 'healing', 'Restoration': 'healing', 'Enhance': 'healing',
  'Luck': 'healing', 'Equilibrium': 'healing', 'Sobriety': 'healing',
  // elemental
  'Frosting': 'elemental', 'Lightning': 'elemental', 'Paralyzing': 'elemental',
  'Glow': 'elemental', 'Loudness': 'elemental',
  // senses
  'Detection': 'senses', 'Seeing': 'senses', 'Vision': 'senses',
  'Sense': 'senses', 'Sight': 'senses', 'Traces': 'senses',
  // utility
  'Utility': 'utility', 'Material': 'utility', 'Stealth': 'utility',
  'Strength': 'utility', 'Enlarge': 'utility', 'Goliath': 'utility',
  'Breathing': 'utility', 'Water': 'utility', 'Fishing': 'utility',
  'Locking': 'utility', 'Handling': 'utility', 'Stealing': 'utility',
};

const groupMeta = {
  combat:   { label: 'Combate',   icon: 'bi-sword',         color: 'ec-combat'   },
  defense:  { label: 'Defensa',   icon: 'bi-shield-fill',   color: 'ec-defense'  },
  magic:    { label: 'Magia',     icon: 'bi-stars',         color: 'ec-magic'    },
  movement: { label: 'Movimiento',icon: 'bi-wind',          color: 'ec-movement' },
  healing:  { label: 'Curación',  icon: 'bi-heart-fill',    color: 'ec-healing'  },
  elemental:{ label: 'Elemental', icon: 'bi-lightning-fill',color: 'ec-elemental'},
  senses:   { label: 'Sentidos',  icon: 'bi-eye-fill',      color: 'ec-senses'   },
  utility:  { label: 'Utilidad',  icon: 'bi-tools',         color: 'ec-utility'  },
};

function getEffectGroup(type) {
  return effectGroupMap[type] || 'utility';
}

function getEffectColor(type) {
  return groupMeta[getEffectGroup(type)]?.color || 'ec-utility';
}

function initCreateObjects() {

  // Re-compute path on each navigation (Turbo changes URL without full reload)
  let path = window.location.pathname
  const localeMatch = path.match(/^\/(en|es)/)
  const localePrefix = localeMatch ? "/" + localeMatch[1] : ""

  // Prevent double execution when both document.ready and turbo:load fire on initial load
  _coInitCalls[path] = (_coInitCalls[path] || 0) + 1;
  if (_coInitCalls[path] > 1) return;

  // Reset state
  totalPower = 0;
  maxPower = 10;

  // Unbind previous delegated handlers to prevent double-binding
  $(document).off('.co');

  function replaceUrl(url) {
    window.location.replace(url);
  }

  // Strip locale prefix for path matching
  const cleanPath = localePrefix ? path.replace(localePrefix, '') : path

  if(cleanPath != "/items/new" && !/^\/items\/\d+\/edit$/.test(cleanPath) && cleanPath != "/items/create_random") {
    return;
  }

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  // ── Lore selection ──
  function getSelectedLore() {
    const checked = document.querySelector('.lore-btn:checked');
    if (checked) return checked.dataset.lore;
    const active = document.querySelector('.lore-radio-btn.active');
    return active ? active.querySelector('.lore-btn')?.dataset.lore || 'faerun' : 'faerun';
  }

  $(document).on('change.co', '.lore-btn', function() {
    document.querySelectorAll('.lore-radio-btn').forEach(l => l.classList.remove('active'));
    this.closest('.lore-radio-btn')?.classList.add('active');
  });

  // ── Origin selection ──
  let selectedOrigin = document.getElementById('item_origin')?.value || 'Desconocido';

  const originColors = {
    'Divino':      { bg: 'btn-outline-warning',   active: 'btn-warning'   },
    'Elfico':      { bg: 'btn-outline-success',   active: 'btn-success'   },
    'Enano':       { bg: 'btn-outline-danger',    active: 'btn-danger'    },
    'Humano':      { bg: 'btn-outline-primary',   active: 'btn-primary'   },
    'Desconocido': { bg: 'btn-outline-secondary', active: 'btn-secondary' },
  };

  function getSelectedOrigin() {
    return selectedOrigin;
  }

  function selectOrigin(btn) {
    // Reset all buttons to their origin-specific outline color
    $('.origin-btn').each(function() {
      const o = $(this).data('origin');
      const c = originColors[o] || originColors['Desconocido'];
      $(this).removeClass('active btn-warning btn-success btn-danger btn-primary btn-secondary btn-outline-warning btn-outline-success btn-outline-danger btn-outline-primary btn-outline-secondary');
      $(this).addClass(c.bg);
    });
    // Activate the selected button with its color
    const origin = $(btn).data('origin');
    const colors = originColors[origin] || originColors['Desconocido'];
    $(btn).removeClass(colors.bg).addClass('active ' + colors.active);
    selectedOrigin = origin;
    $('#item_origin').val(origin);
  }

  // Initialize origin picker from hidden field value
  const initialOrigin = document.getElementById('item_origin')?.value || 'Desconocido';
  const initialOriginBtn = $(`.origin-btn[data-origin="${initialOrigin}"]`);
  if (initialOriginBtn.length) selectOrigin(initialOriginBtn[0]);

  $(document).on('click.co', '.origin-btn', function(e) {
    e.preventDefault();
    selectOrigin(this);
  });

  // ── Description ──
  let descriptionLocked = document.getElementById('item_description_locked')?.value === 'true';

  function syncLockBtn() {
    const btn = document.getElementById('lockDescBtn');
    const icon = document.getElementById('lockDescIcon');
    const label = document.getElementById('lockDescLabel');
    const textarea = document.getElementById('item_description_display');
    if (!btn) return;
    if (descriptionLocked) {
      btn.dataset.locked = 'true';
      btn.classList.remove('btn-outline-secondary');
      btn.classList.add('btn-warning');
      if (icon) { icon.classList.remove('bi-unlock'); icon.classList.add('bi-lock-fill'); }
      if (label) label.textContent = btn.dataset.lockedLabel || 'Bloqueada';
      textarea?.classList.add('locked');
      textarea?.setAttribute('readonly', true);
    } else {
      btn.dataset.locked = 'false';
      btn.classList.remove('btn-warning');
      btn.classList.add('btn-outline-secondary');
      if (icon) { icon.classList.remove('bi-lock-fill'); icon.classList.add('bi-unlock'); }
      if (label) label.textContent = btn.dataset.unlockedLabel || 'Libre';
      textarea?.classList.remove('locked');
      textarea?.removeAttribute('readonly');
    }
    const hiddenField = document.getElementById('item_description_locked');
    if (hiddenField) hiddenField.value = descriptionLocked ? 'true' : 'false';
  }

  syncLockBtn();

  $(document).on('click.co', '#lockDescBtn', function(e) {
    e.preventDefault();
    descriptionLocked = !descriptionLocked;
    syncLockBtn();
  });

  $(document).on('click.co', '#rewriteDescBtn', function(e) {
    e.preventDefault();
    const btn = this;
    const category = selectedCategoryId;
    const rarity = $(`.rarity-pill.text-white`).data("name") || "Common";
    const weapon = selectedCategoryName === "Weapons" ? ($(".weapon-btn.active").data("name") || "") : "";
    const effects = [];
    $.each($("#selectedEffects")[0]?.children || [], function(i, li) { effects.push(li.dataset.effectId); });

    $(btn).prop('disabled', true).html('<i class="bi bi-hourglass-split me-1"></i>...');

    $.ajax({
      url: localePrefix + '/items/get_item_description',
      type: 'POST',
      data: { category: category, rarity: rarity, weapon: weapon, effects: effects, lore: getSelectedLore() },
      success: function(response) {
        $('#item_description_display').val(response.data);
        $(btn).prop('disabled', false).html('<i class="bi bi-arrow-repeat me-1"></i>' + (btn.dataset.rewriteLabel || 'Reescribir'));
      },
      error: function() {
        $(btn).prop('disabled', false).html('<i class="bi bi-arrow-repeat me-1"></i>' + (btn.dataset.rewriteLabel || 'Reescribir'));
      }
    });
  });

  // ── Category Picker ──
  let selectedCategoryId = null;
  let selectedCategoryName = null;

  function selectCategory(btn) {
    $(".category-btn").removeClass("active btn-primary").addClass("btn-outline-secondary");
    $(btn).removeClass("btn-outline-secondary").addClass("active btn-primary");
    selectedCategoryId = $(btn).data("id");
    selectedCategoryName = $(btn).data("name");

    if (selectedCategoryName === "Weapons") {
      $("#addWeapons").show();
      $("#noWeaponHint").hide();
      $("#weaponDetails").show();
    } else {
      $("#addWeapons").hide();
      $("#noWeaponHint").show();
    }

    // Divino origin: available for Artifacts category OR when power is 10 (Ancestral)
    const divinoBtn = $('.origin-btn[data-origin="Divino"]');
    if (selectedCategoryName === 'Artifacts' || maxPower === 10) {
      divinoBtn.show();
    } else {
      divinoBtn.hide();
      if (selectedOrigin === 'Divino') selectOrigin($('.origin-btn[data-origin="Desconocido"]')[0]);
    }

    hanldeEffectsByCategory(selectedCategoryName);
  }

  // Auto-select first category on load
  if ($("#categoryPicker .category-btn").length > 0) {
    selectCategory($("#categoryPicker .category-btn").first());
  }

  $(document).on("click.co", ".category-btn", function(e) {
    e.preventDefault();
    selectCategory(this);
  });

  // ── Weapon Picker ──
  $(document).on("click.co", ".weapon-btn", function(e) {
    e.preventDefault();
    $(".weapon-btn").removeClass("active btn-primary").addClass("btn-outline-secondary");
    $(this).removeClass("btn-outline-secondary").addClass("active btn-primary");
    const damage = $(this).data("damage");
    const cost = $(this).data("cost");
    if (damage || cost) {
      $("#weaponDamage").text(damage);
      $("#weaponCost").text(cost);
      $("#weaponDetails").show();
    }
  });

  // Auto-select first weapon and show details on load
  if ($("#weaponPicker .weapon-btn.active").length > 0) {
    const firstWeapon = $("#weaponPicker .weapon-btn.active");
    const damage = firstWeapon.data("damage");
    const cost = firstWeapon.data("cost");
    if (damage || cost) {
      $("#weaponDamage").text(damage);
      $("#weaponCost").text(cost);
    }
  }

  // ── Rarity Picker (pills) ──
  let selectedRarityId = null;
  let allRarities = [];

  function selectRarity(btn) {
    // Reset all rarity pills
    $(".rarity-pill").each(function() {
      const name = $(this).data("name");
      const colors = rarityColors[name] || rarityColors['Common'];
      $(this).removeClass(colors.active + " text-white").addClass(colors.bg);
    });
    // Activate selected
    const name = $(btn).data("name");
    const colors = rarityColors[name] || rarityColors['Common'];
    $(btn).removeClass(colors.bg).addClass(colors.active + " text-white");
    selectedRarityId = $(btn).data("id");

    maxPower = getMaxPowerByRarity(name);
    selectPower(maxPower);
  }

  $(document).on("click.co", ".rarity-pill", function(e) {
    e.preventDefault();
    selectRarity(this);
  });

  // ── Power Picker (numbered buttons) ──
  function selectPower(value) {
    maxPower = value;
    $("#item_power").val(value);

    $(".power-btn").each(function() {
      const p = parseInt($(this).data("power"));
      $(this).removeClass("active btn-secondary btn-success btn-info btn-warning btn-danger btn-dark text-white btn-outline-secondary");
      if (p === value) {
        $(this).addClass("active " + powerBtnClass(p) + " text-white");
      } else {
        $(this).addClass("btn-outline-secondary");
      }
    });

    // Sync rarity pill by name (robust — not dependent on DB IDs)
    const rarityName = getRarityNameByPower(value);
    const rarityBtn = $(`.rarity-pill[data-name='${rarityName}']`);
    if (rarityBtn.length) selectRarityVisual(rarityBtn);

    // Show Divino origin when power reaches 10 (Ancestral)
    const divinoBtn = $('.origin-btn[data-origin="Divino"]');
    if (value === 10) {
      divinoBtn.show();
    } else if (selectedCategoryName !== 'Artifacts') {
      divinoBtn.hide();
      if (selectedOrigin === 'Divino') selectOrigin($('.origin-btn[data-origin="Desconocido"]')[0]);
    }

    updateProgressBar();
  }

  // Visual-only rarity select (no power change, avoids loop)
  function selectRarityVisual(btn) {
    $(".rarity-pill").each(function() {
      const name = $(this).data("name");
      const colors = rarityColors[name] || rarityColors['Common'];
      $(this).removeClass(colors.active + " text-white").addClass(colors.bg);
    });
    const name = $(btn).data("name");
    const colors = rarityColors[name] || rarityColors['Common'];
    $(btn).removeClass(colors.bg).addClass(colors.active + " text-white");
    selectedRarityId = $(btn).data("id");
  }

  $(document).on("click.co", ".power-btn", function(e) {
    e.preventDefault();
    selectPower(parseInt($(this).data("power")));
  });

  // Slider → selectPower
  $(document).on("input.co", "#powerSlider", function() {
    selectPower(parseInt(this.value));
  });

  // Sync slider when selectPower is called externally
  const _origSelectPower = selectPower;
  selectPower = function(value) {
    _origSelectPower(value);
    const slider = document.getElementById('powerSlider');
    if (slider) slider.value = value;
    syncSliderTrack(value);
  };

  function syncSliderTrack(value) {
    const slider = document.getElementById('powerSlider');
    if (!slider) return;
    const pct = (value / 10) * 100;
    const colors = { 0:'#6c757d',1:'#6c757d',2:'#198754',3:'#198754',4:'#0dcaf0',5:'#0dcaf0',6:'#0d6efd',7:'#0d6efd',8:'#ffc107',9:'#ffc107',10:'#dc3545' };
    const c = colors[value] || '#0d6efd';
    slider.style.background = `linear-gradient(to right, ${c} 0%, ${c} ${pct}%, var(--bs-border-color) ${pct}%, var(--bs-border-color) 100%)`;
    slider.style.setProperty('--slider-thumb-color', c);
  }
  syncSliderTrack(maxPower);

  // ── Effects ──
  let availableEffectsData = [];
  let activeGroupFilter = 'all';
  let activePowerFilter = '';
  let activeSort = 'name';
  let selectedDragSource = null;

  // Flash
  let effectFlashTimer = null;
  function showEffectFlash(msg) {
    const el = $("#effectFlash");
    if (!el.length) return;
    el.text(msg).addClass("visible");
    clearTimeout(effectFlashTimer);
    effectFlashTimer = setTimeout(() => el.removeClass("visible"), 2200);
  }

  function syncNoEffectsHint() {
    const sel = document.getElementById('selectedEffects');
    const hint = document.getElementById('noEffectsHint');
    if (hint) hint.style.display = sel && sel.children.length > 0 ? 'none' : 'block';
  }

  function isEffectIdSelected(id) {
    const sel = document.getElementById('selectedEffects');
    return sel ? Array.from(sel.children).some(el => el.dataset.effectId == id) : false;
  }

  function isEffectTypeSelected(type) {
    const sel = document.getElementById('selectedEffects');
    return sel ? Array.from(sel.children).some(el => el.dataset.type === type) : false;
  }

  function getFilteredSortedEffects() {
    let data = availableEffectsData.filter(e => !isEffectIdSelected(e.id));
    if (activeGroupFilter !== 'all') {
      data = data.filter(e => getEffectGroup(e.effect_type) === activeGroupFilter);
    }
    if (activePowerFilter) {
      if (activePowerFilter === '5+') data = data.filter(e => e.power_level >= 5);
      else data = data.filter(e => e.power_level <= parseInt(activePowerFilter));
    }
    switch (activeSort) {
      case 'power_asc':  data.sort((a, b) => a.power_level - b.power_level); break;
      case 'power_desc': data.sort((a, b) => b.power_level - a.power_level); break;
      case 'group':      data.sort((a, b) => getEffectGroup(a.effect_type).localeCompare(getEffectGroup(b.effect_type))); break;
      default:           data.sort((a, b) => a.name.localeCompare(b.name)); break;
    }
    return data;
  }

  function populateEffectCards(effects) {
    availableEffectsData = effects;
    const presentGroups = [...new Set(effects.map(e => getEffectGroup(e.effect_type)))];
    renderGroupTabs(presentGroups);
    renderEffectCards();
    syncNoEffectsHint();
  }

  function renderGroupTabs(presentGroups) {
    const wrap = document.getElementById('effectGroupTabs');
    if (!wrap) return;
    wrap.innerHTML = '';
    const allBtn = document.createElement('button');
    allBtn.type = 'button';
    allBtn.className = `eff-tab${activeGroupFilter === 'all' ? ' active' : ''}`;
    allBtn.dataset.group = 'all';
    allBtn.innerHTML = '<i class="bi bi-grid-fill me-1"></i>Todos';
    wrap.appendChild(allBtn);
    presentGroups.forEach(g => {
      const meta = groupMeta[g];
      if (!meta) return;
      const btn = document.createElement('button');
      btn.type = 'button';
      btn.className = `eff-tab${activeGroupFilter === g ? ' active' : ''}`;
      btn.dataset.group = g;
      btn.style.setProperty('--ec', `var(--${meta.color})`);
      btn.innerHTML = `<i class="bi ${meta.icon} me-1"></i>${meta.label}`;
      wrap.appendChild(btn);
    });
  }

  function renderEffectCards() {
    const container = document.getElementById('availableEffects');
    if (!container) return;
    container.innerHTML = '';
    const data = getFilteredSortedEffects();
    data.forEach(effect => {
      const color = getEffectColor(effect.effect_type);
      const isTypeBlocked = isEffectTypeSelected(effect.effect_type);
      const overPower = totalPower + effect.power_level > maxPower;
      const disabled = isTypeBlocked || overPower;
      const card = document.createElement('div');
      card.className = ['effect-card', isTypeBlocked ? 'type-blocked' : '', overPower && !isTypeBlocked ? 'over-power' : ''].filter(Boolean).join(' ');
      card.style.setProperty('--ec', `var(--${color})`);
      card.setAttribute('draggable', disabled ? 'false' : 'true');
      if (disabled) card.setAttribute('disabled', '');
      card.dataset.id = effect.id;
      card.dataset.power = effect.power_level;
      card.dataset.type = effect.effect_type;
      card.dataset.name = effect.name;
      card.innerHTML = `
        <div class="effect-card-header">
          <span class="effect-card-name">${effect.name}</span>
          <span class="effect-card-power">${effect.power_level}</span>
        </div>
        <span class="effect-card-type">${effect.effect_type}</span>
        ${effect.description ? `<p class="effect-card-desc mb-0">${effect.description}</p>` : ''}
      `;
      if (!disabled) {
        card.addEventListener('click', () => addEffect(effect));
        card.addEventListener('dragstart', e => {
          e.dataTransfer.effectAllowed = 'copy';
          e.dataTransfer.setData('application/effect-json', JSON.stringify({
            id: effect.id, power: effect.power_level, type: effect.effect_type, name: effect.name
          }));
          card.classList.add('dragging');
        });
        card.addEventListener('dragend', () => card.classList.remove('dragging'));
      }
      container.appendChild(card);
    });
  }

  function refreshEffectCards() { renderEffectCards(); }

  function addEffect(effect) {
    if (isEffectIdSelected(effect.id)) return;
    if (isEffectTypeSelected(effect.effect_type)) {
      showEffectFlash(`Ya hay un efecto de tipo "${effect.effect_type}".`);
      return;
    }
    if (totalPower + effect.power_level > maxPower) {
      showEffectFlash(`No hay poder para "${effect.name}".`);
      return;
    }
    totalPower += effect.power_level;
    addSelectedEffectRow(effect.id, effect.power_level, effect.effect_type, effect.name);
    refreshEffectCards();
    updateProgressBar();
  }

  function addSelectedEffectRow(effectId, ePower, eType, eName) {
    const container = document.getElementById('selectedEffects');
    if (!container) return;
    const color = getEffectColor(eType);
    const group = getEffectGroup(eType);
    const meta = groupMeta[group] || groupMeta.utility;
    const row = document.createElement('div');
    row.className = 'selected-effect-row';
    row.setAttribute('draggable', 'true');
    row.dataset.effectId = effectId;
    row.dataset.power = ePower;
    row.dataset.type = eType;
    row.innerHTML = `
      <div class="selected-effect-drag"><i class="bi bi-grip-vertical"></i></div>
      <div class="selected-effect-icon" style="--ec:var(--${color})"><i class="bi ${meta.icon}"></i></div>
      <div class="selected-effect-body">
        <div class="selected-effect-name">${eName}</div>
        <div class="selected-effect-meta">${eType}</div>
      </div>
      <span class="selected-effect-power" style="background:var(--${color});">${ePower}</span>
      <button class="selected-effect-remove remove-effect-btn" type="button" title="Quitar">
        <i class="bi bi-x-lg remove-effect-btn"></i>
      </button>
    `;
    // Drag to reorder within selected list
    row.addEventListener('dragstart', e => {
      if (e.dataTransfer.types.includes('application/effect-json')) return;
      e.dataTransfer.effectAllowed = 'move';
      e.dataTransfer.setData('text/effect-reorder', effectId);
      selectedDragSource = row;
      setTimeout(() => row.classList.add('dragging'), 0);
    });
    row.addEventListener('dragend', () => {
      row.classList.remove('dragging');
      document.querySelectorAll('.selected-effect-row.drag-over').forEach(el => el.classList.remove('drag-over'));
      selectedDragSource = null;
    });
    row.addEventListener('dragover', e => {
      if (selectedDragSource && selectedDragSource !== row) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        document.querySelectorAll('.selected-effect-row.drag-over').forEach(el => el.classList.remove('drag-over'));
        row.classList.add('drag-over');
      }
    });
    row.addEventListener('dragleave', () => row.classList.remove('drag-over'));
    row.addEventListener('drop', e => {
      row.classList.remove('drag-over');
      if (selectedDragSource && selectedDragSource !== row && e.dataTransfer.getData('text/effect-reorder')) {
        e.preventDefault();
        const all = Array.from(container.children);
        const srcIdx = all.indexOf(selectedDragSource);
        const tgtIdx = all.indexOf(row);
        container.insertBefore(selectedDragSource, srcIdx < tgtIdx ? row.nextSibling : row);
      }
    });
    container.appendChild(row);
    syncNoEffectsHint();
  }

  // Drop zone: drag from available → selected panel
  const selectedPanel = document.getElementById('selectedEffects');
  if (selectedPanel) {
    selectedPanel.addEventListener('dragover', e => {
      if (e.dataTransfer.types.includes('application/effect-json')) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'copy';
        selectedPanel.classList.add('drop-active');
      }
    });
    selectedPanel.addEventListener('dragleave', e => {
      if (!selectedPanel.contains(e.relatedTarget)) selectedPanel.classList.remove('drop-active');
    });
    selectedPanel.addEventListener('drop', e => {
      selectedPanel.classList.remove('drop-active');
      const raw = e.dataTransfer.getData('application/effect-json');
      if (!raw) return;
      e.preventDefault();
      try {
        const data = JSON.parse(raw);
        // Look up full effect object so field names (.power_level, .effect_type) are correct
        const effect = availableEffectsData.find(ef => ef.id == data.id);
        if (effect) addEffect(effect);
      } catch(_) {}
    });
  }

  // Group filter tabs
  $(document).on("click.co", ".eff-tab", function(e) {
    e.preventDefault();
    activeGroupFilter = $(this).data("group");
    $(".eff-tab").removeClass("active");
    $(this).addClass("active");
    renderEffectCards();
  });

  // Power filter + sort selects
  $(document).on("change.co", "#powerFilter", function() {
    activePowerFilter = this.value;
    renderEffectCards();
  });
  $(document).on("change.co", "#effectSort", function() {
    activeSort = this.value;
    renderEffectCards();
  });

  // ── Load initial data ──
  const isEditPage = /^\/items\/\d+\/edit$/.test(cleanPath);
  let editItemData = null;
  let raritiesLoaded = false;

  hanldeEffectsByCategory(selectedCategoryName || "Ammunition");
  hanldeRarities();

  if (isEditPage) {
    // Use preloaded data from server if available, otherwise fallback to AJAX
    if (window.editItemPreload) {
      editItemData = window.editItemPreload;
      window.editItemPreload = null; // Clear to avoid stale data on Turbo navigation
      if (raritiesLoaded) {
        applyItemData();
      }
    } else {
      loadItemData();
    }
  }

  // ── Functions ──

  function loadItemData() {
    const match = cleanPath.match(/^\/items\/(\d+)\/edit$/);
    const itemId = match ? match[1] : null;

    if(itemId != null) {
      $.ajax({
        url: localePrefix + '/items/get_item',
        type: 'POST',
        data: { id: itemId },
        success: function(response) {
          editItemData = response;
          if (raritiesLoaded) {
            applyItemData();
          }
          // Otherwise, hanldeRarities will call applyItemData when ready
        },
        error: function(error) {
          console.error('Error:', error);
        }
      });
    }
  }

  function applyItemData() {
    if (!editItemData) return;

    const item = editItemData.item;
    const effects = editItemData.effects;

    $("#item_id").val(item.id);
    $("#item_name").val(item.name);

    // Select category
    const catBtn = $(`.category-btn[data-id='${item.category_id}']`);
    if (catBtn.length) selectCategory(catBtn[0]);

    // Restore weapon selection if applicable
    if (item.weapon_name) {
      const weaponBtn = $(`.weapon-btn[data-name="${item.weapon_name}"]`);
      if (weaponBtn.length) {
        $(".weapon-btn").removeClass("active btn-primary").addClass("btn-outline-secondary");
        weaponBtn.removeClass("btn-outline-secondary").addClass("active btn-primary");
        const damage = weaponBtn.data("damage");
        const cost = weaponBtn.data("cost");
        if (damage || cost) {
          $("#weaponDamage").text(damage);
          $("#weaponCost").text(cost);
          $("#weaponDetails").show();
        }
      }
    }

    // Select rarity visually
    const rarBtn = $(`.rarity-pill[data-id='${item.rarity_id}']`);
    if (rarBtn.length) {
      selectRarityVisual(rarBtn);
      selectedRarityId = item.rarity_id;
    }

    // Set power
    maxPower = item.power;
    selectPower(item.power);

    // Re-select rarity visually (selectPower may have overridden it)
    const rarBtn2 = $(`.rarity-pill[data-id='${item.rarity_id}']`);
    if (rarBtn2.length) {
      selectRarityVisual(rarBtn2);
      selectedRarityId = item.rarity_id;
    }

    // Restore description (and auto-lock it since it's an existing item)
    const descTextarea = document.getElementById('item_description_display');
    if (descTextarea && item.description) {
      descTextarea.value = item.description;
      descriptionLocked = true;
      syncLockBtn();
    }

    // Restore lore setting
    const lore = item.lore || 'faerun';
    document.querySelectorAll('.lore-btn').forEach(btn => {
      const label = btn.closest('.lore-radio-btn');
      if (btn.dataset.lore === lore) {
        btn.checked = true;
        label?.classList.add('active');
      } else {
        btn.checked = false;
        label?.classList.remove('active');
      }
    });

    // Restore origin
    const origin = item.origin || 'Desconocido';
    const originBtn = $(`.origin-btn[data-origin="${origin}"]`);
    if (originBtn.length) selectOrigin(originBtn[0]);

    // Load effects into the selected list
    $("#selectedEffects").empty();
    totalPower = 0;

    effects.forEach(effect => {
      addSelectedEffectRow(effect.id, effect.power_level, effect.effect_type, effect.name);
      totalPower += effect.power_level;
    });

    updateProgressBar();

    refreshEffectCards();
  }

  function getMaxPowerByRarity(rarity) {
    switch (rarity) {
      case 'Ancestral': return 10;
      case 'Legendary': return 9;
      case 'Very Rare': return 7;
      case 'Rare': return 5;
      case 'Uncommon': return 3;
      case 'Common': return 1;
      default: return 0;
    }
  }

  function getRarityNameByPower(mp) {
    if (mp >= 10) return 'Ancestral';
    if (mp >= 8)  return 'Legendary';
    if (mp >= 6)  return 'Very Rare';
    if (mp >= 4)  return 'Rare';
    if (mp >= 2)  return 'Uncommon';
    return 'Common';
  }

  function hanldeEffectsByCategory(categoryName) {
    $.ajax({
      url: localePrefix + '/effects/get_effects_by_category',
      type: 'POST',
      data: { category: categoryName },
      success: function(response) {
        populateEffectCards(response.data);
        $("#effectsLabel").text("Effects for " + categoryName + " (" + response.data.length + ")");

        // On edit page, mark already-selected effects as disabled
        if (isEditPage) {
          $(".effect-card").each(function() {
            if (isEffectIdSelected($(this).data("id"))) {
              $(this).addClass('selected').prop('disabled', true);
            }
          });
        }
      },
      error: function(error) {
        console.error('Error:', error);
      }
    });
  }

  function hanldeRarities() {
    $.ajax({
      url: localePrefix + '/rarities/get_rarities',
      type: 'POST',
      data: {},
      success: function(response) {
        allRarities = response.data;
        populateRarityPills(response.data);

        raritiesLoaded = true;

        if (isEditPage && editItemData) {
          // On edit pages, apply item data now that rarity pills are ready
          applyItemData();
        } else if (!isEditPage) {
          // Select Ancestral (id=6) by default on new item pages
          const defaultBtn = $(`.rarity-pill[data-id='${startRarity}']`);
          if (defaultBtn.length) selectRarity(defaultBtn[0]);
        }
      },
      error: function(error) {
        console.error('Error:', error);
      }
    });
  }

  function populateRarityPills(rarities) {
    const container = $('#rarityPicker');
    container.empty();

    rarities.forEach(rarity => {
      const colors = rarityColors[rarity.name] || rarityColors['Common'];
      container.append(`
        <button type="button"
                class="btn btn-sm rarity-pill ${colors.bg}"
                data-id="${rarity.id}"
                data-name="${rarity.name}">
          <i class="bi bi-star-fill me-1"></i>${rarity.name}
        </button>
      `);
    });
  }

  function updateProgressBar() {
    const text = `${totalPower} / ${maxPower}`;
    document.querySelectorAll('#powerUsageText').forEach(el => { el.innerText = text; });
    checkButtons();
  }

  function checkButtons() {
    const overBudget = totalPower > maxPower;

    // Power warning badge
    const warningEl = document.getElementById('powerWarning');
    const warningText = document.getElementById('powerWarningText');
    if (warningEl) {
      if (overBudget) {
        if (warningText) warningText.textContent = `+${totalPower - maxPower} over power`;
        warningEl.style.display = '';
      } else {
        warningEl.style.display = 'none';
      }
    }

    if (overBudget) {
      // Effects exceed budget — block save
      $("#createItem").prop('disabled', true).addClass("disabled btn-outline-danger").removeClass("btn-primary btn-outline-primary");
      $("#updateItem").prop('disabled', true).addClass("disabled btn-outline-danger").removeClass("btn-primary btn-outline-primary");
    } else if (totalPower >= maxPower) {
      // Exactly at budget — allow save, disable adding more
      $(".effect-card:not([disabled])").prop('disabled', true);
      $("#createItem").prop('disabled', false).removeClass("disabled btn-outline-primary btn-outline-danger").addClass("btn-primary");
      $("#updateItem").prop('disabled', false).removeClass("disabled btn-outline-primary btn-outline-danger").addClass("btn-primary");
    } else {
      // Under budget — re-enable cards that can still be added
      $(".effect-card").each(function() {
        if (!isEffectIdSelected($(this).data("id"))) {
          $(this).prop('disabled', false).removeClass('selected');
        }
      });
      // Allow update always (edit page); require at least 1 effect for create
      $("#updateItem").prop('disabled', false).removeClass("disabled btn-outline-primary btn-outline-danger").addClass("btn-primary");
      if (totalPower > 0) {
        $("#createItem").prop('disabled', false).removeClass("disabled btn-outline-primary btn-outline-danger").addClass("btn-primary");
      } else {
        $("#createItem").prop('disabled', true).addClass("disabled btn-outline-primary").removeClass("btn-primary btn-outline-danger");
      }
    }
  }

  // ── Reset Effects ──
  if($("#resetEffects").length) {
    document.getElementById('resetEffects').addEventListener('click', function(event) {
      event.preventDefault();
      $("#selectedEffects").empty();
      totalPower = 0;
      syncNoEffectsHint();
      refreshEffectCards();
      updateProgressBar();
    });
  }

  // ── Remove Effect ──
  if($("#selectedEffects").length) {
    document.getElementById('selectedEffects').addEventListener('click', function(event) {
      if (event.target.classList.contains('remove-effect-btn') || event.target.closest('.selected-effect-remove')) {
        const row = event.target.closest('.selected-effect-row');
        if (!row) return;
        const ep = parseInt(row.dataset.power);
        totalPower -= ep;
        row.remove();

        syncNoEffectsHint();
        refreshEffectCards();
        updateProgressBar();
      }
    });
  }

  // ── Generate Name ──
  if($("#generateNameBtn").length) {
    document.getElementById('generateNameBtn').addEventListener('click', function(event) {
      event.preventDefault();

      let weapon = "";
      let effects = [];
      let category = selectedCategoryId;
      if (selectedCategoryName === "Weapons") weapon = $(".weapon-btn.active").data("name") || "";

      let power = $("#item_power").val();
      $.each($("#selectedEffects")[0].children, function(i, li) {
        effects.push(li.dataset.effectId);
      });

      $("#generateNameBtn").prop('disabled', true).html('<i class="bi bi-hourglass-split me-1"></i>...');

      $.ajax({
        url: localePrefix + '/items/get_item_name',
        type: 'POST',
        data: { category: category, weapon: weapon, power: power, effects: effects, lore: getSelectedLore(), origin: getSelectedOrigin() },
        success: function(response) {
          $("#item_name").val(response.data);
          $("#generateNameBtn").prop('disabled', false).html('<i class="bi bi-magic me-1"></i>Generate');
        },
        error: function(error) {
          console.error('Error:', error);
          $("#generateNameBtn").prop('disabled', false).html('<i class="bi bi-magic me-1"></i>Generate');
        }
      });
    });
  }

  // ── Create Item ──
  if($("#createItem").length) {
    document.getElementById('createItem').addEventListener('click', function(event) {
      event.preventDefault();

      var category = selectedCategoryId;
      var name = $("#item_name").val();
      var rarity = $(`.rarity-pill.text-white`).data("name") || "Common";
      var weapon = selectedCategoryName === "Weapons" ? ($(".weapon-btn.active").data("name") || "") : "";
      var effects = [];
      $.each($("#selectedEffects")[0].children, function(i, li) {
        effects.push(li.dataset.effectId);
      });
      var power = $("#item_power").val();

      // Show forge animation
      $("#forgeOverlay").fadeIn(200);

      const ajaxPromise = $.ajax({
        url: localePrefix + '/items/create_item',
        type: 'POST',
        data: { name: name, category: category, weapon: weapon, rarity: rarity, power: power, effects: effects, lore: getSelectedLore(), origin: getSelectedOrigin(), description: $('#item_description_display').val(), description_locked: descriptionLocked }
      });

      const animationDelay = new Promise(resolve => setTimeout(resolve, 2000));

      Promise.all([ajaxPromise, animationDelay]).then(function(results) {
        const response = results[0];
        $("#forgeOverlay").fadeOut(300, function() {
          window.location.href = localePrefix + '/items/' + response.item_id;
        });
      }).catch(function(error) {
        console.error('Error:', error);
        $("#forgeOverlay").fadeOut(300, function() {
          $("#notification_message").text("Object " + name + " was NOT created! " + JSON.stringify(error));
          $("#notifications").removeClass('success').addClass('danger').show("slow", "swing");
          setTimeout(function(){ $("#notifications").hide("slow", "swing"); }, errorNotificationTimeout);
        });
      });
    });
  }

  // ── Update Item ──
  if($("#updateItem").length) {
    document.getElementById('updateItem').addEventListener('click', function(event) {
      event.preventDefault();

      const category = selectedCategoryId;
      const name = $("#item_name").val();
      const rarity = $(`.rarity-pill.text-white`).data("name") || "Common";
      const weapon = selectedCategoryName === "Weapons" ? ($(".weapon-btn.active").data("name") || "") : "";
      const effects = [];
      $.each($("#selectedEffects")[0].children, function(i, li) {
        effects.push(li.dataset.effectId);
      });
      const power = $("#item_power").val();
      const id = $("#item_id").val();

      // Show forge animation
      $("#forgeOverlay").fadeIn(200);

      const ajaxPromise = $.ajax({
        url: localePrefix + '/items/update_item',
        type: 'POST',
        data: { id: id, name: name, category: category, weapon: weapon, rarity: rarity, power: power, effects: effects, lore: getSelectedLore(), origin: getSelectedOrigin(), description: $('#item_description_display').val(), description_locked: descriptionLocked }
      });

      const animationDelay = new Promise(resolve => setTimeout(resolve, 2000));

      Promise.all([ajaxPromise, animationDelay]).then(function(results) {
        $("#forgeOverlay").fadeOut(300, function() {
          const id = $("#item_id").val();
          window.location.href = localePrefix + '/items/' + id;
        });
      }).catch(function(error) {
        console.error('Error:', error);
        $("#forgeOverlay").fadeOut(300, function() {
          $("#notification_message").text("Object " + name + " was NOT updated! " + JSON.stringify(error));
          $("#notifications").removeClass('success').addClass('danger').show("slow", "swing");
          setTimeout(function(){ $("#notifications").hide("slow", "swing"); }, errorNotificationTimeout);
        });
      });
    });
  }

  // ── Random Create page support ──
  const rarityElement = document.getElementById('rarity');
  const powerLevelElement = document.getElementById('power_level');

  if (rarityElement) {
    rarityElement.addEventListener('change', function() {
      const rarity = rarityElement.options[rarityElement.selectedIndex].text;
      const power = getMaxPowerByRarity(rarity);
      if (powerLevelElement) powerLevelElement.value = power;
    });
  }

  if (powerLevelElement) {
    powerLevelElement.addEventListener('change', function() {
      const power = powerLevelElement.options[powerLevelElement.selectedIndex].text;
      const rarity = getRarityNameByPower(parseInt(power));
      if (rarityElement) rarityElement.value = rarity;
    });
  }
}

$(document).ready(initCreateObjects);
$(document).on('turbo:load', initCreateObjects);
