let totalPower = 0;
let maxPower = 10;
let selectedEffect = ""
let effectPower = ""
let weaponSelectContainer = ""
let startRarity = 6
const succesNotificationTimeout = 10000
const errorNotificationTimeout = 15000

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

// Effect type color map
const effectTypeColors = {
  'Buff': 'success',
  'Debuff': 'danger',
  'Utility': 'info',
  'Healing': 'primary',
  'Damage': 'warning',
  'Defense': 'secondary'
};

function getEffectColor(type) {
  return effectTypeColors[type] || 'primary';
}

function initCreateObjects() {

  // Re-compute path on each navigation (Turbo changes URL without full reload)
  let path = window.location.pathname
  const localeMatch = path.match(/^\/(en|es)/)
  const localePrefix = localeMatch ? "/" + localeMatch[1] : ""

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
      $("#weaponDetails").show();
    } else {
      $("#addWeapons").hide();
      $("#weaponDetails").hide();
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

    // Sync rarity pill
    const rarityVal = getRarityValByMaxPower(value);
    const rarityBtn = $(`.rarity-pill[data-id='${rarityVal}']`);
    if (rarityBtn.length) {
      selectRarityVisual(rarityBtn);
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

  // ── Effects (clickable cards) ──
  let availableEffectsData = [];

  function populateEffectCards(effects) {
    availableEffectsData = effects;
    const container = $("#availableEffects");
    container.empty();

    effects.forEach(effect => {
      const color = getEffectColor(effect.effect_type);
      const isSelected = isEffectIdSelected(effect.id);
      const card = $(`
        <button type="button"
                class="btn btn-sm effect-card ${isSelected ? 'btn-' + color + ' text-white' : 'btn-outline-' + color}"
                data-id="${effect.id}"
                data-power="${effect.power_level}"
                data-type="${effect.effect_type}"
                data-name="${effect.name}"
                ${isSelected ? 'disabled' : ''}>
          <span class="badge bg-white text-${color} me-1">${effect.power_level}</span>
          <span class="small">${effect.name}</span>
        </button>
      `);
      container.append(card);
    });
  }

  function isEffectIdSelected(id) {
    return Array.from(document.getElementById('selectedEffects').children).some(
      el => el.dataset.effectId == id
    );
  }

  function isEffectTypeSelected(type) {
    return Array.from(document.getElementById('selectedEffects').children).some(
      el => el.dataset.type === type
    );
  }

  // Click on effect card to add
  $(document).on("click.co", ".effect-card:not([disabled])", function(e) {
    e.preventDefault();
    const btn = $(this);
    const effectId = btn.data("id");
    const ePower = parseInt(btn.data("power"));
    const eType = btn.data("type");
    const eName = btn.data("name");
    const color = getEffectColor(eType);

    if (isEffectIdSelected(effectId)) {
      return;
    }

    if (isEffectTypeSelected(eType)) {
      alert('This effect type has already been added!');
      return;
    }

    if (totalPower + ePower > maxPower) {
      $("#notification_message").text('Effect cannot be added: total power would exceed maximum.');
      $("#notifications").removeClass('success').addClass('danger').show("slow", "swing");
      setTimeout(function(){ $("#notifications").hide("slow", "swing"); }, 4000);
      return;
    }

    totalPower += ePower;

    // Mark card as selected
    btn.removeClass('btn-outline-' + color).addClass('btn-' + color + ' text-white').prop('disabled', true);

    // Add to selected list
    const div = document.createElement('div');
    div.className = 'effect-item d-flex align-items-center justify-content-between px-2 py-1 rounded mb-1 border';
    div.innerHTML = `
      <span class="small">
        <span class="badge bg-${color} me-1">${ePower}</span>
        <strong>${eType}</strong>
        <span class="text-muted mx-1">&middot;</span>
        ${eName}
      </span>
      <button class="btn btn-sm p-0 text-danger remove-effect-btn" title="Remove"><i class="bi bi-x-lg remove-effect-btn"></i></button>
    `;
    div.dataset.effectId = effectId;
    div.dataset.power = ePower;
    div.dataset.type = eType;
    document.getElementById('selectedEffects').appendChild(div);

    updateProgressBar();
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

    // Load effects into the selected list
    $("#selectedEffects").empty();
    totalPower = 0;

    effects.forEach(effect => {
      const color = getEffectColor(effect.effect_type);
      const div = document.createElement('div');
      div.className = 'effect-item d-flex align-items-center justify-content-between px-2 py-1 rounded mb-1 border';
      div.innerHTML = `
        <span class="small">
          <span class="badge bg-${color} me-1">${effect.power_level}</span>
          <strong>${effect.effect_type}</strong>
          <span class="text-muted mx-1">&middot;</span>
          ${effect.name}
        </span>
        <button class="btn btn-sm p-0 text-danger remove-effect-btn" title="Remove"><i class="bi bi-x-lg remove-effect-btn"></i></button>
      `;
      div.dataset.effectId = effect.id;
      div.dataset.power = effect.power_level;
      div.dataset.type = effect.effect_type;
      document.getElementById('selectedEffects').appendChild(div);
      totalPower += effect.power_level;
    });

    updateProgressBar();

    // Mark effect cards that are already selected as disabled
    $(".effect-card").each(function() {
      if (isEffectIdSelected($(this).data("id"))) {
        const color = getEffectColor($(this).data("type"));
        $(this).removeClass('btn-outline-' + color).addClass('btn-' + color + ' text-white').prop('disabled', true);
      }
    });
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

  function getRarityValByMaxPower(mp) {
    if(mp == 10) return 6;
    if(mp == 8 || mp == 9) return 5;
    if(mp == 6 || mp == 7) return 4;
    if(mp == 4 || mp == 5) return 3;
    if(mp == 2 || mp == 3) return 2;
    if(mp == 0 || mp == 1) return 1;
    return 1;
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
              const color = getEffectColor($(this).data("type"));
              $(this).removeClass('btn-outline-' + color).addClass('btn-' + color + ' text-white').prop('disabled', true);
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
    const progressPercentage = Math.min((totalPower / maxPower) * 100, 100);
    const bar = document.getElementById('powerProgress');
    if (!bar) return;
    bar.style.width = `${progressPercentage}%`;
    bar.setAttribute('aria-valuenow', totalPower);
    document.getElementById('powerUsageText').innerText = `${totalPower} / ${maxPower}`;

    bar.className = 'progress-bar';
    if (progressPercentage >= 100) bar.classList.add('bg-success');
    else if (progressPercentage >= 60) bar.classList.add('bg-info');
    else bar.classList.add('bg-primary');

    checkButtons();
  }

  function checkButtons() {
    if(totalPower >= maxPower) {
      $(".effect-card:not([disabled])").prop('disabled', true);
      $("#createItem").prop('disabled', false).removeClass("disabled btn-outline-primary").addClass("btn-primary");
      $("#updateItem").prop('disabled', false).removeClass("disabled btn-outline-primary").addClass("btn-primary");
    } else {
      // Re-enable effect cards that aren't already selected
      $(".effect-card").each(function() {
        if (!isEffectIdSelected($(this).data("id"))) {
          $(this).prop('disabled', false);
          const color = getEffectColor($(this).data("type"));
          $(this).removeClass('btn-' + color + ' text-white').addClass('btn-outline-' + color);
        }
      });
      $("#createItem").prop('disabled', true).addClass("disabled btn-outline-primary").removeClass("btn-primary");
      $("#updateItem").prop('disabled', true).addClass("disabled btn-outline-primary").removeClass("btn-primary");
    }
  }

  // ── Reset Effects ──
  if($("#resetEffects").length) {
    document.getElementById('resetEffects').addEventListener('click', function(event) {
      event.preventDefault();
      $("#selectedEffects").empty();
      totalPower = 0;
      updateProgressBar();
      // Re-enable all effect cards
      $(".effect-card").each(function() {
        const color = getEffectColor($(this).data("type"));
        $(this).prop('disabled', false).removeClass('btn-' + color + ' text-white').addClass('btn-outline-' + color);
      });
    });
  }

  // ── Remove Effect ──
  if($("#selectedEffects").length) {
    document.getElementById('selectedEffects').addEventListener('click', function(event) {
      if (event.target.classList.contains('remove-effect-btn')) {
        const listItem = event.target.closest('.effect-item');
        const ep = parseInt(listItem.dataset.power);
        const eid = listItem.dataset.effectId;
        totalPower -= ep;
        listItem.remove();

        // Re-enable the corresponding effect card
        $(`.effect-card[data-id='${eid}']`).each(function() {
          const color = getEffectColor($(this).data("type"));
          $(this).prop('disabled', false).removeClass('btn-' + color + ' text-white').addClass('btn-outline-' + color);
        });

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
        data: { category: category, weapon: weapon, power: power, effects: effects },
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
        data: { name: name, category: category, weapon: weapon, rarity: rarity, power: power, effects: effects }
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
        data: { id: id, name: name, category: category, weapon: weapon, rarity: rarity, power: power, effects: effects }
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
      const rarity = getRarityValByMaxPower(power);
      if (rarityElement) rarityElement.value = rarity;
    });
  }
}

$(document).ready(initCreateObjects);
$(document).on('turbo:load', initCreateObjects);
