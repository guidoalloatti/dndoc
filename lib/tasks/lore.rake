namespace :lore do
  desc "Seed proper names for legendary/ancestral item name generation"
  task seed_proper_names: :environment do
    proper_names = {
      "faerun" => %w[
        Abyss Aegis Agony Animus Anguish Annul Arcane Ardor Arend Argent
        Ashen Asher Ashfel Askar Astor Athos Atrum Augur Aurel Auric
        Axiom Azoth Balor Bane Banor Bastion Blight Bliss Blaze Blind
        Bliss Bloodmoor Bolverk Braxis Brimstone Brutus Cabal Calyx
        Cinder Cipher Citadel Coil Corial Cosm Cradle Craven Crestor
        Crypt Culvax Cursed Dagon Damael Darkon Darnel Darys Davas Decim
        Deimos Dervish Deschain Destral Dirge Doomcrag Dorvath Doss Drek
        Drenth Dusk Ebonmaw Edric Elspeth Embral Embrax Endor Enmar Ennui
        Entropy Envoy Erant Erath Erebon Erevax Estren Exarch Exil Exor
        Extremis Fable Falcion Farox Fatalis Fell Fenrath Fervor Feral
        Ferrix Filth Firal Flail Flare Forvax Fractur Frey Frith Furor
        Fury Galen Gallows Garax Gareth Garost Gavron Gilrath Glaive Gloom
        Gnash Goreax Grasp Graven Grim Grimoire Groth Guile Gulch Gurt
        Hael Hakon Haldir Halos Harbinger Hargax Harm Harrow Harsk Havoc
        Hawkvane Hellgore Helion Hellion Heresy Hexen Hexis Hollow Honor
        Hordak Howl Hurak Hydrax Ichor Ignis Ikrath Ilex Ilgara Illum
        Infernal Inferno Ingot Iniquity Inky Invictus Irad Iral Iravin
        Irik Iron Ironclaw Iskar Ismir Isolde Ithan Ivren Jadoth Jareth
        Jinx Jorvax Kael Kain Kalos Karat Kargath Kaspar Kaven Kazan
        Keldorn Kelrith Kelvax Khal Khalen Khavor Kolvax Korvax Kral
        Kraven Kresh Kreth Krul Krux Kurath Lament Lanox Lareth Lariath
        Lash Lathrix Lethis Levax Lexis Liath Liminal Linx Lirath Loch
        Lorcan Lorgath Lurk Luthien Lyrix Macabre Maerik Malath Malek
        Malgor Malice Malion Malorn Mand Marak Marduk Mareth Marsh Marvax
        Mastrix Menace Mentak Merax Miral Mireth Mirith Misery Mith
        Molten Morah Morath Mord Mordrax Mordred Morvax Mosix Murak Naeth
        Narbor Narduk Nareth Narith Naveth Navar Nether Nexis Nihil Nithal
        Noctis Norgath Norrath Nurath Nyx Obelix Oblith Oblivion Obsidian
        Odalric Odarix Odrak Ometh Omen Omnis Onyx Ophal Orath Orbus
        Ordax Ordrax Orek Orial Orick Origen Orion Orkas Orkin Orkis
        Osrak Othrix Overlord Paelax Paladin Palax Parel Pareth Parox
        Pasha Patriax Perdix Peril Perix Phael Phastix Phantas Phobos
        Plagath Plagueis Portend Praxis Predax Pyrax Pyrith Pyros Quell
        Quiver Radix Rahgon Rakhis Rakoth Raleth Ralith Rampax Randal
        Rankith Raptor Ravax Ravel Ravik Ravix Ravok Raxis Razith Recant
        Rend Render Renik Renix Rethal Rethis Rexis Revax Riath Rigel
        Rikon Rikoth Rilath Rimoth Rindal Ritual Rivax Riven Riveth Rohm
        Ronax Roneth Ronith Roothal Rorax Rorath Rostral Roth Rothis Rovar
        Rovax Roveth Ruin Ruinik Ruinix Runak Runath Runel Ryvax Sabrax
        Sadius Saedal Saevax Saketh Sakan Salath Salith Salthor Salvax
        Sander Sargon Sarith Sarkon Sarvax Sathis Savak Saveth Savik
        Scald Scorch Scorn Scourge Scrim Seraph Sevax Shroud Sidal Sidon
        Silt Sinew Skar Skath Skaval Skavax Skavik Slake Snarl Sneth
        Sorath Sorn Sothis Sovak Soveth Sovik Span Spire Spite Splendor
        Strix Stygian Styx Surath Suthal Svarax Syrak Syreth Taceth Talon
        Talvax Tameth Tarath Tarvax Tasith Taval Tavel Taxis Tearath Teln
        Tenax Teral Terath Terrax Terrix Thane Thax Thennis Theral Therax
        Theron Theros Theth Thraex Thrak Threx Thrix Thront Thrul Thul
        Thun Thurak Tidax Tieval Tireth Tirith Tivax Torak Torhal Torik
        Torith Torm Tormix Torval Toryn Torvex Torvik Toxis Traeth Traval
        Travax Traveth Travik Tread Tremor Tresh Treval Trevax Treveth
        Trikon Trilix Trimath Trinax Trirath Tristhal Trivex Trixal Tromix
        Trueth Truvax Truveth Turath Tykal Tyrax Tyrith Ulvax Umbral Undal
        Undrak Undris Unholy Unlax Unrath Urdak Urdax Urdrath Urvax Usurp
        Vaketh Valith Valorax Valth Valtis Vanquish Varak Varath Varvax
        Vashal Vaxis Vedath Velith Venax Veral Verath Vereth Verix Verok
        Vethal Vexis Vilex Virath Virax Visceral Vithal Vitrax Volvax
        Vorath Vorthral Voxis Vral Vraxis Vreth Vrix Vukath Vurax Vyrath
        Warden Warg Waroth Wrath Wroth Xalan Xarath Xareth Xarix Xarkon
        Xenos Xirath Xivath Xivax Xivik Xolvax Xovath Xovax Xovik Xylax
        Yaketh Yareth Yarvax Yasith Yathal Yelath Yelvax Yereth Yevath
        Yreth Yrivax Yromath Ythral Yulax Yuleth Zaleth Zalik Zalivax
        Zarkon Zarok Zarath Zarik Zaveth Zavik Zedal Zelith Zenith Zerax
        Zereth Zerix Zerkon Zineth Zirath Zirik Zorath Zorik Zurax Zureth
      ],

      "middle_earth" => %w[
        Aduial Aegnor Aelindel Aelvir Aelvorn Aenur Aerindel Aerith Aerloth
        Aernor Aeroth Aervir Aervor Aethor Aevorn Agarond Aglarond Aglaros
        Ainur Alatar Aldaron Alduial Alfirin Almaren Alorvorn Alquarond
        Altamir Altarond Althindel Amandil Amanil Ambaril Ambaril Ambarvorn
        Ambervorn Ambindel Ambivorn Amborvorn Ambrivorn Amdalvorn Amdiral
        Amdivorn Amelvorn Amelvorn Amenil Ameril Amethil Amethvorn Amindel
        Amilindel Aminil Aminvorn Amiorvorn Amirindel Amiril Amirvorn
        Amistil Amistindel Amistinvorn Amistivorn Amloth Amondel Amonil
        Amonvorn Amordel Amorvorn Amovorn Ampindel Ampivorn Amroth Amrundel
        Amrunvorn Amrvorn Amtindel Amtivorn Amuldel Amulvorn Amundel
        Amunvorn Amvorn Anariel Anarond Andamir Andarond Andirindel Andorvorn
        Andrimil Andrinvorn Anduvor Anduvorn Anduvornith Anfalas Angbor
        Angrenost Angrist Anhindel Anivorn Anjindel Anjivorn Ankindel
        Anmindel Anmivorn Annatar Anondel Anonvorn Anor Anordel Anorvorn
        Anothindel Anotivorn Anphindel Anphivorn Anrindel Anrivorn Anrond
        Anrundel Anrunvorn Anrvorn Anthoindel Anthon Anthorivorn Anthron
        Anvorn Apindel Apivorn Arabor Arador Aranruth Aranthor Aratar
        Arbelindel Arbelvorn Arbindel Arbivorn Arcindel Arcivorn Ardamir
        Ardanor Ardaron Ardindel Ardivorn Ardorvorn Arelthor Arelvorn
        Arempindel Arempivorn Arendel Arephindel Arephivorn Arethindel
        Aretivorn Argon Ariel Arindel Arion Arivorn Arminuial Arnor Arorvorn
        Arpindel Arpivorn Arphindel Arphivorn Arravorn Arriindel Arriivorn
        Arrivorn Arrorvorn Arrvorn Artheindel Artheon Artheivorn Artheron
        Arthinvorn Arthivorn Arthoindel Arthoivorn Arthon Arthondel Arthonvorn
        Arthunvorn Arthuvorn Arundel Arunvorn Arvorn Asgon Ashindel Ashipindel
        Asindel Asivorn Asphindel Asphivorn Asprindel Asprivorn Asprond
        Assindel Assivorn Astindel Astivorn Astor Astrindel Astrivorn Astrond
        Atanatari Atherindel Atherivorn Athilindel Athilvorn Athinvorn
        Athivorn Athoindel Athoivorn Athon Athond Athondel Athonvorn
        Athorindel Athorivorn Athron Athronvorn Athundel Athunvorn Athuvorn
        Atindel Ativorn Atoindel Atoivorn Atondel Atonvorn Atovorn Atrivorn
        Atrond Atundel Atunvorn Aurindel Aurivorn Auron Auvorn Avindel
        Avivorn Baindel Baivorn Balindel Balivorn Balon Balond Balondel
        Balonvorn Balorindel Balorivorn Balron Balrond Balrondel Balronvorn
        Balunvorn Baluvorn Banindel Banivorn Barindel Barivorn Barlindel
        Barlond Barlonvorn Barnindel Barnivorn Barond Barondel Baronvorn
        Barond Barugon Baruthor Belegorn Belegur Belegurth Belegwind Belorn
        Beluindel Beluivorn Bemindel Bemivorn Beregor Beregond Beren Berendil
        Beringorn Berion Berkon Berlindel Berlivorn Bermindel Bermivorn
        Bertindel Bertivorn Beruvorn Biarnor Birindel Birivorn Biron
        Birond Birondel Bironvorn Bisindel Bisivorn Bolvorn Borivorn
        Borlorn Bornindel Bornivorn Boron Borond Borvorn Braindel Braivorn
        Brindel Brivorn Brond Brondel Bronvorn Brorind Brundel Brunvorn
        Calindel Calivorn Calion Calorn Calrond Calvorn Camlorn Carnil
        Carnil Caros Carth Caruindel Caruivorn Celeborn Celenorm Celegorn
        Celeporn Celorn Cendor Cenindel Cenivorn Cerindel Cerivorn Ceron
        Cerond Cervorn Cilthorn Cirindel Cirivorn Ciron Cirond Cirvorn
        Cloudrend Coindel Coivorn Colindel Colivorn Colon Colond Colvorn
        Corthorn Corvorn Crimsonlake Cuivorn Culdorn Culuinalda Curunir
        Dairindel Dairivorn Daindel Daivorn Dalindel Dalivorn Dalon Dalond
        Dalonvorn Dambindel Dambivorn Dambond Dambondel Dambonvorn Darivorn
        Darond Darvorn Delduvorn Delinvorn Delivorn Delorn Delorvorn
        Delron Delrond Delrondel Delronvorn Dendor Deron Derond Dervorn
        Dhindel Dhivorn Dindel Dinvorn Dirindel Dirivorn Diron Dirond
        Dirvorn Dorindel Dorivorn Doron Dorond Dorvorn Dothaindel Dothaivorn
        Duindel Duivorn Durindel Durivorn Duron Durond Durvorn Earnil
        Earnur Ecthelvorn Ecthorn Edain Eirendil Elaran Elbereth Elbind
        Eldalorn Eldalvorn Eldan Eldanar Eldanvorn Eldorn Elendil Elendor
        Eleorn Elerind Elesorn Elfborn Elforn Elindel Eliorn Elorn
        Elrond Elros Elruvorn Eluvorn Elvorn Emindel Emivorn Empirion
        Endor Endorn Enerind Energorn Enerorn Eorn Ereinion Erestor
        Eriador Erien Eriind Eriorn Eruvorn Eryn Estorn Evorn Ezindel
        Ezivorn Faeron Faervorn Fainthern Falindel Falivorn Falon Falond
        Falonvorn Falorn Falorvorn Falron Falrond Falrondel Falronvorn
        Fanorn Fararind Farond Farorvorn Farrind Farron Farrond Farronvorn
        Farvorn Felindel Felivorn Felon Felond Felvorn Fenindel Fenivorn
        Feorn Feron Ferond Ferorvorn Ferron Ferrond Ferronvorn Fervorn
        Fimbrin Findorn Finelvorn Finindel Finiorn Finorvorn Finrod Firon
        Firond Firvorn Flororn Forhindel Forhivorn Forhorn Foron Forond
        Forvorn Galador Galathil Galion Galorn Galrond Galvorn Garador
        Garahorn Garindel Garivorn Garorvorn Garron Garrond Garronvorn
        Garvorn Gildorn Gildornd Gileron Gilhorn Girindel Girivorn Giron
        Girond Girvorn Gladhindel Gladhivorn Gladhorn Glindel Glivorn
        Glororn Glorforn Glorfindel Glomorn Golindel Golivorn Golon
        Golond Golvorn Gondorn Gondovorn Gorbindel Gorbivorn Gorbon
        Gorbond Gorbondel Gorbonvorn Gorhorn Gorindel Gorivorn Goron
        Gorond Gorvorn Gothindel Gothivorn Gothon Gothond Gothondel
        Gothonvorn Gotvorn Govorn Graindel Graivorn Grindel Grivorn
        Grond Grondel Gronvorn Grorn Grovorn Gruvorn Guldorn Gulivorn
        Gulon Gulond Gulorn Gulvorn Gurthindel Gurthivorn Gurthon Gurthond
        Gurthondel Gurthonvorn Gurvorn Haldir Haldorn Halindel Halivorn
        Halon Halond Halvorn Haradorn Hardindel Hardivorn Hardon Hardond
        Hardondel Hardonvorn Harivorn Harond Harvorn Heindel Heivorn
        Helon Helond Helvorn Hendorn Hernindel Hernivorn Heron Herond
        Hervorn Hilindel Hilivorn Hilon Hilond Hilvorn Hirindel Hirivorn
        Hiron Hirond Hirvorn Holindel Holivorn Holon Holond Holvorn
        Horindel Horivorn Horon Horond Horvorn Hrivorn Hulindel Hulivorn
        Hulon Hulond Hulorn Hulvorn Hurivorn Huron Hurond Hurvorn
        Idorn Ilindel Ilivorn Ilon Ilond Ilvorn Imorn Indorn Inorvorn
        Iorn Irindel Irivorn Iron Irond Irvorn Iston Istor Istorn Ithilvorn
        Ivorn Kalorn Kamlorn Karidorn Karivorn Karon Karond Karvorn
        Kelorn Kelvorn Khindorn Khorn Kilorn Kilvorn Kindorn Kinorn
        Kironvorn Kolvorn Korivorn Koron Korond Korvorn Lamindel Lamivorn
        Lamon Lamond Lamondel Lamonvorn Lamorn Lamorvorn Lamron Lamrond
        Lamrondel Lamronvorn Lamvorn Lanindel Lanivorn Lanon Lanond Lanorn
        Lanvorn Larivorn Laron Larond Larvorn Legolas Lenvorn Leonindel
        Leoniorn Leonivorn Leonorn Leonvorn Lerivorn Leron Lerond Lervorn
        Lindorn Lindvorn Linindel Linivorn Linon Linond Linorn Linvorn
        Liron Lirond Lirvorn Lomon Lomond Lomondel Lomonvorn Lomorn
        Lomvorn Lorindel Lorivorn Loron Lorond Lorvorn Luindel Luivorn
        Luon Luond Luorn Luvorn Lyindorn Lyindvorn Lyrindel Lyrivorn
        Maedorn Maglorn Maindel Maivorn Malindel Malivorn Malon Malond
        Malorn Malvorn Manindel Manivorn Manon Manond Manonvorn Manvorn
        Maorn Marindel Marivorn Maron Marond Marvorn Melorn Melvorn
        Mendorn Menelvorn Menindel Menivorn Menon Menond Menorn Menvorn
        Millorn Mindorn Mineorn Minindel Minivorn Minon Minond Minorn
        Minvorn Mirivorn Miron Mirond Mirvorn Mithriorn Mivorn Moldorn
        Molorn Mondorn Monindel Monivorn Monon Monond Monorn Monvorn
        Morgoth Morindel Morivorn Moron Morond Morvorn Muldorn Mulivorn
        Mulon Mulond Mulorn Mulvorn Murivorn Muron Murond Murvorn Naldorn
        Nalivorn Nalon Nalond Nalorn Nalvorn Namorvorn Nanindel Nanivorn
        Nanon Nanond Nanorn Nanvorn Narivorn Naron Narond Narsil Narvorn
        Neldorn Neldvorn Nelindel Nelivorn Nelon Nelond Nelorn Nelvorn
        Nerivorn Neron Nerond Nervorn Nessivorn Nildorn Nilvorn Nindorn
        Nindvorn Ninindel Ninivorn Ninon Ninond Ninorn Ninvorn Nirivorn
        Niron Nirond Nirvorn Noldorn Noldvorn Nolindel Nolivorn Nolon
        Nolond Nolorn Nolvorn Norivorn Noron Norond Norvorn Nuldorn
        Nulivorn Nulon Nulond Nulorn Nulvorn Nurivorn Nuron Nurond Nurvorn
        Oiolaire Oirindel Oirivorn Oiron Oirond Oirvorn Olorivorn Oloron
        Olorond Olorvorn Omindel Omivorn Omon Omond Omondel Omonvorn
        Omorn Omvorn Ondorn Ondvorn Onindel Onivorn Onon Onond Onorn
        Onvorn Orendorn Orivorn Oron Orond Orvorn Ostorn Otheindel
        Otheivorn Otheron Otherond Otheronvorn Othivorn Othon Othond
        Othoivorn Othoron Othorond Othoronvorn Othron Othrond Othrondel
        Othronvorn Otvorn Ovorn Palantir Parvorn Pelorn Pelvorn Perindel
        Perivorn Peron Perond Pervorn Pilindel Pilivorn Pilon Pilond
        Pilorn Pilvorn Pirivorn Piron Pirond Pirvorn Polivorn Polon
        Polond Polorn Polvorn Privorn Proindel Proivorn Proron Prorond
        Proronvorn Provorn Pruindel Pruivorn Pruron Prurond Pruronvorn
        Pruvorn Randorn Ranindel Ranivorn Ranon Ranond Ranorn Ranvorn
        Rondorn Rondvorn Ronindel Ronivorn Ronon Ronond Ronorn Ronvorn
        Rorimac Rorivorn Roron Rorond Rorvorn Ruldorn Rulivorn Rulon
        Rulond Rulorn Rulvorn Rurivorn Ruron Rurond Rurvorn Saldorn
        Salivorn Salon Salond Salorn Salvorn Sanindel Sanivorn Sanon
        Sanond Sanorn Sanvorn Sarivorn Saron Sarond Sarvorn Seldorn
        Selvorn Sendorn Senvorn Silindel Silivorn Silon Silond Silorn
        Silvorn Sindorn Sindvorn Sinindel Sinivorn Sinon Sinond Sinorn
        Sinvorn Sirivorn Siron Sirond Sirvorn Solindel Solivorn Solon
        Solond Solorn Solvorn Sorivorn Soron Sorond Sorvorn Sulivorn
        Sulon Sulond Sulorn Sulvorn Surivorn Suron Surond Survorn Talindel
        Talivorn Talon Talond Talorn Talvorn Tanindel Tanivorn Tanon
        Tanond Tanorn Tanvorn Tarindel Tarivorn Taron Tarond Tarvorn
        Telindel Telivorn Telon Telond Telorn Telvorn Tenindel Tenivorn
        Tenon Tenond Tenorn Tenvorn Terindel Terivorn Teron Terond Tervorn
        Thalindel Thalivorn Thalon Thalond Thalorn Thalvorn Thanindel
        Thanivorn Thanon Thanond Thanorn Thanvorn Tharivorn Tharon Tharond
        Tharvorn Thel Thelindel Thelivorn Thelon Thelond Thelorn Thelvorn
        Thenindel Thenivorn Thenon Thenond Thenorn Thenvorn Therivorn
        Theron Therond Thervorn Thinindel Thinivorn Thinon Thinond Thinorn
        Thinvorn Thirivorn Thiron Thirond Thirvorn Thorindel Thorivorn
        Thoron Thorond Thororn Thorvorn Thundorn Thunvorn Thusindel
        Thusivorn Thuson Thusond Thusorn Thusvorn Tilindel Tilivorn Tilon
        Tilond Tilorn Tilvorn Tinindel Tinivorn Tinon Tinond Tinorn
        Tinvorn Tirivorn Tiron Tirond Tirvorn Tomindel Tomivorn Tomon
        Tomond Tomondel Tomonvorn Tomorn Tomvorn Tondorn Tondvorn Tonindel
        Tonivorn Tonon Tonond Tonorn Tonvorn Torivorn Toron Torond Torvorn
        Tulivorn Tulon Tulond Tulorn Tulvorn Turivorn Turon Turond Turvorn
        Ulindel Ulivorn Ulon Ulond Ulorn Ulvorn Unindel Univorn Unon
        Unond Unorn Unvorn Urivorn Uron Urond Urvorn Vaindel Vaivorn
        Valon Valond Valorn Valvorn Vanindel Vanivorn Vanon Vanond Vanorn
        Vanvorn Varivorn Varon Varond Varvorn Velindel Velivorn Velon
        Velond Velorn Velvorn Venindel Venivorn Venon Venond Venorn
        Venvorn Verivorn Veron Verond Vervorn Vilindel Vilivorn Vilon
        Vilond Vilorn Vilvorn Vinindel Vinivorn Vinon Vinond Vinorn
        Vinvorn Virivorn Viron Virond Virvorn Volindel Volivorn Volon
        Volond Volorn Volvorn Vorivorn Voron Vorond Vorvorn Vulivorn
        Vulon Vulond Vulorn Vulvorn Vurivorn Vuron Vurond Vurvorn
        Walindel Walivorn Walon Walond Walorn Walvorn Wandorn Wanindel
        Wanivorn Wanon Wanond Wanorn Wanvorn Warivorn Waron Warond
        Warvorn Welindel Welivorn Welon Welond Welorn Welvorn Winindel
        Winivorn Winon Winond Winorn Winvorn Wirivorn Wiron Wirond
        Wirvorn Wolindel Wolivorn Wolon Wolond Wolorn Wolvorn Worivorn
        Woron Worond Worvorn Wulindel Wulivorn Wulon Wulond Wulorn
        Wulvorn Wurivorn Wuron Wurond Wurvorn Yalindel Yalivorn Yalon
        Yalond Yalorn Yalvorn Yanindel Yanivorn Yanon Yanond Yanorn
        Yanvorn Yarivorn Yaron Yarond Yarvorn Yelindel Yelivorn Yelon
        Yelond Yelorn Yelvorn Yenindel Yenivorn Yenon Yenond Yenorn
        Yenvorn Yerivorn Yeron Yerond Yervorn Yilindel Yilivorn Yilon
        Yilond Yilorn Yilvorn Yinindel Yinivorn Yinon Yinond Yinorn
        Yinvorn Yirivorn Yiron Yirond Yirvorn Yolindel Yolivorn Yolon
        Yolond Yolorn Yolvorn Yorivorn Yoron Yorond Yorvorn Yulivorn
        Yulon Yulond Yulorn Yulvorn Yurivorn Yuron Yurond Yurvorn
        Zalindel Zalivorn Zalon Zalond Zalorn Zalvorn Zanindel Zanivorn
        Zanon Zanond Zanorn Zanvorn Zarivorn Zaron Zarond Zarvorn Zelindel
        Zelivorn Zelon Zelond Zelorn Zelvorn Zenindel Zenivorn Zenon
        Zenond Zenorn Zenvorn Zerivorn Zeron Zerond Zervorn Zilindel
        Zilivorn Zilon Zilond Zilorn Zilvorn Zinindel Zinivorn Zinon
        Zinond Zinorn Zinvorn Zirivorn Ziron Zirond Zirvorn Zolindel
        Zolivorn Zolon Zolond Zolorn Zolvorn Zorivorn Zoron Zorond Zorvorn
      ]
    }

    # Remove old proper_name entries before re-seeding
    LoreEntry.where(category: "proper_name").delete_all

    created = 0
    proper_names.each do |lore_type, names|
      names.each do |name|
        LoreEntry.create!(lore_type: lore_type, category: "proper_name", value: name)
        created += 1
      end
    end

    LoreEntry.clear_cache! if LoreEntry.respond_to?(:clear_cache!)
    puts "Done. Created: #{created}"
    puts "Total proper names: #{LoreEntry.where(category: 'proper_name').count}"
  end

  desc "Seed cultural proper names by origin (elfico, enano, humano, divino)"
  task seed_origin_names: :environment do
    origin_names = {
      # ── Faerun origin names ──────────────────────────────────────────────
      "faerun" => {
        "elfico" => %w[
          Aelindra Aerindel Aerith Aethon Ailindra Ailvorn Ainara Aindel
          Aireal Alindra Alindel Alivorn Aluvorn Amariel Amiriel Amriel
          Anairiel Anariel Anarindel Anindel Arivorn Arwen Asindel Asivorn
          Atheriel Athinvorn Aurel Aurindel Caladrel Calarel Calindra Calion
          Caliriel Calirel Calorel Calrindel Caluindel Celindra Celiriel
          Celindel Celivorn Ceniriel Cirindel Cirivorn Cithral Corialindel
          Crystindel Daeindel Daelindra Daevorn Dalindra Daliriel Delindra
          Delindel Delivorn Elaindra Elarion Elindra Elindel Elivorn Ellindra
          Eloindra Elrindel Eluvorn Eniriel Eolarindel Erindel Erivorn
          Erirethindel Etharindel Etindel Etivorn Faeindra Faerindel
          Faerirethindel Fairindel Galanthiel Galiriel Galivorn Garindel
          Garivorn Gilindra Gilindel Gilivorn Ilarindel Ilarirethindel
          Ilirethindel Ilivorn Ilindra Ilindel Irindel Irivorn Isindra
          Isindel Isivorn Larindel Larivorn Larindra Lirien Lirindel Lirivorn
          Lirindra Loindra Loindel Loivorn Luindra Luindel Luivorn Maelindra
          Maeliriel Maelindel Malivorn Malindra Malindel Miriel Mirindel
          Mirivorn Mirindra Naerindel Naerivorn Naeris Naerindra Nirindel
          Nirivorn Nirindra Saelindra Saelindel Saelivorn Sarindra Sarindel
          Sarivorn Sirindra Sirindel Sirivorn Solivorn Solindra Solindel
          Tarindel Tarivorn Tarindra Therindel Therivorn Therindra Tirindra
          Tirindel Tirivorn Ulivorn Ulindra Ulindel Valindra Valindel
          Valivorn Velindra Velindel Velivorn Vilindra Vilindel Vilivorn
          Xalindra Xalindel Xalivorn Yrindra Yrindel Yrivorn Zirindra
        ],
        "enano" => %w[
          Adrik Alberich Aldrik Aldi Aldur Aldric Amgrim Amthor Anrak
          Anvur Arik Arnak Arog Arrim Arruk Arund Baldar Balin Balkrak
          Balli Balran Balrin Banrak Banthor Bargrak Barkar Barnak Barthos
          Barunn Bathor Baudrak Beldak Beldor Belgrak Belgrin Beli Belik
          Belok Benrak Benthor Berak Berek Berkrak Berkrin Bernak Beron
          Berrak Berthor Birak Birnak Bjorn Bofri Boldar Bolrak Bolthor
          Bombak Bomrak Bondrak Bonthor Bordar Borgrak Borgrin Bornak
          Borthor Botrak Brakar Brakrak Braldak Branak Brandak Brannrak
          Branthor Brarik Brarkrak Bravar Brekrak Brendar Brindak Brindrak
          Brinthor Brokrak Bromdar Brondar Bronrak Bronthor Brugrak Brundar
          Brunrak Bruthor Dain Dalgrak Darak Darim Darrak Darthor Deldak
          Delrak Derrak Derthor Dirak Djrak Dorak Dornak Dorthor Drak
          Dranrak Drinthor Drograk Drondar Dronrak Dronthor Drukar Drundar
          Dunrak Dunthor Durak Durak Durin Durok Durthor Dwali Dwalin
          Falgrak Fali Falin Fanrak Farin Felrak Fenthor Ferak Fili Finkrak
          Finrak Finthor Firak Flendak Flindrak Flinthor Flokrak Flondak
          Flonrak Flonthor Fludrak Fnrak Fodrak Fonrak Fonthor Forak Fordak
          Forerak Forthor Fracrak Frandak Franrak Franthor Fredak Fredrak
          Fridak Fridrak Frimrak Frinthor Fundin Furrak Furthor Galrak
          Gargrak Garrak Garthor Gefrak Gelrak Gemrak Gendak Genrak Genthor
          Gerdak Gerrak Gerthor Gimli Gloim Gloin Glorrak Glorthor Gnarrak
          Gnordak Gnorthor Gofrak Golgrak Golrak Golthor Gonrak Gonthor
          Gordak Gorrak Gorthor Graldak Graldrak Granak Grandak Granrak
          Granthor Gronrak Gronthor Grudak Grudrak Grundak Grundrak Grundur
          Gundrak Gunrak Gunthor Gurak Gurrak Gurthor Gwindak Gwonrak
          Haldrak Halfrak Halrak Halthor Hamrak Hanrak Hanthor Hardak
          Harrak Harthor Herak Hildak Hilrak Hilthor Hindak Hinrak Hinthor
          Hograk Holrak Holthor Honrak Honthor Horak Horrak Horthor Hotrak
          Hraldak Hranak Hrandak Hrandrak Hranthor Hronrak Hurak Hurrak
          Hurthor Ildak Ilrak Ilthor Imdak Imrak Imthor Indak Inrak Inthor
          Jorak Jorrak Jorthor Kadrak Kalrak Kalthor Kanrak Kanthor Karik
          Karlrak Karthor Kelrak Kelthor Kenrak Kenthor Kerak Kerrak Kerthor
          Kildak Kilrak Kilthor Kindak Kinrak Kinthor Kili Kolin Kolrak
          Kolthor Konrak Konthor Korak Korrak Korthor Krak Krak Kril Krim
          Krin Krog Krolt Kronak Kronrak Kronthor Kundak Kunrak Kunthor
          Kurrak Kurthor Magrak Malrak Malthor Manrak Manthor Marik Marnak
          Marthor Marunn Meldak Melrak Melthor Mendak Menrak Menthor Merak
          Merrak Merthor Mildak Milrak Milthor Mindak Minrak Minthor Morak
          Morrak Morthor Mourak Muldak Mulrak Multhor Mundak Munak Munrak
          Munthor Murak Murrak Murthor Nain Naim Nak Nar Narak Nardak
          Narrak Narthor Neldak Nelrak Nelthor Nerak Nerrak Nerthor Nikrak
          Nildak Nilrak Nilthor Nordak Norak Norrak Northor Nudrak Nuldak
          Nurak Nurrak Nurthor Oin Onar Orim Ornak Orthor Osrak Osthor
          Otrak Othor Randak Ranrak Ranthor Rakdar Rakin Ralrak Ralthor
          Renak Renrak Renthor Rigrak Rilrak Rilthor Rolrak Rolthor Ronrak
          Ronthor Rurak Rurrak Rurthor Snorrak Snorthor Thain Thaldak
          Thalrak Thalthor Thandak Thanrak Thanthor Tharak Tharnak Thraldak
          Thrandak Thrandrak Thranthor Thronrak Thronthor Thurak Thurdak
          Thurrak Thurthor Tildak Tilrak Tilthor Tindak Tinrak Tinthor
          Torak Tornak Tralrak Tralthor Trandak Tranrak Tranthor Tronrak
          Tronthor Turak Turnak Waldak Walrak Walthor Weldak Welrak Wenthor
          Werak Werrak Werthor Wildak Wilrak Wilthor Woldak Wolrak Wolthor
        ],
        "humano" => %w[
          Adric Aelric Aldric Aldwin Alec Aleron Alric Althor Alvar Alwin
          Ander Andric Andrin Anorin Anselin Anthor Ardan Arden Ardric
          Armod Arnal Aron Arran Arren Arric Arrin Arthen Arwin Asan Asher
          Asin Aslon Asric Astral Athar Athen Athor Atran Avar Avelin
          Averil Avrin Baldric Balric Baric Barin Baron Barric Barrin
          Barthen Barthor Basric Belden Belric Bencin Bercin Berecin
          Berthin Berwin Bewin Bjorn Bladic Blaric Brecin Brendan Brenin
          Brennic Brenric Brenthin Brenthor Brewin Bricin Bridric Brindric
          Brinric Brolin Brondric Brorin Brunric Brunwin Caedric Caelan
          Caeric Caeron Cain Calan Calen Calic Calis Calon Caric Carin
          Caris Caron Carric Carrin Carthen Carthor Casric Casrin Catric
          Cedric Celan Celic Celis Celon Ceric Cerin Ceris Ceron Cerric
          Cerrin Certhen Certhor Colan Colic Colon Coric Corin Coris
          Cormic Corric Corrin Corthen Corthor Cosric Cosrin Cral Cranic
          Cranric Crelic Crelon Crenic Crenric Crenthin Crenthor Crewin
          Crimric Crinric Crondric Crorin Dacric Dalric Daric Darin Daris
          Daric Daron Darric Darrin Darthen Darthor Dasric Dasrin Davan
          Davel Daven Davin Davric Davrin Dawan Dawen Dawin Delan Delic
          Delon Deric Derin Deris Deron Derric Derrin Derthen Derthor
          Desric Desrin Devric Devrin Diric Dirin Diris Diron Dirric Dirrin
          Dolric Dorin Doris Doron Dorric Dorrin Dosric Dosrin Dovan Dradic
          Dralric Dranic Dranric Dranic Drenic Drenric Drenthin Drenthor
          Drewin Drian Dric Dricin Drigric Drimric Drinric Drondric Drorin
          Dusric Dusrin Ebric Edric Edrin Edron Edric Elan Elic Elis Elric
          Elrin Elron Elvric Elvrin Emric Emrin Enric Enrin Enron Enval
          Eodric Eolic Eolin Eorin Eoric Erdon Eredric Eredrin Eredron
          Eridon Eridric Eriric Eronric Ethan Evan Ewric Ewrin Fadric Falric
          Faric Farin Faris Faron Farric Farrin Farthen Farthor Fasric
          Fasrin Ferric Ferrin Ferthen Ferthor Feron Finric Finrin Finron
          Firan Firen Firm Firric Firrin Flodric Floric Florin Floron Florin
          Fodric Folic Forin Foric Foron Forric Forrin Forthen Forthor
          Fosric Fosrin Gadric Gaeric Galan Galic Galin Galis Galone Galric
          Garic Garin Garis Garon Garric Garrin Garthen Garthor Gasric
          Gasrin Gavin Geldric Gelric Geric Gerin Geris Geron Gerric Gerrin
          Gerthen Gerthor Gesric Gesrin Getric Getrin Gilric Gilrin Gilron
          Golan Golic Golon Goric Gorin Goris Goron Gorric Gorrin Gorthen
          Gorthor Gosric Gosrin Gradric Gralan Gralic Gralon Granic Granric
          Grarin Grasric Grathen Grathor Gredric Grelic Grelon Grenic
          Grenric Grenthin Grenthor Grewin Grian Gric Gridon Grigric
          Grimric Grinric Grondric Grorin Gulric Gulrin Gulron Guric Gurin
          Guris Guron Gurric Gurrin Gurthen Gurthor Gusric Gusrin Hadric
          Hadrin Hadron Haeric Haeric Halan Halic Halon Hanic Hanric
          Hanrin Hanthen Hanthor Haric Harin Haris Haron Harric Harrin
          Harthen Harthor Hasric Hasrin Hedric Hedrin Hedron Heric Herin
          Heris Heron Herric Herrin Herthen Herthor Hesric Hesrin Hilan
          Hilic Hilon Hinic Hinric Hinrin Hinthen Hinthor Hiric Hirin
          Hiris Hiron Hirric Hirrin Hirthen Hirthor Hisric Hisrin Hodric
          Holan Holic Holon Honic Honric Honrin Honthen Honthor Horic
          Horin Horis Horon Horric Horrin Horthen Horthor Hosric Hosrin
          Igric Igrin Igron Iric Irin Iris Iron Irric Irrin Irthen Irthor
          Jaelan Jaeric Jalon Janic Janric Janrin Janthen Janthor Jaric
          Jarin Jaris Jaron Jarric Jarrin Jarthen Jarthor Jasric Jasrin
          Kaelan Kaelin Kaelon Kalan Kalic Kalon Kanic Kanric Kanrin
          Kanthen Kanthor Karic Karin Karis Karon Karric Karrin Karthen
          Karthor Kasric Kasrin Kelan Kelic Kelon Kenic Kenric Kenrin
          Kenthen Kenthor Keric Kerin Keris Keron Kerric Kerrin Kerthen
          Kerthor Kesric Kesrin Kevan Kieran Kilan Kilic Kilon Kinic Kinric
          Kinrin Kinthen Kinthor Kiric Kirin Kiris Kiron Kirric Kirrin
          Kirthen Kirthor Kisric Kisrin Laelan Laelic Laelon Lanic Lanric
          Lanrin Lanthen Lanthor Laric Larin Laris Laron Larric Larrin
          Larthen Larthor Lasric Lasrin Lelan Lelic Lelon Lenic Lenric
          Lenrin Lenthen Lenthor Leric Lerin Leris Leron Lerric Lerrin
          Lerthen Lerthor Lesric Lesrin Loran Loric Loron Loric Lorin
          Lorric Lorrin Lorthen Lorthor Losric Losrin Madric Maeric Malan
          Malic Malon Manic Manric Manrin Manthen Manthor Maric Marin Maris
          Maron Marric Marrin Marthen Marthor Masric Masrin Mathin Matric
          Matrin Matron Melan Melic Melon Menic Menric Menrin Menthen
          Menthor Meric Merin Meris Meron Merric Merrin Merthen Merthor
          Mesric Mesrin Milan Milic Milon Minic Minric Minrin Minthen
          Minthor Miric Mirin Miris Miron Mirric Mirrin Mirthen Mirthor
          Misric Misrin Naelan Naelic Naelon Nalan Nalic Nalon Nanic Nanric
          Nanrin Nanthen Nanthor Naric Narin Naris Naron Narric Narrin
          Narthen Narthor Nasric Nasrin Nelan Nelic Nelon Nenic Nenric
          Nenrin Nenthen Nenthor Neric Nerin Neris Neron Nerric Nerrin
          Nerthen Nerthor Nesric Nesrin Nolan Nolic Nolon Nonic Nonric
          Nonrin Nonthen Nonthor Noric Norin Noris Noron Norric Norrin
          Northen Northor Nosric Nosrin Odan Odric Odrin Odron Olan Olic
          Olon Onic Onric Onrin Onthen Onthor Oran Oric Orin Oris Oron
          Orric Orrin Orthen Orthor Osric Osrin Paelan Paelic Paelon Palan
          Palic Palon Panic Panric Panrin Panthen Panthor Paric Parin Paris
          Paron Parric Parrin Parthen Parthor Pasric Pasrin Pelan Pelic
          Pelon Penic Penric Penrin Penthen Penthor Peric Perin Peris Peron
          Perric Perrin Perthen Perthor Pesric Pesrin Raelan Raelic Raelon
          Ralan Ralic Ralon Ranic Ranric Ranrin Ranthen Ranthor Raric Rarin
          Raris Raron Rarric Rarrin Rarthen Rarthor Rasric Rasrin Relan
          Relic Relon Renic Renric Renrin Renthen Renthor Reric Rerin Reris
          Reron Rerric Rerrin Rerthen Rerthor Resric Resrin Roland Rolan
          Rolic Rolon Ronic Ronric Ronrin Ronthen Ronthor Roric Rorin Roris
          Roron Rorric Rorrin Rorthen Rorthor Rosric Rosrin Saelan Saelic
          Saelon Salan Salic Salon Sanic Sanric Sanrin Santhen Santhor
          Saric Sarin Saris Saron Sarric Sarrin Sarthen Sarthor Sasric
          Sasrin Selan Selic Selon Senic Senric Senrin Senthen Senthor
          Seric Serin Seris Seron Serric Serrin Serthen Serthor Sesric
          Sesrin Taelan Taelic Taelon Talan Talic Talon Tanic Tanric Tanrin
          Tanthen Tanthor Taric Tarin Taris Taron Tarric Tarrin Tarthen
          Tarthor Tasric Tasrin Telan Telic Telon Tenic Tenric Tenrin
          Tenthen Tenthor Teric Terin Teris Teron Terric Terrin Terthen
          Terthor Tesric Tesrin Tolan Tolic Tolon Tonic Tonric Tonrin
          Tonthen Tonthor Toric Torin Toris Toron Torric Torrin Torthen
          Torthor Tosric Tosrin Ulric Ulrin Ulron Uric Urin Uris Uron
          Urric Urrin Urthen Urthor Usric Usrin Vaelan Vaelic Vaelon Valan
          Valic Valon Vanic Vanric Vanrin Vanthen Vanthor Varic Varin Varis
          Varon Varric Varrin Varthen Varthor Vasric Vasrin Velan Velic
          Velon Venic Venric Venrin Venthen Venthor Veric Verin Veris Veron
          Verric Verrin Verthen Verthor Vesric Vesrin Waelan Waelic Waelon
          Walan Walic Walon Wanic Wanric Wanrin Wanthen Wanthor Waric Warin
          Waris Waron Warric Warrin Warthen Warthor Wasric Wasrin Welan
          Welic Welon Wenic Wenric Wenrin Wenthen Wenthor Weric Werin Weris
          Weron Werric Werrin Werthen Werthor Wesric Wesrin Xaelan Xaelic
          Xaelon Xalan Xalic Xalon Xanic Xanric Xanrin Xanthen Xanthor
          Xaric Xarin Xaris Xaron Xarric Xarrin Xarthen Xarthor Xasric
          Xasrin Yaelan Yaelic Yaelon Yalan Yalic Yalon Yanic Yanric Yanrin
          Yanthen Yanthor Yaric Yarin Yaris Yaron Yarric Yarrin Yarthen
          Yarthor Yasric Yasrin Zaelan Zaelic Zaelon Zalan Zalic Zalon
          Zanic Zanric Zanrin Zanthen Zanthor Zaric Zarin Zaris Zaron
          Zarric Zarrin Zarthen Zarthor Zasric Zasrin
        ],
        "divino" => %w[
          Aedis Aeon Aethar Aetheris Agnus Albus Alveus Amplus Ancilla
          Animus Apotheos Arcanum Arduis Ardus Ariel Arion Armod Arvus
          Astral Astra Astrum Auctor Auge Augur Aurel Auris Aurius Aurum
          Axis Azoth Belorus Berus Bonus Caeli Caelum Caelus Caelos
          Caelian Calix Candor Capax Carum Castus Celes Celest Celesta
          Celestis Celsius Cerus Chorus Civis Clar Clara Claris Claru
          Clarus Clavis Coelum Collum Culmen Cursor Datus Decus Dextra
          Divinus Divin Donum Donus Durus Empyrea Empyrean Empyrus Fabel
          Fabes Faber Factu Factum Fatum Fermu Firmis Firmus Flamen
          Flammis Flamus Fulgor Furor Gaudiu Gaudius Glori Gloria Gloriam
          Gracis Gracius Gratum Gravis Honoru Honor Honoris Ilumen Imbuta
          Imbutus Immotu Immotus Impetu Inviolus Ira Iubar Iugum Iunctus
          Iustis Iustus Ius Latus Laudis Laus Legis Lex Libo Licor Litor
          Litore Litoris Lotus Lucens Lucere Lucet Lucex Lucius Lucis
          Lucus Lumen Luminus Luminis Lux Luxis Luxora Magne Magnus Magni
          Magnis Magnum Malus Maris Mare Matres Matro Matrum Meris Meritum
          Merus Mirande Mirandus Miro Mirus Mitis Modes Modestus Moris Mos
          Motu Motus Multu Multum Mundis Mundus Nobile Nobilis Noctis
          Nomine Nomen Norma Novus Numen Numin Numinus Numos Nuntius Nutus
          Obitus Omnis Opimus Optimus Orbis Ordinu Ordu Ordo Oriens Oris
          Ortus Pacius Pactum Paru Partus Patri Patris Pax Pius Placet
          Placidus Plenu Plenum Plenus Polis Potens Potentis Praeclum
          Primus Princeps Princip Probus Proprius Purus Ratus Rector Regis
          Rex Sacer Sacris Sacrum Sanctu Sanctum Sanctus Sanus Sapiu
          Sapius Sapiunt Scitu Scitus Sensu Senum Seraphu Seraph Seraphim
          Seraphus Serenus Signum Silva Simplex Sol Solaris Solis Solius
          Solus Splendeu Splendor Stabilis Statu Status Studiu Studius
          Suavis Sublimu Sublimus Sumus Summus Supreu Supremus Ter Terra
          Terreu Terreus Titu Titus Tonus Totus Tranqu Tranquil Unitus
          Unum Unus Usus Validu Validus Valor Vatus Vedis Velit Velius
          Vellus Velox Veneris Venus Verab Verbum Verus Vindex Vinex
          Viril Virilis Virtus Visus Vitae Vitalis Vitus Vivus Volatu
          Volatus Votu Votum Vox Vultu Vultus Zelus Zephyr
        ]
      },

      # ── Middle-earth origin names ────────────────────────────────────────
      "middle_earth" => {
        "elfico" => %w[
          Aelindel Aerindel Aerireth Aethindel Aethivorn Aindel Ailivorn
          Ailindel Ainuindel Ainuivorn Aliindel Aliivorn Alindel Alivorn
          Aluvorn Amarindel Amarivorn Amirindel Amiriivorn Amrindel
          Amrivorn Anarindel Anarivorn Anindel Anivorn Arivorn Arwen
          Asindel Asivorn Atherindel Atherivorn Athinvorn Aurivorn
          Aurindel Caladindel Calarivorn Calariindel Calirindel
          Calirivorn Caliindel Calivorn Calrindel Calrondel Caluindel
          Caluivorn Celindel Celivorn Ceniindel Ceniivorn Cerindel
          Cerivorn Ciindel Cirindel Cirivorn Cithindel Cithivorn
          Daeindel Daeiindel Daeiivorn Daelindel Daelireth Daelirindel
          Daerindel Daeriindel Daeriivorn Daerivorn Daindel Daivorn
          Dalindel Dalivorn Elbereth Eldalindel Eldalivorn Elindel
          Elivorn Ellindel Ellivorn Elrindel Elrivorn Eluindel Eluivorn
          Enarindel Enarivorn Enindel Enivorn Erindel Erivorn Eryindel
          Eryivorn Etharindel Etharivorn Etindel Etivorn Faerindel
          Faeriindel Faeriivorn Fairindel Faerivorn Fairivorn
          Galindel Galivorn Garindel Garivorn Gilindel Gilivorn
          Gildindel Gildivorn Ilarindel Ilariindel Ilariivorn Ilarivorn
          Ilirindel Iliriivorn Iliriivorn Ilirivorn Ilindel Ilivorn
          Irindel Irivorn Isindel Isivorn Larindel Larivorn Lirindel
          Lirivorn Loindel Loivorn Luindel Luivorn Maelindel Maelivorn
          Malindel Malivorn Mirindel Mirivorn Naerindel Naeriindel
          Naeriivorn Naerivorn Nirindel Nirivorn Saelindel Saelindel
          Saelivorn Sarindel Sarivorn Sirindel Sirivorn Solivorn
          Solindel Tarindel Tarivorn Therindel Therivorn Tirindel
          Tirivorn Ulivorn Ulindel Valindel Valivorn Velindel Velivorn
          Vilindel Vilivorn Xalindel Xalivorn Yrindel Yrivorn Zirindel
        ],
        "enano" => %w[
          Adrik Agni Albari Alberich Aldrik Aldur Amthor Anrak Anvur
          Arik Arnak Arog Arrim Arruk Arund Azaghâl Balin Balli Balrin
          Barunn Baudrak Belak Beldak Beldor Beli Belik Belok Beron
          Bifur Birak Bjorn Bofri Bofur Bolg Bolrak Bombur Borek Borin
          Borrak Braldak Brandak Brannak Brek Brendak Brindak Brokrak
          Bromdar Brondar Brundar Dain Dalgrak Darak Darrik Darthor
          Deldak Delrak Derrak Derthor Dirak Dorak Dornak Drak Dranrak
          Drograk Drondar Drundar Dunrak Durak Durin Durok Dwali Dwalin
          Falgrak Fali Falin Fanrak Farin Felrak Fili Finrak Flendak
          Fundin Furrak Galrak Gimli Gloin Glorrak Gnarl Gnordak
          Goldur Gorgrak Gorrak Grudak Grundak Grundur Gundrak Gunrak
          Gurak Gwindak Haldrak Halrak Hamrak Hanrak Hardak Harrak
          Hildak Hilrak Hindak Horak Hraldak Hranak Hrandak Hronrak
          Hurak Ildak Imrak Indak Jorak Kadrak Kalrak Kanrak Karik
          Karlrak Keldak Kelrak Kenrak Kerak Kildak Kilrak Kili Kolrak
          Kondrak Korak Korrak Krak Krim Krin Krog Kundak Kunrak
          Kurrak Magrak Malrak Manrak Marik Meldak Melrak Mendak Merak
          Merrak Mildak Milrak Mindak Morak Morrak Muldak Mulrak Mundak
          Murak Murrak Nain Nar Narak Nardak Narrak Neldak Nelrak
          Nerak Nerrak Nikrak Nildak Nordak Norak Norrak Nudrak Nuldak
          Nurak Nurrak Oin Onar Orim Ornak Osrak Otrak Randak Ranrak
          Rakdar Rakin Ralrak Renak Renrak Rigrak Rilrak Rolrak Ronrak
          Rurak Rurrak Snorrak Tain Thaldak Thalrak Thandak Thanrak
          Tharak Tharnak Thraldak Thrandak Thrandrak Thranrak Thronrak
          Thurak Thurdak Thurrak Tildak Tilrak Tindak Tinrak Torak
          Tornak Tralrak Trandak Tranrak Tronrak Turak Turnak Waldak
          Walrak Weldak Welrak Werak Werrak Wildak Wilrak Woldak Wolrak
        ],
        "humano" => %w[
          Adric Aelric Aldric Aldwin Alec Aleron Alric Althor Alvar
          Alwin Ander Andric Andrin Anorin Anselin Anthor Ardan Arden
          Ardric Armod Arnal Aron Arran Arren Arric Arrin Arthen Arwin
          Asan Asher Asin Aslon Asric Astral Athar Athen Athor Atran
          Avar Avelin Averil Avrin Baldric Balric Baric Barin Baron
          Barric Barrin Barthen Barthor Basric Belden Belric Bercin
          Berthin Berwin Bewin Brecin Brendan Brenin Brennic Brenric
          Caedric Caelan Caeric Caeron Cain Calan Calen Calic Calis
          Calon Caric Carin Caris Caron Carric Carrin Carthen Carthor
          Cedric Celan Celic Celon Ceric Cerin Ceris Ceron Cerric
          Cerrin Certhen Certhor Colan Colic Colon Coric Corin Coris
          Cormic Dacric Dalric Daric Darin Daris Daric Daron Darric
          Darrin Darthen Darthor Davan Davel Daven Davin Davric Davrin
          Dawan Dawen Dawin Delan Delic Delon Deric Derin Deris Deron
          Derric Derrin Derthen Derthor Devric Devrin Diric Dirin
          Diris Diron Dirric Dirrin Dolric Dorin Doris Doron Dorric
          Dorrin Ebric Edric Edrin Edron Elan Elic Elis Elric Elrin
          Elron Elvric Elvrin Emric Emrin Enric Enrin Enron Enval
          Eodric Eolic Eolin Eorin Eoric Erdon Eredric Eredrin Eredron
          Eridon Eridric Eriric Ethan Evan Fadric Falric Faric Farin
          Faris Faron Farric Farrin Farthen Farthor Ferric Ferrin
          Ferthen Ferthor Feron Finric Finrin Finron Firan Firen
          Floric Florin Floron Fodric Folic Forin Foric Foron Forric
          Forrin Forthen Forthor Gadric Gaeric Galan Galic Galin Galis
          Galone Galric Garic Garin Garis Garon Garric Garrin Garthen
          Garthor Gavin Geldric Gelric Geric Gerin Geris Geron Gerric
          Gerrin Gerthen Gerthor Gilric Gilrin Gilron Golan Golic Golon
          Goric Gorin Goris Goron Gorric Gorrin Gorthen Gorthor
          Gradric Gralan Gralic Gralon Granic Granric Grarin Gredric
          Grelic Grelon Grenic Grenric Grenthin Grenthor Grewin Grian
          Gulric Gulrin Gulron Guric Gurin Guris Guron Gurric Gurrin
          Gurthen Gurthor Hadric Hadrin Hadron Haeric Halan Halic
          Halon Hanic Hanric Hanrin Hanthen Hanthor Haric Harin Haris
          Haron Harric Harrin Harthen Harthor Hedric Hedrin Hedron
          Heric Herin Heris Heron Herric Herrin Herthen Herthor
          Hilan Hilic Hilon Hinic Hinric Hinrin Hinthen Hinthor
          Hiric Hirin Hiris Hiron Hirric Hirrin Hirthen Hirthor
          Hodric Holan Holic Holon Honic Honric Honrin Honthen Honthor
          Horic Horin Horis Horon Horric Horrin Horthen Horthor
          Igric Igrin Igron Iric Irin Iris Iron Irric Irrin Irthen
          Jaelan Jaeric Jalon Janic Janric Janrin Janthen Janthor
          Jaric Jarin Jaris Jaron Jarric Jarrin Jarthen Jarthor
          Kaelan Kaelin Kaelon Kalan Kalic Kalon Kanic Kanric Kanrin
          Kanthen Kanthor Karic Karin Karis Karon Karric Karrin
          Karthen Karthor Kelan Kelic Kelon Kenic Kenric Kenrin
          Kenthen Kenthor Keric Kerin Keris Keron Kerric Kerrin
          Kerthen Kerthor Kevan Kieran Kilan Kilic Kilon Kinic Kinric
          Kinrin Kinthen Kinthor Kiric Kirin Kiris Kiron Kirric Kirrin
          Kirthen Kirthor Laelan Laelic Laelon Lanic Lanric Lanrin
          Lanthen Lanthor Laric Larin Laris Laron Larric Larrin
          Larthen Larthor Lelan Lelic Lelon Lenic Lenric Lenrin
          Lenthen Lenthor Leric Lerin Leris Leron Lerric Lerrin
          Lerthen Lerthor Loran Loric Loron Loric Lorin Lorric Lorrin
          Lorthen Lorthor Madric Maeric Malan Malic Malon Manic Manric
          Manrin Manthen Manthor Maric Marin Maris Maron Marric Marrin
          Marthen Marthor Mathin Matric Matrin Matron Melan Melic
          Melon Menic Menric Menrin Menthen Menthor Meric Merin Meris
          Meron Merric Merrin Merthen Merthor Naelan Naelic Naelon
          Nalan Nalic Nalon Nanic Nanric Nanrin Nanthen Nanthor Naric
          Narin Naris Naron Narric Narrin Narthen Narthor Nolan Nolic
          Nolon Nonic Nonric Nonrin Nonthen Nonthor Noric Norin Noris
          Noron Norric Norrin Northen Northor Odan Odric Odrin Odron
          Olan Olic Olon Onic Onric Onrin Onthen Onthor Oran Oric
          Orin Oris Oron Orric Orrin Orthen Orthor Paelan Paelic
          Paelon Palan Palic Palon Panic Panric Panrin Panthen Panthor
          Paric Parin Paris Paron Parric Parrin Parthen Parthor
          Raelan Raelic Raelon Ralan Ralic Ralon Ranic Ranric Ranrin
          Ranthen Ranthor Raric Rarin Raris Raron Rarric Rarrin
          Rarthen Rarthor Roland Rolan Rolic Rolon Ronic Ronric Ronrin
          Ronthen Ronthor Roric Rorin Roris Roron Rorric Rorrin
          Rorthen Rorthor Saelan Saelic Saelon Salan Salic Salon
          Sanic Sanric Sanrin Santhen Santhor Saric Sarin Saris Saron
          Sarric Sarrin Sarthen Sarthor Selan Selic Selon Senic Senric
          Senrin Senthen Senthor Seric Serin Seris Seron Serric Serrin
          Serthen Serthor Taelan Taelic Taelon Talan Talic Talon
          Tanic Tanric Tanrin Tanthen Tanthor Taric Tarin Taris Taron
          Tarric Tarrin Tarthen Tarthor Telan Telic Telon Tenic Tenric
          Tenrin Tenthen Tenthor Teric Terin Teris Teron Terric Terrin
          Terthen Terthor Tolan Tolic Tolon Tonic Tonric Tonrin
          Tonthen Tonthor Toric Torin Toris Toron Torric Torrin
          Torthen Torthor Ulric Ulrin Ulron Uric Urin Uris Uron
          Urric Urrin Urthen Urthor Vaelan Vaelic Vaelon Valan Valic
          Valon Vanic Vanric Vanrin Vanthen Vanthor Varic Varin Varis
          Varon Varric Varrin Varthen Varthor Velan Velic Velon Venic
          Venric Venrin Venthen Venthor Veric Verin Veris Veron Verric
          Verrin Verthen Verthor Waelan Waelic Waelon Walan Walic
          Walon Wanic Wanric Wanrin Wanthen Wanthor Waric Warin Waris
          Waron Warric Warrin Warthen Warthor Welan Welic Welon Wenic
          Wenric Wenrin Wenthen Wenthor Weric Werin Weris Weron Werric
          Werrin Werthen Werthor Xaelan Xaelic Xaelon Xalan Xalic
          Xalon Xanic Xanric Xanrin Xanthen Xanthor Xaric Xarin Xaris
          Xaron Xarric Xarrin Xarthen Xarthor Yaelan Yaelic Yaelon
          Yalan Yalic Yalon Yanic Yanric Yanrin Yanthen Yanthor
          Yaric Yarin Yaris Yaron Yarric Yarrin Yarthen Yarthor
          Zaelan Zaelic Zaelon Zalan Zalic Zalon Zanic Zanric Zanrin
          Zanthen Zanthor Zaric Zarin Zaris Zaron Zarric Zarrin
          Zarthen Zarthor
        ],
        "divino" => %w[
          Aedis Aeon Aethar Aethindel Ainur Albus Alveus Amplus Animus
          Arcanum Ardus Ariel Arion Astral Astra Astrum Auctor Auge
          Augur Aurel Auris Aurium Aurum Axis Azoth Belorus Bonus
          Caeli Caelum Caelus Calix Candor Capax Carum Castus Celest
          Celesta Celestis Celsius Chorus Clar Clara Claris Clarus
          Clavis Coelum Collum Culmen Cursor Datus Decus Dextra
          Divinus Donum Durus Empyrea Empyrean Empyrus Fabel Faber
          Fatum Fermus Firmus Flamen Flammis Fulgor Gaudius Glori
          Gloria Gloriam Gracius Gratum Gravis Honor Honoris Ilumen
          Imbuta Immotus Impetu Inviolus Iubar Iugum Iustis Iustus
          Laudis Laus Legis Lex Licor Litor Lucens Lucere Lucet Lucius
          Lucis Lucus Lumen Luminus Lux Luxis Luxora Magne Magnus
          Magnum Matres Matu Matrum Meritum Merus Mirande Mirandus
          Miro Mirus Mitis Modestus Moris Motus Multum Mundus Nobile
          Nobilis Noctis Nomen Norma Novus Numen Nuntius Nutus Omnis
          Opimus Optimus Orbis Ordo Oriens Oris Ortus Pacius Pactum
          Patri Patris Pax Pius Placidus Potens Potentis Primus
          Princeps Probus Proprius Purus Rector Regis Rex Sacer Sacrum
          Sanctum Sanctus Sanus Sapius Seraph Seraphim Seraphus
          Serenus Signum Silva Sol Solaris Solis Splendor Stabilis
          Status Studius Suavis Sublimus Summus Supremus Terra Titus
          Tonus Totus Tranquil Unitus Unum Unus Usus Validus Valor
          Vedis Velius Velox Venus Verbum Verus Vindex Virilis Virtus
          Visus Vitae Vitalis Vitus Vivus Volatus Votum Vox Vultus
          Zelus Zephyr
        ]
      }
    }

    # Remove old origin-keyed proper_name entries before re-seeding
    LoreEntry.where(category: "proper_name").where.not(key: nil).delete_all

    created = 0
    origin_names.each do |lore_type, origins|
      origins.each do |origin_key, names|
        names.each do |name|
          LoreEntry.create!(lore_type: lore_type, category: "proper_name", key: origin_key, value: name)
          created += 1
        end
      end
    end

    LoreEntry.clear_cache! if LoreEntry.respond_to?(:clear_cache!)
    puts "Done. Created: #{created}"
    puts "Total origin names: #{LoreEntry.where(category: 'proper_name').where.not(key: nil).count}"
  end
end
