# CETvis

### Objetivo

Este projeto visa oferecer, sob a forma de uma aplicação web, um conjunto de gráficos, estatísticas e visualizações interativas para os dados de segurança do trânsito coletados pela [CET-SP](http://www.cetsp.com.br). O intuito da aplicação é informar decisões e políticas públicas, permitindo melhorias na qualidade e segurança do trânsito da cidade de São Paulo.


### Desenvolvimento

Com a aplicação web, o usuário terá acesso a um portal que lista os tipos de visualizações gráficas descritivas e/ou resultantes de análises estatísticas. Para cada tipo de visualização, a aplicação permite ao usuário selecionar, dentre as informações fornecidas pela CET, aquelas de seu interesse.

Por exemplo, suponha que o usuário deseje estudar a associação de embriaguez do condutor e ocorrência de fatalidade no acidente. Para isso, basta que ele selecione, na aplicação, a variável com a informação de embriaguez e a variável com o número de vítimas fatais. Feito isso, a aplicação irá atualizar imediatamente a visualização, mostrando um gráfico com as proporções de vítimas fatais por estado de embriaguez. Será possível obter, além da visualização gráfica e das estatísticas descritivas, uma indicação sobre a significância estatística da associação observada.


### Tecnologias Utilizadas

A aplicação web de que consiste o projeto divide-se basicamente em duas partes: visualizações estatísticas e visualizações geográficas.

#### Visualizações Estatísticas

A porção de visualizações estatísticas foi desenvolvida em [R](http://www.r-project.org) utilizando o pacote [Shiny](http://www.rstudio.com/shiny/), dado que cada uma das visualizações é uma *Shiny App* executando sob o [Shiny Server](http://www.rstudio.com/shiny/server/), que é um servidor para aplicações web escritas em R.

Um tutorial para o Shiny pode ser encontrado em [http://rstudio.github.io/shiny/tutorial/](http://rstudio.github.io/shiny/tutorial/).

Para permitir a execução do Shiny Server de maneira mais tranquila, utilizamos um ambiente virtualizado no [Vagrant](http://www.vagrantup.com) com [VirtualBox](https://www.virtualbox.org), construído através de uma instalação do [Ubuntu Server 12.04 LTS](http://www.ubuntu.com/download/server) automatizada através do sistema [Packer](http://www.packer.io).

As visualizações em si foram produzidas com os pacotes [ggplot2](http://ggplot2.org) (para gráficos estáticos) e [rCharts](http://rcharts.io) (gráficos interativos e/ou animados). Os gráficos animados produzidos pelo rCharts são renderizados no browser através das bibliotecas [d3.js](http://d3js.org) e [NVD3](http://nvd3.org).

#### Visualizações Geográficas

Já as visualizações geográficas foram desenvolvidas com uma série de tecnologias de *front-end* web.

Os mapas interativos são gerados com o uso da biblioteca [Leaflet](http://leafletjs.com) utilizando o *tileset* aberto da [MapQuest](http://developer.mapquest.com/web/products/open/map) para o [OpenStreetMap](http://openstreetmap.org). Essas tecnologias foram escolhidas por serem completamente abertas, não nos obrigando a interagir com bases proprietárias de dados geográficos e cartográficos.

Os dados de origem foram consumidos dos originais em CSV através da API [d3.csv](https://github.com/mbostock/d3/wiki/CSV) da biblioteca d3.js.

Porém, foi necessário um preprocessamento dos dados para a obtenção de coordenadas geográficas (latitude e longitude) a partir de logradouros, permitindo assim indicá-los no mapa. Esse processamento foi realizado com um pequeno trecho de código em [LiveScript](http://livescript.net), executado sob a plataforma [node.js](http://nodejs.org) com o módulo [node-geocoder](https://github.com/nchaulet/node-geocoder).

Foi ainda utilizado o [Crossfilter](http://square.github.io/crossfilter/) para realizar a filtragem multidimensional dos dados. Como se não bastasse, usamos ainda a biblioteca [dc.js](http://dc-js.github.io/dc.js/) para oferecer gráficos dimensionais capazes não só de oferecer visualizações dos dados, como também servir de controles para os filtros dimensionais do Crossfilter.

O uso integrado de dc.js com Crossfilter e Leaflet foi fortemente inspirado por [este tutorial](http://jeromegagnonvoyer.wordpress.com/2013/04/17/creating-a-data-visualization-tool-using-d3-js-crossfilter-and-leaflet-js/) encontrado no blog de [Jérôme Gagnon-Voyer](http://jeromegagnonvoyer.wordpress.com), apesar de ele não usar dc.js.

Finalmente, a camada vetorial representando a área da Grande São Paulo foi obtida através do uso da ferramenta [GDAL/OGR](http://www.gdal.org/ogr/) sobre o conjunto de figuras [ne_10m_urban_areas](http://www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-urban-area/) da [Natural Earth](http://www.naturalearthdata.com), uma fonte completamente livre de dados geográficos e cartográficos.

A técnica utilizada para a exibição dessa camada vetorial foi inspirada pelo post [Let's Make a Map](http://bost.ocks.org/mike/map/) de Mike Bostock, autor da biblioteca d3.js.

#### Notas finais

Todas as tecnologias utilizadas são de código aberto. Isso foi o pré-requisito fundamental para todo o desenvolvimento deste projeto, de modo que os resultados por nós obtidos possam ser replicados por quaisquer pessoas ou entidades que neles estejam interessadas.