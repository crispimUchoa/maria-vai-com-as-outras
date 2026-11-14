# 🐺 Maria Vai Com as Outras

> *"Todo mundo no interior tem um avô que já lutou com um lobisomem..."*

**Maria Vai Com as Outras** é um jogo de RPG 2D estilo *top-down* em pixel art ambientado no sertão cearense. O projeto mistura o cotidiano rural e os interiores rústicos típicos da região com o terror folclórico e o mistério das histórias de lobisomens contadas de geração em geração.

---

## 📖 Sobre o Jogo

Assuma o papel de uma jovem protagonista que decide investigar os estranhos acontecimentos e lendas locais envolvendo criaturas da noite no sertão. O jogo combina exploração, resolução de mistérios e uma atmosfera tensa inspirada tanto na cultura oral nordestina quanto em clássicos do terror *indie*.

### ✨ Inspirações
* **Folclore e Memória Oral Cearense:** Baseado no famoso ditado popular *"Meu avô já matou um lobisomem"* — incluindo histórias reais das famílias dos desenvolvedores, como o relato de que o avô de Crispim lutou contra um lobisomem ao voltar da casa da namorada, e o relato do avô de Rita, que afirma já ter "cutilado" um.
* **Referências de Jogos:** *The Witch's House* e *Fran Bow* (pela construção de atmosfera sombria, narrativa focada em mistério, exploração e elementos psicológicos/sobrenaturais).

---

## 🎮 Características Principais

* **Visual Retrô:** Gráficos em pixel art *top-down* retratando a estética, arquitetura e paisagens do sertão do Ceará.
* **Narrativa e Investigação:** Sistema de diálogos e interação com moradores locais para desvendar pistas sobre a criatura.
* **Ambientação Imersiva:** Transição entre áreas abertas da caatinga/sertão e interiores rústicos típicos da região.

---

## 🛠️ Tecnologias e Arquitetura

* **Engine:** [Godot Engine](https://godotengine.org/)
* **Arte e Sprites:** Pixel art autoral (sprites 64x64)
* **Destaques Técnicos:**
  * Arquitetura modular de cenas com gerenciamento de transições entre mapas externos e interiores.
  * Sistema de ordenação de profundidade dinâmica (`Y-Sort`).
  * Estrutura de pontos de surgimento (*spawns*) gerenciada via `Marker2D`.
  * Sistema de dados de personagens e diálogos estruturado com arquivos de recurso (`Resource`) e scripts de editor (`@tool`).

---

## 🎥 Vídeo de Apresentação

* 🔗 **[Assistir à Apresentação do Projeto no YouTube](https://www.youtube.com/watch?v=5IoGCP1y5Oc)**

---

## 🎓 Contexto Acadêmico

Projeto desenvolvido como requisito para a disciplina de **Extensão II** do curso de **Ciência da Computação** da **Universidade Estadual do Ceará (UECE)** — Semestre **2026.2**.

* **Professor Orientador:** Ismayle de Sousa Santos

---

## 👥 Desenvolvedores

* **Francisco Crispim Pinto Uchôa Neto** — [@crispimUchoa](https://github.com/crispimUchoa)
* **Rita Jennyfer Batista Frota**

---

## 🚀 Como Executar o Projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/crispimUchoa/maria-vai-com-as-outras.git](https://github.com/crispimUchoa/maria-vai-com-as-outras.git)

## 🎨 Créditos de Arte (Sprites)

Os sprites dos personagens foram criados utilizando o **[Universal LPC Spritesheet Character Generator](https://liberatedpixelcup.github.io/Universal-LPC-Spritesheet-Character-Generator/)** (projeto *Liberated Pixel Cup* / [OpenGameArt.org](https://opengameart.org/content/lpc-collection)).

* **Autores:** 7Soul, Ahmad3366, AntumDeluge, Barbara Riviera, Benjamin K. Smith (BenCreating), bluecarrot16, Carlo Enrico Victoria (Nemisys), Charles Sanchez (CharlesGabriel), Cobra Hubbard (BlueVortexGames), dalonedrau, Daniel Eddeland (daneeklu), DarkwallLKE, David Conway Jr. (JaidynReiman), DCSS artists (Crawl Tiles), Dr. Jamgo (drjamgo), Durrani, Eliza Wyatt (ElizaWy), Emilio J. Sanchez-Sierra, Evert, Fabzy, gr3yh47, Inboxninja, Joe White, Johannes Sjölund (wulax), Joshua Taylor, kcilds/Rocetti/Eredah, kheftel, kirts, laetissima, Lanea Zimmerman (Sharm), LordNeo, Luke Mehl, macmanmatty, Mandi Paugh, Manuel Riecke (MrBeast), Marcel van de Steeg (MadMarcel), Matthew Krohn (makrohn), Michael Whitlock (bigbeargames), MuffinElZangano, Napsio (Vitruvian Studio), Nila122, Nyom, Page, Pierre Vigier (pvigier), PlatForge project, Radomir Dopieralski, Sander Frenken (castelonia), Shaun Williams, Skorpio, Stafford McIntyre, Stephen Challener (Redshrike), Thane Brimhall (pennomi), The Foreman, thecilekli, TheraHedwig, Tracy, tskaufma, Tuomo Untinen (reemax), William.Thompsonj, Yamilian, Zi Ye.
* **Licenças:** [CC-BY-SA 3.0 / 4.0](https://creativecommons.org/licenses/by-sa/4.0/), [OGA-BY 3.0](https://static.opengameart.org/OGA-BY-3.0.txt), [CC-BY 3.0 / 4.0](https://creativecommons.org/licenses/by/4.0/), [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html) e [CC0](https://creativecommons.org/public-domain/cc0/).
* **Créditos detalhados por asset e links originais:** Consulte o arquivo [`CREDITS.csv`](./CREDITS.csv) incluído neste repositório.
