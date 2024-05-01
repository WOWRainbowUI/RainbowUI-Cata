if GetLocale() ~= "ptBR" then
    return
end

---@type l10n
local l10n = QuestieLoader:ImportModule("l10n")

l10n.objectLookup["ptBR"] = {
[31] = "Estátua de Leão Antiga",
[32] = "Baú Afundado",
[33] = "Baú Trancado",
[34] = "Velho Garrafão",
[35] = "Maleta do Capitão",
[36] = "Barril Quebrado",
[41] = "Armário do Embaixador",
[47] = "PROCURA-SE: Tenente Mordente",
[52] = "A Queda de Gurubashi",
[54] = "A Tumba do Imperador",
[55] = "Corpo semi-devorado",
[56] = "Cadáver de Rodolfo",
[57] = "A lua cobre o vale",
[58] = "Gri'lek, o Errante",
[59] = "Monte de Terra Solta",
[60] = "Procura-se: Gath'Ilzogg",
[61] = "A Velha Lápide",
[68] = "Pôster de Procura-se",
[76] = "Jarra Vazia",
[119] = "Caixote do Abercrombie",
[256] = "PROCURA-SE",
[257] = "Barril Suspeito",
[259] = "Barril Semienterrado",
[261] = "Caixote Danificado",
[263] = "Suprimentos de Kurzen",
[264] = "Suprimentos de Kurzen",
[269] = "Barril de Cerveja do Trovão Protegido",
[270] = "Barril de Cerveja do Trovão Desprotegido",
[271] = "Caixotes da Liga dos Mineradores",
[272] = "Depósito de Carne de MacGrann",
[276] = "Cesta de Tremulerva",
[287] = "Registros do Contador Herodes",
[288] = "Cofre do Contador Herodes",
[290] = "Guarda-roupas do Taturana",
[321] = "Lágrima de Tirsa",
[324] = "Veio de Tório Escasso",
[331] = "Terra Solta",
[333] = "Relíquia Antiga",
[334] = "Relíquia Antiga",
[375] = "Abóbora de Tirisfal",
[711] = "Procura-se!",
[759] = "A Fonte Sagrada",
[1165] = "Livros do Tertuliano",
[1166] = "Baú do Aleixo",
[1557] = "Mesa de Jantar da Lillith",
[1560] = "Baú de Estoque",
[1561] = "Caixote Selado",
[1562] = "Baú do Marechal Haggard",
[1571] = "Grimórios Empoeirados",
[1585] = "Carga Explosiva",
[1586] = "Caixote de Velas",
[1593] = "Barco Cheio de Cadáveres",
[1594] = "Prateleira de Livros de Berardo",
[1599] = "Cova Rasa",
[1609] = "Catapulta da Presa do Dragão",
[1617] = "Folha-prata",
[1618] = "Botão-da-paz",
[1619] = "Raiz-telúrica",
[1620] = "Magi-real",
[1621] = "Cravespinho",
[1622] = "Ervamossa",
[1623] = "Ácera-agreste",
[1624] = "Sangue-real",
[1627] = "Caixote de Dalaran",
[1628] = "Musgo-de-tumba",
[1673] = "Pinha Vil",
[1685] = "Forja",
[1720] = "Prato do Fido",
[1721] = "Bola e corrente presas",
[1722] = "Bola e Corrente Trancada",
[1723] = "Cogumelo Fuçalama",
[1727] = "Barril de Stout do Festeiro",
[1728] = "Tapete Empoeirado",
[1731] = "Veio de Cobre",
[1732] = "Veio de Estanho",
[1733] = "Veio de Prata",
[1734] = "Veio de Ouro",
[1735] = "Depósito de Ferro",
[1736] = "Carregamento de Ferro",
[1738] = "Documentos da Camarilha",
[1739] = "Documentos da Camarilha",
[1740] = "Documentos da Camarilha",
[1759] = "Cartório de Eira dos Montes",
[1760] = "Estante de Livros Surrada",
[1761] = "Proclamação de Eira dos Montes",
[1763] = "PROCURA-SE",
[1765] = "Baú de Madeira Gasto",
[1767] = "Tumba de Helcolar",
[1768] = "Chama de Azel",
[1769] = "Chama de Veraz",
[1770] = "Chama de Uzel",
[2008] = "Perigo!",
[2039] = "Cofre Escondido",
[2040] = "Depósito de Mithril",
[2041] = "Raiz-da-vida",
[2042] = "Some-folha",
[2043] = "Bigode-de-hadgar",
[2044] = "Boquinha-do-inverno",
[2045] = "Estrangulalga",
[2046] = "Espinheira-dourada",
[2047] = "Depósito de Veraprata",
[2054] = "Veio de Estanho",
[2055] = "Veio de Cobre",
[2059] = "Cadáver Enânico",
[2068] = "Xerez de Pupellyverbos",
[2076] = "Caldeirão Borbulhante",
[2083] = "Correspondência dos Vela Sangrenta",
[2084] = "Raiz Almiscarada",
[2086] = "Cartas de Navegação dos Vela Sangrenta",
[2087] = "Ordens da Vela Sangrenta",
[2289] = "Bote Salva-vidas Arruinado",
[2553] = "Pergaminho Encharcado",
[2554] = "Charada do Cortello",
[2555] = "Pergaminho Mofado",
[2556] = "Tesouro de Cortello",
[2560] = "Garrafa Semienterrada",
[2576] = "Altar das Marés",
[2652] = "Cadáver de Ebenezer Ferratranca",
[2653] = "Depósito de Pedra-sangrenta Menor",
[2656] = "Carta Encharcada",
[2657] = "Lendas da Terra",
[2688] = "Pedra-chave",
[2689] = "Pedra da União Ocidental",
[2690] = "Pedra de Vínculo Exterior",
[2691] = "Pedra da União Oriental",
[2701] = "Fragmentos Iridescentes",
[2702] = "Pedra de Vínculo Interior",
[2703] = "Tumba de Matatroll",
[2704] = "Caixa de Explosivos",
[2707] = "Mapas da Extravagância da Donzela",
[2708] = "Mapas do Espírito de Pinhaprata",
[2709] = "Diário de Bordo da Extravagância da Donzela",
[2710] = "Diário de Bordo do Espírito de Pinhaprata",
[2712] = "Gema Élfica Calcificada",
[2713] = "Quadro de Procurados",
[2714] = "Granito de Alterac",
[2715] = "Pedestal Rúnico",
[2716] = "Baú de Trelane",
[2717] = "Caixote de Trelane",
[2718] = "Cofre de Trelane",
[2724] = "Saco de Aveia",
[2734] = "Baú Encharcado",
[2739] = "Baú da Pena Negra",
[2740] = "Baú da Garra de Corvo",
[2742] = "Baú da Nidificação",
[2743] = "Urna de Pedra com Gravuras",
[2744] = "Marisco Gigante",
[2843] = "Baú Desgastado",
[2844] = "Baú Gasto",
[2845] = "Baú Gasto",
[2846] = "Baú Gasto",
[2848] = "Pilar de Opala",
[2849] = "Baú Desgastado",
[2850] = "Baú Sólido",
[2852] = "Baú Sólido",
[2855] = "Baú Sólido",
[2857] = "Baú Sólido",
[2858] = "Pilar de Ametista",
[2866] = "Ignídea",
[2867] = "Caixote de Suprimentos da Escavação",
[2868] = "Mapa Amassado",
[2875] = "Esqueleto de Anão Danificado",
[2883] = "Abóbora Madura",
[2891] = "Crânios-troféu de Balia'mah",
[2892] = "Crânios-troféu de Ziata'jai",
[2893] = "Crânios-troféu de Zul'Mamwe",
[2907] = "Jarra d'Água",
[2908] = "Caixote de Suprimentos Lacrado",
[2910] = "Pedra de Poço",
[2912] = "Pinhâmbar",
[2933] = "Selo da Terra",
[3076] = "Mapa Sujo de Terra",
[3189] = "Plano de Ataque: Vale das Provações",
[3190] = "Plano de Ataque: Aldeia Sen'jin",
[3192] = "Plano de Ataque: Orgrimmar",
[3236] = "Caixa de Ferramentas Gnômica",
[3237] = "Lançanegra Aprisionado",
[3238] = "Barril Vazio do Chen",
[3239] = "Baú do Bento",
[3240] = "Ovos de Açoitacauda",
[3290] = "Saco de Suprimentos Roubado",
[3524] = "A Semente Demoníaca",
[3525] = "O Altar de Fogo",
[3640] = "Cogumelo Carregado",
[3642] = "Butim de Kolkar",
[3643] = "Maleta Velha",
[3644] = "Máquina Voadora de Bael Modan",
[3646] = "Cofre do General Duas-tranças",
[3658] = "Barril de Água",
[3659] = "Barril de Suco de Melão",
[3660] = "Caixote de Armaduras",
[3661] = "Caixote de Armas",
[3662] = "Caixote de Comida",
[3685] = "Monte de Terra Silitídeo",
[3689] = "Caixote de Armas",
[3690] = "Caixote de Comida",
[3691] = "Caixote de Comida",
[3693] = "Caixote de Comida",
[3694] = "Caixote de Comida",
[3695] = "Caixote de Comida",
[3702] = "Caixote de Armaduras",
[3703] = "Caixote de Armaduras",
[3704] = "Caixote de Armas",
[3705] = "Barril de Leite",
[3706] = "Barril de Néctar Doce",
[3707] = "Caixote de Comida",
[3714] = "Caixa-forte da Aliança",
[3715] = "Baú da Aliança",
[3719] = "Caixote de Comida",
[3724] = "Botão-da-paz",
[3725] = "Folha-prata",
[3726] = "Raiz-telúrica",
[3727] = "Magi-real",
[3729] = "Cravespinho",
[3730] = "Ervamossa",
[3737] = "Rachadura Borbulhante",
[3740] = "Rachadura Borbulhante",
[3743] = "Planta da Fenda",
[3763] = "Veio de Cobre",
[3764] = "Veio de Estanho",
[3767] = "Empório de Drizzlik",
[3768] = "Frágil - Não Deixe Cair",
[3972] = "PROCURA-SE",
[4072] = "Válvula Principal",
[4096] = "Baú da Aliança",
[4141] = "Painel de Controle",
[4149] = "Baú Sólido",
[4166] = "Ferramentas Alquímicas",
[4406] = "Ovos de Lenhateia",
[4608] = "Broto de Muscoide",
[5619] = "Pedra do Poder Defeituosa",
[5620] = "Pedras do Poder Defeituosas",
[5621] = "Pedras do Poder Defeituosas",
[6906] = "Ninho de Raptor Vermelho",
[6907] = "Ninho de Raptor Azul",
[6908] = "Ninho de Raptor Amarelo",
[7510] = "Fronde Desenvolvida",
[7923] = "Sementeira do Denalan",
[9630] = "Fóssil do Pançacheia",
[10076] = "Bacia de Vidência",
[11713] = "Cogumelo-cicuta",
[11714] = "Galho de Piolho",
[12654] = "Relíquia de Mathistra",
[12666] = "Tomo do Crepúsculo",
[13359] = "Estatueta de Gato",
[13360] = "Relíquia de Mathistra",
[13872] = "Relíquia de Mathistra",
[13873] = "Estatueta de Gato",
[13891] = "Ofídea",
[13949] = "Baú Coberto de Ferro",
[16393] = "Chama Antiga",
[16398] = "Canhão Défias",
[17155] = "Pólvora Défias",
[17182] = "Caixazorra 827",
[17183] = "Caixazorra 411",
[17184] = "Caixazorra 323",
[17185] = "Caixazorra 525",
[17188] = "A Fundação de Ameth'Aran",
[17189] = "A Queda de Ameth'Aran",
[17282] = "Pacote de Plantas",
[17783] = "Estatueta Ancestral",
[18036] = "Garrafa de Moléstia",
[18973] = "Foco de Arugal",
[19015] = "Lágrima de Eluna",
[19016] = "Arbusto de Poeira Estelar Coberto",
[19017] = "Marisco Gigante",
[19018] = "Marisco Gigante",
[19019] = "Caixa de Peças Sortidas",
[19020] = "Caixa de Peças Sortidas",
[19021] = "Baú Enferrujado",
[19022] = "Baú Gasto",
[19027] = "Tomo de Mel'Thandris",
[19030] = "Monturo de Terra",
[19283] = "Compêndio dos Caídos",
[19284] = "Mitologia dos Titãs",
[19534] = "Carta de Comenda de Anton",
[19541] = "Ovos de Fundolimo",
[19542] = "Ovos de Fundolimo",
[19595] = "Guarnição do Guarda-pórtico",
[19596] = "Esconderijo do Adormecido",
[19597] = "Esconderijo do Druida",
[19598] = "Esconderijo da Ermida",
[19599] = "Tesouro do Retiro do Gadanho",
[19602] = "Plano de Engenharia da Empreendimentos S.A.",
[19603] = "Documentos da Empreendimentos S.A.",
[19861] = "Diário de Henrig Monocelha",
[19868] = "Destroços de Carro-foguete",
[19869] = "Destroços de Carro-foguete",
[19870] = "Destroços de Carro-foguete",
[19871] = "Destroços de Carro-foguete",
[19872] = "Destroços de Carro-foguete",
[19873] = "Destroços de Carro-foguete",
[19877] = "Armário de Velinde",
[19878] = "Caixote de Peças",
[19879] = "Gema Anímica Vermelha",
[19901] = "Círculo de Encarceramento",
[19903] = "Veio de Indúrio",
[19904] = "Rapé de Mok'Morokk",
[19905] = "Beberagem de Mok'Morokk",
[19906] = "Cofre de Mok'Morokk",
[20351] = "Gema Anímica Azul",
[20352] = "Círculo de Encarceramento",
[20359] = "Ovo de Onyxia",
[20447] = "Comida de Harpia",
[20691] = "Maleta do Cosella",
[20725] = "O Legado dos Aspectos",
[20726] = "Início da Ameaça dos Mortos-vivos",
[20727] = "Caixote de Embarque da Pinacotreca",
[20737] = "Barril Espertamente Disfarçado",
[20805] = "Projeto Desprotegido do Rebu",
[20807] = "Braseiro Antigo",
[20920] = "Tubérculo Folhazul",
[20923] = "Pedra da Memória",
[20925] = "Maleta do Capitão",
[20985] = "Terra Solta",
[20992] = "Escudo Negro",
[21015] = "Pegadas de casco",
[21016] = "Pegadas de casco",
[21042] = "Insígnia da Guarda de Theramore",
[21052] = "Caixa-forte dos Défias",
[21277] = "Caixote com Furos",
[21530] = "Manual de Proprietário do Fungafuça",
[22234] = "Tocha Sinalizadora",
[22245] = "Saco de Carne",
[22246] = "Lágrima de Theradras",
[22550] = "Cristal de Draenetista",
[22706] = "Kit de Alquimia do Faustino",
[24776] = "Lápide de Yuriv",
[24798] = "Madeira Flutuante Seca ao Sol",
[26449] = "Recombobulador",
[28024] = "Baú da Caravana",
[28604] = "Caixote Espalhado",
[30854] = "Artefato Atal'ai",
[30855] = "Artefato Atal'ai",
[30856] = "Artefato Atal'ai",
[32569] = "Cofre do Galen",
[35251] = "Baú de Karnitol",
[35252] = "Relíquia Antiga",
[36738] = "O Livro de Ur",
[37098] = "Baú do Perrine",
[37099] = "Tabuleta Atal'ai",
[50935] = "Saco de Milho",
[50936] = "Saco de Cevada",
[50937] = "Saco de Centeio",
[50961] = "Baú de Malem",
[50982] = "O Carvalho Calcinado",
[51708] = "Terra da Cova de Eliza",
[58369] = "Baú de Ferro Roubado",
[58595] = "Tesouro da Lâmina Ardente",
[61935] = "Válvula de Regulagem",
[61936] = "Válvula de Controle de Combustível",
[65407] = "Máquina de Graznab",
[68865] = "Bastões de Comando do Fungafuça",
[73940] = "Veio de Prata Coberto de Gosma",
[73941] = "Veio de Ouro Coberto de Gosma",
[74447] = "Baú Grande Reforçado com Ferro",
[74448] = "Baú Grande Sólido",
[75293] = "Baú Desgastado Grande",
[75295] = "Baú Grande Reforçado com Ferro",
[75296] = "Baú Grande Reforçado com Ferro",
[75297] = "Baú Grande Reforçado com Ferro",
[75298] = "Baú Grande Sólido",
[75299] = "Baú Grande Sólido",
[75300] = "Baú Grande Sólido",
[83763] = "Livros Roubados",
[85563] = "Caixa-forte do Dente-podre",
[86492] = "Cratera de Elunita",
[89634] = "Coral de Ferro",
[89635] = "Casca Queimada de Sol",
[89931] = "Caldeirão de Bath'rah",
[91138] = "Martelo de Jardel",
[92013] = "Tomo do Conluio",
[92420] = "Minério do Bailor",
[92423] = "Baú Danificado",
[93192] = "Palocórdio",
[100028] = "Santuário Xamânico",
[101748] = "Santuário Xamânico",
[101749] = "Santuário Xamânico",
[101750] = "Santuário Xamânico",
[101751] = "Santuário Xamânico",
[102984] = "Caixa de Ferramentas de Bink",
[102985] = "Boca-de-leão de Balnir",
[102986] = "Pilha de Ju-ju",
[103574] = "Cofre de Contenção Cheio",
[103600] = "Estante de Livros de Andron",
[103628] = "Tratado de Ur sobre Umbromancia",
[103662] = "Morácea Carregada por Raio",
[103664] = "Rituais do Poder",
[103711] = "Veio de Estanho",
[103713] = "Veio de Cobre",
[103813] = "Selo do Mausoléu",
[103815] = "Cofre de Lenhâmbar",
[103820] = "Foguete Vermelho",
[103821] = "Caixa-forte de Doan",
[104564] = "Balde de Ferramentas do Bingles",
[104569] = "Balde de Ferramentas do Bingles",
[104574] = "Balde de Ferramentas do Bingles",
[104575] = "Detona-cuca do Gomez",
[104593] = "Gatilho do Mausoléu",
[105169] = "Cavalete de Armas dos Agamand",
[105170] = "Cavalete de Armas dos Agamand",
[105171] = "Cavalete de Armas dos Agamand",
[105172] = "Cavalete de Armas dos Agamand",
[105174] = "Baú de Cofres de Contenção",
[105175] = "Cantochão da Manifestação",
[105176] = "Cofre da Empreendimentos S.A.",
[105569] = "Veio de Prata",
[105570] = "Caixa-forte da Aliança",
[105578] = "Baú da Horda",
[105579] = "Baú da Aliança",
[105581] = "Baú da Aliança",
[106318] = "Baú Desgastado",
[106319] = "Baú Desgastado",
[111095] = "Baú da Aliança",
[112877] = "Bacia de Vidência do Didiê",
[112888] = "Prateleira Empoeirada",
[112948] = "Cofre Trancado do Intrépido",
[113531] = "Canhão",
[113757] = "Baú de Umbraforja",
[113768] = "Ovo Colorido Brilhante",
[113769] = "Ovo Colorido Brilhante",
[113770] = "Ovo Colorido Brilhante",
[113771] = "Ovo Colorido Brilhante",
[113791] = "Braseiro da Fonteterna",
[121264] = "Baú do Lucius",
[123214] = "Baú da Floresta do Crepúsculo",
[123310] = "Depósito de Mithril Coberto de Gosma",
[123329] = "Baú de Baelog",
[123330] = "Caixa-forte dos Bucaneiros",
[123331] = "Caixa-forte dos Bucaneiros",
[123332] = "Caixa-forte dos Bucaneiros",
[123333] = "Caixa-forte dos Bucaneiros",
[123462] = "A Joia dos Mares do Sul",
[123848] = "Veio de Tório Coberto de Gosma",
[124388] = "Baú da Família Garreta",
[124389] = "Baú do Krom Braçoforte",
[125477] = "Urna Evidente",
[126049] = "Colônia de Campânulas Magenta",
[126158] = "Cômoda de Tallonkai",
[126260] = "Baú Antigo",
[128293] = "Colônia de Campânulas Magenta",
[128308] = "Cova Rasa",
[128403] = "Cova Rasa",
[129127] = "Cofre de Gallywix",
[131474] = "Os Discos de Norgannon",
[131978] = "Baú Grande Reforçado com Mithril",
[131979] = "Baú de Lenhanegra Grande",
[138492] = "Estilhaços de Myzrael",
[138496] = "CapaTrompa",
[138497] = "Encaixe de bocal",
[139852] = "Memorial de Floriano Caxias",
[140911] = "Bobina de Seda Chartreuse Leve",
[140971] = "Gahz'ridian",
[141596] = "Baú do Mandingueiro",
[141812] = "Pedra de Vínculo",
[141832] = "Gongo de Zul'Farrak",
[141853] = "Tragão Violeta",
[141857] = "Pedra de Vínculo",
[141858] = "Pedra de Vínculo",
[141859] = "Pedra de Vínculo",
[141860] = "Canhão",
[141861] = "Canhão",
[141862] = "Canhão",
[141863] = "Canhão",
[141931] = "Ovo de Hipogrifo",
[141979] = "Tesouro Antigo",
[141980] = "Cofre Espectral",
[142071] = "Ovomático",
[142076] = "Maçãs Frescas da Clara",
[142088] = "Tabuleta da Vontade",
[142122] = "Pôster de Procura-se",
[142127] = "Segredo de Rin'ji",
[142140] = "Lótus Roxo",
[142141] = "Lágrimas-de-arthas",
[142142] = "Ervassol",
[142143] = "Ervacega",
[142144] = "Cogumelo-fantasma",
[142145] = "Sangue-de-grom",
[142151] = "Barril Lacrado",
[142179] = "Gazebo de Solarsal",
[142181] = "Carga Roubada",
[142184] = "Baú do Capitão",
[142185] = "Chama de Byltan",
[142186] = "Chama de Lahassa",
[142187] = "Chama de Imbel",
[142188] = "Chama de Samha",
[142189] = "Marco Inconspícuo",
[142191] = "Caixote de Suprimentos da Horda",
[142194] = "Tesouro dos Piratas!",
[142195] = "Mapa de Batalha de Patábua",
[142343] = "Pedestal de Uldum",
[142344] = "Extrapolador Artificial",
[142345] = "Matriz Perfuradora 3005-A",
[142475] = "Matriz Perfuradora 3005-B",
[142476] = "Matriz Perfuradora 3005-C",
[142477] = "Cofre do Termaplugue",
[142487] = "A Brastematic 5200",
[142696] = "Matriz Perfuradora 3005-D",
[142702] = "Garrafa de Peçonha",
[142703] = "Garrafa de Peçonha",
[142704] = "Garrafa de Peçonha",
[142705] = "Garrafa de Peçonha",
[142706] = "Garrafa de Peçonha",
[142707] = "Garrafa de Peçonha",
[142708] = "Garrafa de Peçonha",
[142709] = "Garrafa de Peçonha",
[142710] = "Garrafa de Peçonha",
[142711] = "Garrafa de Peçonha",
[142712] = "Garrafa de Peçonha",
[142713] = "Garrafa de Peçonha",
[142714] = "Garrafa de Peçonha",
[142715] = "Tabuleta de Theka",
[142958] = "Feralas: Uma História",
[144052] = "Poço do Posto Silitriste",
[144053] = "Aparelho de Inspeção do Anilhacido",
[144054] = "Baú da Shay",
[144063] = "Monolito de Equinex",
[144065] = "Carga Explosiva",
[144066] = "Primeira Jaula Cascasseca",
[144067] = "Segunda Jaula Cascasseca",
[144068] = "Terceira Jaula Cascasseca",
[144070] = "Gaiola do Bicoafiado",
[144071] = "Arquivos do Altovale",
[144072] = "Cartas do Altovale",
[144073] = "Relatórios do Altovale",
[144181] = "Espada do Rei Bárbaro",
[147557] = "Prata Roubada",
[148418] = "Chama Eterna",
[148419] = "Chama Eterna",
[148420] = "Chama Eterna",
[148421] = "Chama Eterna",
[148498] = "Altar de Suntara",
[148499] = "Caixa do Félix",
[148504] = "Lápide Evidente",
[148506] = "Artefato do Crepúsculo",
[148512] = "Fonte de Essência",
[148513] = "Tabuleta de Jin'yael",
[148514] = "Tabuleta de Markri",
[148515] = "Tabuleta de Sael'hai",
[148516] = "Tabuleta de Beth'Amara",
[148830] = "Estátua Atal'ai",
[148831] = "Estátua Atal'ai",
[148832] = "Estátua Atal'ai",
[148833] = "Estátua Atal'ai",
[148834] = "Estátua Atal'ai",
[148835] = "Estátua Atal'ai",
[148836] = "Altar de Hakkar",
[148838] = "Ídolo de Hakkar",
[148842] = "Gema de Mana do Jak",
[148917] = "Gongo",
[148998] = "Círculo de Evocação do Deus Maligno",
[149025] = "Braseiro Sentinela",
[149030] = "Braseiro Sentinela",
[149031] = "Braseiro Sentinela",
[149032] = "Braseiro Sentinela",
[149036] = "Baú do Marlon",
[149047] = "Tocha da Retribuição",
[149420] = "Ani",
[149480] = "Runa de Jin'yael",
[149481] = "Runa de Beth'Amara",
[149482] = "Runa de Markri",
[149483] = "Runa de Sael'hai",
[149502] = "Tesouro da Revoada Negra",
[150075] = "Cartaz de Procura-se",
[150079] = "Depósito de Mithril",
[150080] = "Veio de Ouro",
[150081] = "Depósito de Veraprata",
[150082] = "Veio de Tório Escasso",
[150140] = "Cristal Arcano de Concentração",
[151286] = "Tomo Kaldorei da Evocação",
[152094] = "Cogumelo Jacinto",
[152095] = "Lírio Lunapétala",
[152097] = "Braseiro de Belnistrasz",
[152608] = "Butim do Kolkar",
[152618] = "Butim do Kolkar",
[152620] = "Formação de Azsharita",
[152621] = "Formação de Azsharita",
[152622] = "Formação de Azsharita",
[152631] = "Formação de Azsharita",
[153123] = "Equipamento de Kam'arawn",
[153205] = "Altar do Profanador",
[153239] = "Pena de Coruscante",
[153451] = "Baú Sólido",
[153453] = "Baú Sólido",
[153454] = "Baú Sólido",
[153463] = "Baú Grande Sólido",
[153464] = "Baú Grande Sólido",
[153468] = "Baú Grande Reforçado com Mithril",
[153469] = "Baú Grande Reforçado com Mithril",
[153470] = "Caixote de Comida",
[153471] = "Caixote de Comida",
[153472] = "Caixote de Comida",
[153473] = "Caixote de Comida",
[153556] = "Relíquia Thaurissana",
[154357] = "Lama Irisada",
[156561] = "Pôster de Procura-se",
[157936] = "Monte de Terra de Un'Goro",
[160445] = "Restos de Sha'ni Altapresa",
[160836] = "Arca de Relíquia",
[160840] = "Monturo de Terra Macia",
[160845] = "Cofre Sombrio",
[161495] = "Cofre Secreto",
[161504] = "Um Pacote Pequeno",
[161505] = "Bote Naufragado",
[161513] = "Ovo de Galinha Caipira",
[161521] = "Equipamento de Pesquisa",
[161526] = "Caixote de Comestíveis",
[161527] = "Osso de Dinossauro",
[161557] = "Colheita da Madel",
[161752] = "Balde de Ferramentas",
[164658] = "Cristal de Poder Azul",
[164659] = "Cristal de Poder Verde",
[164660] = "Cristal de Poder Vermelho",
[164661] = "Cristal de Poder Amarelo",
[164662] = "Caixas de Equipamento",
[164689] = "Monumento de Franclorn Forjífice",
[164690] = "Estandarte de Krom'zar",
[164778] = "Cristal de Poder Azul",
[164779] = "Cristal de Poder Verde",
[164780] = "Cristal de Poder Vermelho",
[164781] = "Cristal de Poder Amarelo",
[164798] = "Raiz do Mal",
[164867] = "PROCURA-SE",
[164868] = "SE VIR, MATE",
[164869] = "Cálice Espectral",
[164881] = "Dragão Noturno Purificado",
[164882] = "Flor da Canção Purificada",
[164884] = "Botão Selvagem Purificado",
[164885] = "Dragão Noturno Corrompido",
[164886] = "Flor da Canção Corrompida",
[164887] = "Botão Selvagem Corrompido",
[164888] = "Raiz-açoite Corrompida",
[164909] = "Canoa Destruída",
[164910] = "Baú Ornamentado",
[164911] = "Barril de Cervaforte",
[164953] = "Mochilas Grandes de Couro",
[164954] = "Carapaça de Zukk'ash",
[164955] = "Torre de Cristal Norte",
[164956] = "Torre de Cristal Oeste",
[164957] = "Torre de Cristal Leste",
[164958] = "Broto de Pétala Sangrenta",
[165554] = "Coração da Montanha",
[165658] = "Depósito de Ferro Negro",
[165738] = "Caneca de Cerveja Ferro Negro",
[165739] = "Javali do Glutão Implacável",
[166863] = "Carcaça de Manguadonte Fresca",
[166872] = "Caixote de Suprimentos",
[169217] = "Rocha Lisa de Un'Goro",
[169243] = "Baú dos Sete",
[169294] = "Tabuletas dos Sete",
[171938] = "Sabra",
[171939] = "Flor da Canção Corrompida",
[171940] = "Flor da Canção Purificada",
[171943] = "Flor da Canção Purificada",
[173232] = "Instruções de Ferraria",
[173234] = "Instruções de Ferraria",
[173265] = "Banheiro de Madeira",
[173266] = "Livro de A. Massoaço",
[173284] = "Raiz-açoite Corrompida",
[173324] = "Dragão Noturno Corrompido",
[173325] = "Dragão Noturno Purificado",
[173326] = "Botão Selvagem Purificado",
[173327] = "Botão Selvagem Corrompido",
[174594] = "Flor da Canção Corrompida",
[174595] = "Flor da Canção Corrompida",
[174596] = "Flor da Canção Corrompida",
[174597] = "Flor da Canção Corrompida",
[174598] = "Flor da Canção Corrompida",
[174600] = "Botão Selvagem Corrompido",
[174601] = "Botão Selvagem Corrompido",
[174602] = "Botão Selvagem Corrompido",
[174603] = "Botão Selvagem Corrompido",
[174604] = "Botão Selvagem Corrompido",
[174605] = "Raiz-açoite Corrompida",
[174606] = "Raiz-açoite Corrompida",
[174607] = "Raiz-açoite Corrompida",
[174608] = "Dragão Noturno Corrompido",
[174609] = "Dragão Noturno Purificado",
[174610] = "Flor da Canção Purificada",
[174612] = "Flor da Canção Purificada",
[174613] = "Flor da Canção Purificada",
[174614] = "Flor da Canção Purificada",
[174615] = "Flor da Canção Purificada",
[174617] = "Botão Selvagem Purificado",
[174618] = "Botão Selvagem Purificado",
[174619] = "Botão Selvagem Purificado",
[174620] = "Botão Selvagem Purificado",
[174621] = "Botão Selvagem Purificado",
[174622] = "Raiz-açoite Purificado",
[174623] = "Raiz-açoite Purificado",
[174624] = "Raiz-açoite Purificado",
[174625] = "Raiz-açoite Purificado",
[174682] = "Cuidado com o Pterrordax",
[174684] = "Dragão Noturno Corrompido",
[174685] = "Dragão Noturno Purificado",
[174686] = "Raiz-açoite Corrompida",
[174687] = "Raiz-açoite Purificado",
[174708] = "Botão Selvagem Corrompido",
[174709] = "Botão Selvagem Corrompido",
[174710] = "Botão Selvagem Purificado",
[174711] = "Botão Selvagem Purificado",
[174712] = "Flor da Canção Corrompida",
[174713] = "Flor da Canção Corrompida",
[174714] = "Flor da Canção Purificada",
[174715] = "Flor da Canção Purificada",
[174728] = "Caixote Danificado",
[174848] = "Equipamento de Teste",
[175084] = "A Brastematic 5200",
[175085] = "A Brastematic 5200",
[175165] = "Baú do Aurora de Prata",
[175166] = "Baú do Véu das Brumas",
[175207] = "Criatura Marinha Encalhada",
[175226] = "Criatura Marinha Encalhada",
[175227] = "Criatura Marinha Encalhada",
[175230] = "Criatura Marinha Encalhada",
[175233] = "Criatura Marinha Encalhada",
[175245] = "Chama Paternal",
[175264] = "Essência da Reprodução",
[175265] = "Equipamento de Teste",
[175287] = "Braseiro",
[175298] = "Braseiro",
[175320] = "PROCURA-SE: Lodofundo!",
[175322] = "Selo Forjado da Ascensão",
[175324] = "Lascas de Friomalho",
[175329] = "Reservas de Castanha Bosquenero",
[175330] = "Reservas de Fruta Bosquenero",
[175331] = "Reservas de Grão Bosquenero",
[175334] = "Pertences de Biju",
[175382] = "Cofre do Finitudo",
[175384] = "Ovo de Mantícora de Alcândora",
[175385] = "Tabuleta de Pedranegra",
[175404] = "Veio de Tório Abundante",
[175407] = "Pena Lunamarca",
[175487] = "Terceira Tabuleta Mosh'aru",
[175488] = "Quarta Tabuleta Mosh'aru",
[175524] = "Cristal Vermelho Misterioso",
[175565] = "Ovo Alienígena",
[175566] = "Erva-do-emo",
[175571] = "Círculo de Evocação de Golpe do Ogro",
[175586] = "Carroça de Jaron",
[175587] = "Caixote Danificado",
[175588] = "Ovo de Aranha do Pináculo",
[175606] = "Ovo de Aranha do Pináculo",
[175607] = "Cadáver de Anão Ferro Negro",
[175608] = "Cadáver de Anão Ferro Negro",
[175609] = "Cadáver de Anão Ferro Negro",
[175628] = "Suprimentos do Jaron",
[175629] = "Suprimentos do Jaron",
[175704] = "Carta Chamuscada",
[175708] = "Caixote de Suprimentos da Encruzilhada",
[175785] = "Documentos Inconspícuos",
[175789] = "Rend Head Event Timer",
[175802] = "Cofre Pequeno",
[175886] = "Pique da Brutalidade",
[175888] = "Fragmento da Relíquia dos Altaneiros",
[175889] = "Ovo Velho",
[175891] = "Fragmento da Relíquia dos Altaneiros",
[175892] = "Fragmento da Relíquia dos Altaneiros",
[175893] = "Fragmento da Relíquia dos Altaneiros",
[175894] = "Embrulho da Janice",
[175924] = "Armário Trancado",
[175925] = "Casinha",
[175926] = "Diário da Sra. Dalson",
[175927] = "Catálogo de Málifo",
[175928] = "Agave Incendia",
[175944] = "Fogo da Vida Sagrado",
[175948] = "Sino de Alarme da Angra do Butim",
[175949] = "Quinta Tabuleta Mosh'aru",
[175950] = "Sexta Tabuleta Mosh'aru",
[175964] = "Pele de Sombra",
[175965] = "Fluido de Embalsamamento de Friomúrmuro",
[175966] = "Fio Escarlate Encantado",
[175970] = "Peitoral Rúnico Não Forjado",
[176089] = "Manoplas de Placa Crua",
[176090] = "Restos Humanos",
[176091] = "Caldeirão de Lenha Morta",
[176092] = "Caixa de Explosivos",
[176112] = "Cofre de Malor",
[176115] = "Pôster de Procura-se – Arnak Temível Totem",
[176116] = "Cabeça da Boneca de Pâmela",
[176142] = "Parte Esquerda da Boneca de Pâmela",
[176143] = "Parte Direita da Boneca de Pâmela",
[176145] = "Monumento do Josefo Trilharrubra",
[176150] = "Tomo Mofado",
[176151] = "Tomo Mofado",
[176158] = "Braseiro da Dor",
[176159] = "Braseiro da Malícia",
[176160] = "Braseiro do Sofrimento",
[176161] = "Braseiro do Ódio",
[176188] = "Vela Ritual",
[176189] = "Tartaruga Marinha Descarnada",
[176190] = "Tartaruga Marinha Encalhada",
[176191] = "Tartaruga Marinha Encalhada",
[176192] = "Catálogo do Imprevisível",
[176196] = "Tartaruga Marinha Encalhada",
[176197] = "Tartaruga Marinha Encalhada",
[176198] = "Tartaruga Marinha Encalhada",
[176206] = "Incunábulo de Davil",
[176207] = "Escudo de Trilharrubra",
[176208] = "Crânio de Horgus",
[176209] = "Espada Estilhaçada de Marduk",
[176213] = "Sangue dos Heróis",
[176215] = "Pilha de Balas de Canhão",
[176216] = "Canhão Escarlate",
[176217] = "Canhão Escarlate",
[176224] = "Caixote de Suprimentos",
[176225] = "Baú do Ado'niran",
[176245] = "Arquivo Escarlate",
[176248] = "Tabaco da Lata do Siabi",
[176249] = "Dados do Flagelo",
[176304] = "Caixote de Suprimentos",
[176306] = "Jaula",
[176307] = "Caixote de Suprimentos",
[176308] = "Caixote de Suprimentos",
[176309] = "Caixote de Suprimentos",
[176317] = "O Castelo Violeta",
[176325] = "Instruções de Ferraria",
[176327] = "Instruções de Ferraria",
[176344] = "Baú de Documentos",
[176356] = "Escritos Sagrados dos Altaneiros",
[176360] = "Embrulho da Caixa Postal",
[176361] = "Caldeirão do Flagelo",
[176392] = "Caldeirão do Flagelo",
[176393] = "Caldeirão do Flagelo",
[176484] = "A Escritura de Montalvo",
[176485] = "A Escritura de Castro das Flechas",
[176486] = "A Escritura de Costa Sul",
[176487] = "A Escritura da Serraria Tarren",
[176544] = "Restos Mortais de Eva Sarkhoff",
[176545] = "Restos Mortais de Lucien Sarkhoff",
[176581] = "Cristal da Mão de Iruxos",
[176582] = "Armadilha de Lagostim",
[176583] = "Sonsona-dourada",
[176584] = "Folha-de-sonho",
[176586] = "Sálvia-prata-da-montanha",
[176587] = "Pragônia",
[176588] = "Chapéu-de-gelo",
[176589] = "Lótus Preto",
[176630] = "Livro de Recordações",
[176631] = "Dádiva de Menethil",
[176634] = "Baú de Kerlonian",
[176635] = "Armadilha de Lagostim",
[176636] = "Ervassol",
[176637] = "Sangue-de-Grom",
[176638] = "Sonsona-dourada",
[176639] = "Folha-de-sonho",
[176640] = "Sálvia-prata-da-montanha",
[176641] = "Pragônia",
[176642] = "Lágrimas-de-arthas",
[176643] = "Veio de Tório Escasso",
[176645] = "Depósito de Mithril",
[176751] = "Ossos de Kodo",
[176752] = "Ossos de Kodo",
[176753] = "Erva-do-demo",
[176785] = "Caixote de Munições",
[176793] = "Feixe de Lenha",
[176944] = "Baú do Tesouro Antigo",
[177224] = "Troll Drum Sound Object",
[177226] = "Livro \"Adivinhação para Leigos\"",
[177240] = "Monte de Terra Solta",
[177241] = "Filactério de Araj",
[177243] = "Portal Demoníaco",
[177264] = "Símbolo da Honra Perdida",
[177287] = "Pintura Incompleta",
[177289] = "Caldeirão do Flagelo",
[177365] = "Portal Demoníaco",
[177366] = "Portal Demoníaco",
[177367] = "Portal Demoníaco",
[177368] = "Portal Demoníaco",
[177369] = "Portal Demoníaco",
[177388] = "Veio de Tório Abundante e Coberto de Gosma",
[177397] = "Portal Demoníaco",
[177398] = "Portal Demoníaco",
[177399] = "Portal Demoníaco",
[177400] = "Portal Demoníaco",
[177464] = "Cupinzeiro Grande",
[177490] = "Caixote da Serraria de Beiranorte",
[177491] = "Barril de Cupins",
[177544] = "Baú do Josefo",
[177624] = "Bolsa de Demônios de Zabraxxis",
[177667] = "Pergaminho Rasgado",
[177675] = "Monturo de Terra",
[177725] = "Apetrechos de Alquimia do Dredan",
[177726] = "Balde de Ferramentas",
[177747] = "Arquivos de Quel'Thalas",
[177750] = "Broto Fúngico Lunar",
[177784] = "Marisco de Casca Mole Gigante",
[177785] = "Recipiente de Adorno",
[177786] = "Baú de Rodovalho",
[177787] = "Diário de Rodovalho",
[177789] = "Livro-caixa do Augustus",
[177794] = "Cofre Estranho",
[177804] = "Restos Humanos Esquartejados",
[177805] = "Restos Humanos Esquartejados",
[177806] = "Restos Humanos Esquartejados",
[177807] = "Ovo de Dragão Negro",
[177808] = "Orbe de Dominância",
[177884] = "Doodad_UndercityWorm01",
[177904] = "Pôster de Procura-se: Besseleth",
[177926] = "Semente de Gaia",
[177927] = "Broto de Gaia de Tammra",
[177929] = "Monturo de Terra de Gaia",
[177964] = "Pedra das Profundezas",
[178084] = "Baú do Félix",
[178085] = "Balde de Parafusos do Félix",
[178087] = "Picareta de Thazz'ril",
[178090] = "Túmulo de Marla",
[178104] = "Cristal de Ressonita",
[178105] = "Cristal de Ressonita",
[178106] = "Cristal de Ressonita",
[178125] = "Lótus de Lotharian",
[178144] = "Baú dos Trolls",
[178145] = "Barril de Ressonita",
[178184] = "Safira de Aku'Mai",
[178185] = "Safira de Aku'Mai",
[178186] = "Safira de Aku'Mai",
[178195] = "Óleo dos Brado Guerreiro",
[178204] = "Carregamento de Machados dos Brado Guerreiro",
[178227] = "Cesto do Totem de Murgut",
[178229] = "Livro da Aurora",
[178244] = "Baú de Exercício",
[178245] = "Baú de Exercício",
[178246] = "Baú de Exercício",
[178325] = "Abra para passar pelo seu rito.",
[178444] = "Altar de Sha'gri",
[178464] = "Baú do Clérigo das Trevas Salem",
[178504] = "Baú Roubado",
[178526] = "Diário do Jack",
[178553] = "Receptáculo Colme'Ashi",
[178609] = "Neve de Feriado",
[178784] = "Suprimentos de Dentefrio",
[178785] = "Suprimentos dos Ferrofundo",
[179006] = "Documentos de Vanndar",
[179007] = "Documentos de Vanndar",
[179008] = "Documentos de Vanndar",
[179024] = "Estandarte dos Lançatroz",
[179025] = "Estandarte dos Lobo do Gelo",
[179125] = "Pertences da Azeitona",
[179426] = "Gri'lek, o Errante",
[179437] = "Procuram-se: ORCS!",
[179438] = "Procuram-se: ANÕES!",
[179485] = "Armadilha Quebrada",
[179486] = "Maleta Surrada",
[179487] = "Maleta Encharcada",
[179488] = "Maleta Surrada",
[179489] = "Maleta Encharcada",
[179490] = "Maleta Surrada",
[179491] = "Maleta Encharcada",
[179492] = "Maleta Amassada",
[179493] = "Maleta Mofada",
[179494] = "Maleta Amassada",
[179496] = "Maleta Amassada",
[179497] = "Maleta Mofada",
[179498] = "Maleta Escarlate",
[179499] = "Cesta de Tanino Ôgrico",
[179501] = "Tesouro do Fiapo Agulhacerta",
[179516] = "Baú de Fengus",
[179517] = "Tesouro dos Shen'dralar",
[179526] = "Vagem de Lenhatorta",
[179528] = "Vagem de Lenhatorta",
[179532] = "Vagem de Lenhatorta",
[179533] = "Vagem de Lenhatorta",
[179544] = "Restos Descarnados de Kariel Winthalus",
[179545] = "Baú do Príncipe",
[179547] = "Tomo Empoeirado",
[179548] = "Tomo Empoeirado",
[179551] = "Arca de Hidráxis",
[179552] = "Diagrama: Robô de Reparos em Campo 74A",
[179553] = "Fragmento de Núcleo",
[179559] = "Lasca de Vinhavil",
[179562] = "Lâmina Antiga Incandescente",
[179564] = "Homenagem a Gordok",
[179565] = "Relicário Empoeirado",
[179669] = "Símbolo da Missão de Montaria de Bruxo 1",
[179670] = "Símbolo da Missão de Montaria de Bruxo 2",
[179671] = "Símbolo da Missão de Montaria de Bruxo 3",
[179703] = "Baú do Senhor do Fogo",
[179782] = "Kit de Alquimia",
[179826] = "Instruções Secretas: Fluxo Ígneo",
[179827] = "Procurados/Desaparecidos/Achados e Perdidos",
[179828] = "Travesseiro de Ferro Negro",
[179832] = "Travesseiro Ornado da Alma Fada",
[179879] = "Orbe de Comando",
[179880] = "Marca de Drakkisath",
[179888] = "Projetos Guardados do Rebu",
[179908] = "Ferramentas Perdidas de Escoriárvore",
[179910] = "Cesta de Piquenique do Banha",
[179913] = "Chamado às armas!",
[179914] = "Pilha de Ossos",
[179915] = "Pilha de Crânios",
[179922] = "Recipiente com Sangue Maculado",
[179985] = "Ovo de Aranha",
[180025] = "Monte de Feno Misterioso de Vale do Leste",
[180056] = "Toco de Árvore Misterioso",
[180087] = "Estandarte do Estábulo",
[180088] = "Estandarte da Ferraria",
[180089] = "Estandarte da Fazenda",
[180090] = "Estandarte da Serraria",
[180091] = "Estandarte da Mina",
[180105] = "Círculo do Vínculo",
[180164] = "Ervassol",
[180165] = "Lótus Roxo",
[180166] = "Sálvia-prata-da-montanha",
[180167] = "Sonsona-dourada",
[180168] = "Folha-de-sonho",
[180215] = "Veio de Tório Hakkari",
[180216] = "Chicotalga",
[180228] = "Amontoado de Mandingas Azarentas",
[180229] = "Amontoado de Mandingas Azarentas",
[180252] = "Raio do Herói Troll",
[180346] = "Isca para Gambalama",
[180358] = "Gri'lek, o de Sangue Férreo",
[180364] = "Hazza'rah, o Tece-sonhos",
[180365] = "Renataki das Milâminas",
[180366] = "Caixa de Ferramentas Desgastada",
[180368] = "Tabuleta da Loucura",
[180370] = "Fruta da Colheita",
[180371] = "Peixe da Colheita",
[180372] = "Javali da colheita",
[180373] = "Néctar da Colheita",
[180374] = "Néctar da Colheita",
[180385] = "Som do Portal do Herói Troll",
[180392] = "Jarra Cheia",
[180393] = "Vuxulai, o Bruxo da Tempestade",
[180401] = "Som do Portal do Coração de Hakkar",
[180418] = "Estandarte Nevado",
[180436] = "Fragmento de Tabuleta do Crepúsculo",
[180437] = "Brasa do Homem de Palha",
[180448] = "Pôster de Procura-se: Agarramata",
[180454] = "Cristal Entalhado de Glifos de Colme'Ashi",
[180455] = "Cristal Entalhado de Glifos de Colme'Zora",
[180456] = "Pedra Eólica Menor",
[180461] = "Pedra Eólica",
[180501] = "Fragmento de Tabuleta do Crepúsculo",
[180503] = "Livro de Receitas da Sandy",
[180511] = "Pergaminho de Magia do Flagelo",
[180515] = "Canhão UltraPlosivo 5000",
[180516] = "Altar de Dath'Remar",
[180518] = "Pedra Eólica Menor",
[180523] = "Balde de Maçãs",
[180526] = "Gongo de Bethekk",
[180529] = "Pedra Eólica Menor",
[180534] = "Pedra Eólica",
[180539] = "Pedra Eólica Maior",
[180544] = "Pedra Eólica Menor",
[180549] = "Pedra Eólica Menor",
[180554] = "Pedra Eólica",
[180559] = "Pedra Eólica Maior",
[180564] = "Pedra Eólica Menor",
[180570] = "Barril",
[180619] = "Cristal de Ossirian",
[180642] = "Caixote Inconspícuo",
[180654] = "Monte de Neve Compactado",
[180665] = "Dracônico para Leigos",
[180666] = "Dracônico para Leigos",
[180667] = "Dracônico para Leigos",
[180671] = "Bolsa de Demônios de Shandivious",
[180690] = "Grande Arca do Escaravelho",
    [180691] = "Arca do Escaravelho",
[180699] = "Barril Festivo",
[180715] = "Secadora de Azevinho",
[180743] = "Presente Cuidadosamente Embrulhado",
[180746] = "Presente Chacoalhado Gentilmente",
[180747] = "Presente Alegremente Embrulhado",
[180748] = "Presente Tiquetaqueante",
[180754] = "Cálice de Brindar",
[180763] = "Bombinhas",
[180764] = "Bombinhas",
[180793] = "Presente Festivo",
[180794] = "Diário de Janice Barov",
[180851] = "Foguete de Fogos de Artifício, Tipo 1 Vermelho",
[180855] = "Foguete de Fogos de Artifício, Tipo 1 Verde",
[180857] = "Foguete de Fogos de Artifício, Tipo 1 Branco",
[180858] = "Foguete de Fogos de Artifício, Tipo 1 Amarelo",
[180861] = "Foguete de Fogos de Artifício, Tipo 1 Azul GRANDE",
[180870] = "Bombinhas",
[180871] = "Bombinhas",
[180872] = "Bombinhas",
[180873] = "Bombinhas",
[180905] = "Caneca Festiva",
[181068] = "Pequeno Estilhaço de Obsidiana",
[181069] = "Grande Estilhaço de Obsidiana",
[181085] = "Caixote de Suprimentos de Stratholme",
[181098] = "Cinza Vulcânica",
[181108] = "Depósito de Veraprata",
[181109] = "Veio de Ouro",
[181168] = "Fornalha de Urrálgido",
[181169] = "Fornalha de Urrálgido",
[181332] = "Chama de Ventobravo",
[181333] = "Chama de Altaforja",
[181334] = "Chama de Darnassus",
[181335] = "Chama da Cidade Baixa",
[181336] = "Chama de Orgrimmar",
[181337] = "Chama do Penhasco do Trovão",
[181366] = "Baú dos Quatro Cavaleiros",
[181561] = "Chama do Vale Gris",
[181575] = "Portal de Naxxramas",
[181576] = "Portal de Naxxramas",
[181577] = "Portal de Naxxramas",
[181578] = "Portal de Naxxramas",
[181597] = "Monte de Terra Silitista",
[181598] = "Gêiser Silitista",
[181605] = "Ciranda da Fita",
[182106] = "Estandarte da Torre",
}