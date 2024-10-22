let totalPower = 0;
let maxPower = 10;
let selectedEffect = ""
let effectPower = ""
let weaponSelectContainer = ""
let startRarity = 6
let path = window.location.pathname

$(document).ready(function($) {
  
  function replaceUrl(url) {
    window.location.replace(url);
  }

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  if(path != "/items/new" && path != "/items/edit" && path != "/items/create_random") {
    return;
  }

  // Start options
  let categoryName = $("#addCategory :selected").text()
  hanldeEffectsByCategory(categoryName)
  hanldeRarities()

  $("#item_power").val(maxPower)

  $("#category_id").change(function() {
    updateCard()
  })

  $("#power_level").change(function() {
    updateCard()
  })
  
  function updateCard() {
    $(".card-title").text("Creating " + getRarity() + " " + getCategory())
    $(".card-text").text("This item will be level: " + getLevel())
  }

  function getLevel() {
    var power = $("#power_level").val() || "A mystery!"

    return power
  }

  function getCategory() {
    var category = $("#category_id :selected").text() || "Nobody Knows!"

    return category
  }

  // Function to get the Rarity
  function getRarity() {
    var power = getLevel()
    var rarity = "Who knows?"

    if(power == 10) rarity = "Ancestral"
    else if(power == 8 || power == 9) rarity = "Legendary"
    else if(power == 6 || power == 7) rarity = "Very Rare"
    else if(power == 4 || power == 5) rarity = "Rare"
    else if(power == 2 || power == 3) rarity = "Uncommon"
    else rarity = "Common"

    return rarity
  }

  function getRarityByMaxPower(maxPower) {
    let rarity = "Common"

    if(maxPower == 10) rarity = "Ancestral"
    else if(maxPower == 8 || maxPower == 9) rarity = "Legendary"
    else if(maxPower == 6 || maxPower == 7) rarity = "Very Rare"
    else if(maxPower == 4 || maxPower == 5) rarity = "Rare"
    else if(maxPower == 2 || maxPower == 3) rarity = "Uncommon"
    else if(maxPower == 0 || maxPower ==1) rarity = "Common"

    return rarity
  }

  function getRarityValByMaxPower(maxPower) {
    let rarity = "Common"

    if(maxPower == 10) rarity = 6
    else if(maxPower == 8 || maxPower == 9) rarity = 5
    else if(maxPower == 6 || maxPower == 7) rarity = 4
    else if(maxPower == 4 || maxPower == 5) rarity = 3
    else if(maxPower == 2 || maxPower == 3) rarity = 2
    else if(maxPower == 0 || maxPower == 1) rarity = 1

    return rarity
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
    
    return maxPower
  }

  // This function handles the effects when changint the category
  function hanldeEffectsByCategory(categoryName) {
    $.ajax({
      url: '/effects/get_effects_by_category',
      type: 'POST',
      data: {
        category: categoryName,
      },
      success: function(response) {
        populateEffects(response.data)
        $("#effectsLabel").text("Effects for " + categoryName + " | (" + response.data.length + ")")
      },
      error: function(error) {
        console.error('Error:', error);
      }
    });
  }

  // This function populates the effects dropdown
  function populateEffects(effects) {
    const dropdown = $('#addEffect');
    
    dropdown.empty();
    
    effects.forEach(effect => {
      dropdown.append(
        $('<option>', {
          value: effect.id,
          'data-id': effect.id,
          'data-power': effect.power_level,
          'data-type': effect.effect_type,
          text: effect.name + " | " + effect.description + " | " + effect.effect_type + " | Power: " + effect.power_level
        })
      );
    });
  }

  // This function handles the rarities
  function hanldeRarities() {
    $.ajax({
      url: '/rarities/get_rarities',
      type: 'POST',
      data: {},
      success: function(response) {
        populateRarities(response.data)
        $("#addRarity").val(startRarity)
      },
      error: function(error) {
        console.error('Error:', error)
      }
    });
  }

  // This function populates the rarities dropdown
  function populateRarities(rarities) {
    const dropdown = $('#addRarity');
    
    dropdown.empty();
    
    rarities.forEach(rarity => {
      dropdown.append($('<option>', {
        value: rarity.id,
        text: rarity.name
      }));
    });
  }

  // Helper function to check if effect type is already selected
  function isEffectTypeAlreadySelected() {
    let effectType = $("#addEffect :selected")[0].dataset.type

    var arr = Array.from(document.getElementById('selectedEffects').children).some(function(listItem) {
      return listItem.dataset.type === effectType;
    });

    return arr
  }

  // Helper function to check if effect is already selected
  function isEffectAlreadySelected() {
    let effectId = $("#addEffect").val()
    var arr = Array.from(document.getElementById('selectedEffects').children).some(function(listItem) {
      return listItem.dataset.effectId === effectId;
    });

    return arr
  }

  function updateProgressBar() {
    // Update power progress bar and text
    const progressPercentage = (totalPower / maxPower) * 100;
    document.getElementById('powerProgress').style.width = `${progressPercentage}%`;
    document.getElementById('powerProgress').setAttribute('aria-valuenow', totalPower);
    document.getElementById('powerUsageText').innerText = `Power used: ${totalPower}/${maxPower}`;

    // Re-enable the add effect button if total power is less than the max
    if (totalPower <= maxPower) {
      $("#addEffectBtn").prop('disabled', false);
    }
  }

  // Changes on the rarity
  if($("#addRarity").length == 1) {    
    document.getElementById('addRarity').addEventListener('change', function(event) {
      event.preventDefault()

      let rarity = $("#addRarity option:selected").text();
      maxPower = getMaxPowerByRarity(rarity);

      $("#item_power").val(maxPower)
    });

    // Changes on the power level
    if($("#item_power").length == 1) {    
      document.getElementById('item_power').addEventListener('change', function(event) {
        event.preventDefault()

        maxPower = $("#item_power").val()
        let rarity = getRarityValByMaxPower(maxPower) 
        updateProgressBar()

        $("#addRarity").val(rarity)
      });
    }
  }

  // Changes to category when it is Weapons
  if($("#addCategory").length == 1) {
    document.getElementById('addCategory').addEventListener('change', function(event) {
      let categoryName = $("#addCategory :selected").text()

      categoryName == "Weapons" ? $("#addWeapons").show() : $("#addWeapons").hide()

      hanldeEffectsByCategory(categoryName)
    });
  }

  // Get name from the backend
  if($("#generateNameBtn").length == 1) {
    document.getElementById('generateNameBtn').addEventListener('click', function(event) {
      event.preventDefault()

      let weapon = ""
      let effects = []
      let category = $("#addCategory :selected").val()
      if ($("#addCategory :selected").text() == "Weapons") weapon = $("#addWeaponDropdown :selected").text()
      
      let power = $("#item_power").val()
      $.each($("#selectedEffects")[0].children, function(i, li) {
        effects.push(li.dataset.effectId)
      });

      $("#generateNameBtn").prop('disabled', true).text('Generating...')

      $.ajax({
        url: '/items/get_item_name',
        type: 'POST',
        data: {
          category: category,
          weapon: weapon,
          power: power,
          effects: effects,
        },
        success: function(response) {
          console.log('Success:', response);
          $("#item_name").val(response.data)
          $("#generateNameBtn").prop('disabled', false).text('Generated');
        },
        error: function(error) {
          console.error('Error:', error);
          $("#generateNameBtn").prop('disabled', false).text('Error Generating...');
        }
      });
    });
  }

  // Event fot reset effects
  if($("#resetEffects").length == 1) {
    document.getElementById('resetEffects').addEventListener('click', function(event) {
      event.preventDefault()

      selectedEffect = document.getElementById('addEffect');
      effectPower = parseInt(selectedEffect.options[selectedEffect.selectedIndex].dataset.power);

      $("#selectedEffects").text("")
      totalPower = 0

      updateProgressBar()

      $("#addEffectBtn").removeAttr("disabled");
    });
  }

  // Change Rarity on Random Create
  const rarityElement = document.getElementById('rarity');
  const powerLevelElement = document.getElementById('power_level');

  if (rarityElement) {
    rarityElement.addEventListener('change', function() {
      const rarity = rarityElement.options[rarityElement.selectedIndex].text;
      const power = getMaxPowerByRarity(rarity);
      
      if (powerLevelElement) {
        powerLevelElement.value = power;
      }
    });
  }

  // Change Power on Random Create



  // Add effect button
  if($("#addEffectBtn").length == 1) {
    document.getElementById('addEffectBtn').addEventListener('click', function() {
      event.preventDefault()

      selectedEffect = document.getElementById('addEffect');
      effectPower = parseInt(selectedEffect.options[selectedEffect.selectedIndex].dataset.power);
      effectId =  parseInt(selectedEffect.options[selectedEffect.selectedIndex].dataset.id);
      effectType = selectedEffect.options[selectedEffect.selectedIndex].dataset.type;
      
      // Check if the effect is already added
      if (isEffectAlreadySelected()) {
        alert('This effect has already been added!');
        return;
      }

      // Check if the effect type is already added
      if (isEffectTypeAlreadySelected()) {
        alert('This effect type has already been added!');
        return;
      }

      if (totalPower + effectPower <= maxPower) {
        totalPower += effectPower;

        var effectName = selectedEffect.options[selectedEffect.selectedIndex].text;
        const div = document.createElement('div');
        div.className = 'list-group-item d-flex justify-content-between align-items-center'
        div.innerHTML = `${effectName}<button class="btn btn-sm btn-outline-danger remove-effect-btn">Remove</button>`;
        div.dataset.effectId = effectId
        div.dataset.power = effectPower
        div.dataset.type = effectType

        document.getElementById('selectedEffects').appendChild(div);

        updateProgressBar()

        if(totalPower >= maxPower ) {
          $("#addEffectBtn").prop('disabled', true)
          $("#createItem").prop('disabled', false)
          $("#createItem").removeClass("disabled")
          $("#createItem").removeClass("btn-outline-primary")
          $("#createItem").addClass("btn-primary")
        }

      } else {
        $("#notification_message").text('Effect cannot be created: total power exceeded.')
        $("#notifications").removeClass('success')
        $("#notifications").addClass('danger')
        $("#notifications").show("slow", "swing")

        setTimeout(function(){
          $("#notifications").hide("slow", "swing")
        }, 4000)
      }
    });
  }

  // Create Item
  if($("#createItem").length == 1) {
    document.getElementById('createItem').addEventListener('click', function(event) {
      event.preventDefault()

      var category = $("#addCategory :selected").val()
      var name = $("#item_name").val()
      var rarity = $("#addRarity :selected").text()
      var weapon = category == "Weapons" ? $("#addWeaponDropdown :selected").text() : ""
      var effects = []
      $.each($("#selectedEffects")[0].children, function(i, li) {
        effects.push(li.dataset.effectId)
      });
      var power = $("#item_power").val()

      $.ajax({
        url: '/items/create_item',
        type: 'POST',
        data: {
          name: name,
          category: category,
          weapon: weapon,
          rarity: rarity,
          power: power,
          effects: effects,
        },
        success: function(response) {
          console.log('Success:', response);
          $("#notification_message").text("The " + $("#addCategory :selected").text() + " " + name + " was created!")
          $("#notifications").removeClass('danger')
          $("#notifications").addClass('success')
          $("#notifications").show("slow", "swing")

          setTimeout(function(){
            $("#notifications").hide("slow", "swing")
          }, 4000)

        },
        error: function(error) {
          console.error('Error:', error);
          $("#notification_message").text("Object " + name + " was NOT created! " + JSON.stringify(error))
          $("#notifications").removeClass('success')
          $("#notifications").addClass('danger')
          $("#notifications").show("slow", "swing")

          setTimeout(function(){
            $("#notifications").hide("slow", "swing")
          }, 12000)
        }
      });
    });
  }
  
  // Remove effect from the list and update total power
  if($("#selectedEffects").length == 1) {
    document.getElementById('selectedEffects').addEventListener('click', function(event) {
      if (event.target.classList.contains('remove-effect-btn')) {
        const listItem = event.target.parentElement;  // Get the parent list item (effect)
        const effectPower = parseInt(listItem.dataset.power);  // Get the power level of the effect being removed

        // Update total power by subtracting the power of the removed effect
        totalPower -= effectPower;

        // Remove the effect from the list
        listItem.remove();

        updateProgressBar()
      }
    });
  }
});