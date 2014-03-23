(function () {

    // Dimensionar o elemento #map.
    var docHeight = $(document).height();
    if (docHeight > 500) {
        $("#map").height(docHeight - 375);
    }

    // Configura home button
    $("#home-button").click(function(e) {
        e.preventDefault();
        location.href = "../../";
    });

    // Mapa Leaflet.
    var map = L.map("map").setView([-23.5475000, -46.6361100], 12);
    //L.tileLayer.provider("OpenStreetMap.Mapnik").addTo(map);
    L.tileLayer.provider("MapQuestOpen.OSM").addTo(map);

    // Marker Cluster - agrupador de pontos.
    var markers = new L.MarkerClusterGroup();
    markers.addTo(map);

    // geoJSON da Grande SP.
    var geoSP = L.geoJson();

    // Seletor de camadas.
    var overlays = {
        "Pontos": markers,
        "Grande SP": geoSP
    };

    // Adiciona controle de camadas ao mapa.
    L.control.layers(null, overlays).addTo(map);

    // Retorna número para dias da semana, com:
    //     1-5 == segunda a sexta,
    //     6 == sábado
    //     7 == domingo
    function myDay(date) {
        var day = date.getDay();
        return day ? day : 7;
    }

    // Dado um array de números, retorna a faixa [min, max]
    // compreendida por eles, onde min é inclusivo, max é exclusivo.
    function arrayRange(array) {
        if ((array.length === 0) || (array.length === 1)) {
            return array;
        } else {
            var start = array.reduce(function(a, b) { return Math.min(a, b); });
            var end = array.reduce(function(a, b) { return Math.max(a, b); });
            end++;
            return [start, end];
        }
    }

    // Dado um array de números, retorna um array [min, ..., max]
    // com todos os números compreendidos entre min e max, onde
    // ambos min e max são inclusivos.
    function arrayFill(array) {
        if ((array.length === 0) || (array.length === 1)) {
            return array;
        } else {
            var start = array.reduce(function(a, b) { return Math.min(a, b); });
            var end = array.reduce(function(a, b) { return Math.max(a, b); });
            var series = [];
            for (var i = start; i <= end; i++) {
                series.push(i);
            }
            return series;
        }
    }

    // Carregar dados de acidentes.
    d3.csv("../dados/talao-local-falha.csv", function(data) {

        // Formatação de data
        //var inpFormat = d3.time.format("%d/%m/%Y %H:%M");

        // Limite da duracao no conjunto de dados
        var maxDuracao = 0;

        data.forEach(function(item) {

            // Formatação: causa: NULL == desconhecida
            if (item.causa === "NULL") {
                item.causa = "desconhecida";
            }

            // Formatação de latitude e longitude
            // Coordenadas geográficas devem estar disponíveis
            if (item.lat && item.lat !== "NA") {

                // Substituir vírgula por ponto para delimitar decimais
                var ptlat = item.lat.replace(/,/g, ".");
                var ptlon = item.lon.replace(/,/g, ".");

                item.latlng = [ptlat, ptlon];

            } else {

                item.latlng = [];
            }

            maxDuracao = Math.max(item.duracao, maxDuracao);
        });

        // Crossfilter
        var semaforos = crossfilter(data);
        var all = semaforos.groupAll();

        // Dimensões
        var dimFamilia = semaforos.dimension(function(d) { return d.falha_familia; });
        var dimCausa = semaforos.dimension(function(d) { return d.causa; });
        var dimDuracao = semaforos.dimension(function(d) { return d.duracao; });

        // Grupos
        var grpFamilia = dimFamilia.group();
        var grpCausa = dimCausa.group();
        var grpDuracao = dimDuracao.group();

        // Elimina todos os filtros.
        function filterReset() {
            dc.filterAll(null);
            dc.redrawAll();
            updateMarkers();
        }

        // Instala filterReset() no botão reset.
        $("#reset-button").click(filterReset);

        // Filtros 1000/10000/TODOS
        var totalPontos = 1000;

        $("#flt-menu-1000").click(function(e) {
            e.preventDefault();
            $("#flt-menu-text").text("1000");
            totalPontos = 1000;
            dc.redrawAll();
            updateMarkers();
        });

        $("#flt-menu-10000").click(function(e) {
            e.preventDefault();
            $("#flt-menu-text").text("10000");
            totalPontos = 10000;
            dc.redrawAll();
            updateMarkers();
        });

        $("#flt-menu-todos").click(function(e) {
            e.preventDefault();
            $("#flt-menu-text").text("TODOS");
            totalPontos = Infinity;
            dc.redrawAll();
            updateMarkers();
        });

        // Charts
        var causaChart = dc.barChart("#causa-barchart");
        var familiaChart = dc.barChart("#familia-barchart");
        var duracaoChart = dc.barChart("#duracao-barchart");

        causaChart
            .width($("#causa-barchart").parent().width() + 120)
            .height($("#causa-barchart").height())
            .dimension(dimCausa)
            .group(grpCausa)
            .elasticY(true)
            .centerBar(true)
            .x(d3.scale.ordinal())
            .xUnits(dc.units.ordinal);

        causaChart.margins().left = 40;

        causaChart.filterHandler(function(dimension, filter) {

            var cfFilter;

            switch (filter.length) {
                case 0:
                    cfFilter = null;
                    break;
                case 1:
                    cfFilter = filter[0];
                    break;
                default:
                    cfFilter = filter[filter.length - 1];
            }

            dc.events.trigger(function() {
                dimension.filter(cfFilter);
                dc.redrawAll();
                updateMarkers();
            });

            return cfFilter === null ? cfFilter : [cfFilter];
        });

        familiaChart
            .width($("#familia-barchart").parent().width() + 120)
            .height($("#familia-barchart").height())
            .dimension(dimFamilia)
            .group(grpFamilia)
            .elasticY(true)
            .centerBar(true)
            .x(d3.scale.ordinal())
            .xUnits(dc.units.ordinal);

        familiaChart.margins().left = 40;

        familiaChart.filterHandler(function(dimension, filter) {

            var cfFilter;

            switch (filter.length) {
                case 0:
                    cfFilter = null;
                    break;
                case 1:
                    cfFilter = filter[0];
                    break;
                default:
                    cfFilter = filter[filter.length - 1];
            }

            dc.events.trigger(function() {
                dimension.filter(cfFilter);
                dc.redrawAll();
                updateMarkers();
            });

            return cfFilter === null ? cfFilter : [cfFilter];
        });

        duracaoChart
            .width($("#duracao-barchart").parent().width() + 30)
            .height($("#duracao-barchart").height())
            .dimension(dimDuracao)
            .group(grpDuracao)
            .elasticY(true)
            .centerBar(true)
            .elasticX(true)
            .x(d3.scale.linear()
               .domain([0, maxDuracao + 1])
               .range([0, maxDuracao + 1]));

        duracaoChart.margins().left = 25;

        duracaoChart.filterHandler(function(dimension, filter) {

            if (filter.length === 0) {
                filter = null;
            } else {
                filter = filter[0];
            }

            dc.events.trigger(function() {
                dimension.filter(filter);
                dc.redrawAll();
                updateMarkers();
            });

            return filter;
        });

        // Adiciona markers para cada ponto.
        function updateMarkers() {

            setTimeout(function() {

                // Limpa markers antes de recriá-los
                markers.clearLayers();

                var d = dimDuracao.top(totalPontos);

                d.forEach(function(pt) {

                    // Coordenadas geográficas devem estar disponíveis
                    if (pt.latlng.length !== 0) {

                        var marker = new L.marker(pt.latlng);
                        markers.addLayer(marker);
                    }
                });

            }.bind(this), 750);
        }

        dc.renderAll();

        updateMarkers();
    });

    // geoJSON de São Paulo
    d3.json("../../geoJSON/saopaulo.json", function(err, geo) {
        if (!err) {
            geoSP.addData(geo);
        }
    });
}());
