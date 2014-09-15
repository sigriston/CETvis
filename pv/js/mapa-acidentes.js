(function () {

    // Dimensionar o elemento #map.
    var docHeight = $(document).height();
    if (docHeight > 500) {
        $("#map").height(docHeight - 230);
    }

    // Configura home button
    $("#home-button").click(function(e) {
        e.preventDefault();
        location.href = "../../";
    });

    // Mapa Leaflet.
    var map = L.map("map").setView([-23.5475000, -46.6361100], 13);
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
    d3.csv("csv/acidentesPaulista.csv", function(data) {

        // Formatação de data
        var inpFormat = d3.time.format("%d/%m/%Y %H:%M");

        data.forEach(function(item) {

            var datetime = inpFormat.parse(item.data);
            item.weekday = myDay(datetime);
            item.hour = datetime.getHours();
        });

        // Crossfilter
        var acidentes = crossfilter(data);
        var all = acidentes.groupAll();

        // Dimensões
        var dimWeekday = acidentes.dimension(function(d) { return d.weekday; });
        var dimHour = acidentes.dimension(function(d) { return d.hour; });

        var dimFatais = acidentes.dimension(function(d) { return d.vit_morta; });

        // Grupos
        var grpWeekday = dimWeekday.group();
        var grpHour = dimHour.group();

        // Elimina todos os filtros.
        function filterReset() {
            dc.filterAll(null);
            dc.redrawAll();
            updateMarkers();
        }

        // Instala filterReset() no botão reset.
        $("#reset-button").click(filterReset);

        // Filtros feridas/fatais/ambas
        $("#flt-menu-feridas").click(function(e) {
            e.preventDefault();
            $("#flt-menu-text").text("Feridas");
            dimFatais.filter(0);  // Feridas == 0 fatais
            dc.redrawAll();
            updateMarkers();
        });

        $("#flt-menu-fatais").click(function(e) {
            e.preventDefault();
            $("#flt-menu-text").text("Fatais");
            dimFatais.filter([1, Infinity]);  // Fatais == 1 ou mais fatais
            dc.redrawAll();
            updateMarkers();
        });

        $("#flt-menu-ambas").click(function(e) {
            e.preventDefault();
            $("#flt-menu-text").text("Feridas e Fatais");
            dimFatais.filter(null);  // Feridas e Fatais == todas
            dc.redrawAll();
            updateMarkers();
        });

        // Charts
        var weekdayChart = dc.barChart("#weekday-barchart");
        var hourChart = dc.barChart("#hour-barchart");

        weekdayChart
            .width($("#weekday-barchart").parent().width() + 120)
            .height($("#weekday-barchart").height())
            .dimension(dimWeekday)
            .group(grpWeekday)
            .elasticY(true)
            .centerBar(true)
            .x(d3.scale.ordinal().domain(d3.range(1, 8)).range(d3.range(1, 8)))
            .xUnits(dc.units.ordinal)
            .xAxis().tickValues(["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"]);

        weekdayChart.margins().left = 35;

        hourChart
            .width($("#hour-barchart").parent().width() + 50)
            .height($("#hour-barchart").height())
            .dimension(dimHour)
            .group(grpHour)
            .elasticY(true)
            .centerBar(true)
            .x(d3.scale.linear().domain([-1, 24]))
            .xAxis().tickValues(d3.range(24));

        // Chart filter.
        hourChart.filterHandler(function(dimension, filter) {

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

        weekdayChart.filterHandler(function(dimension, filter) {

            var cfFilter;

            switch (filter.length) {
                case 0:
                    cfFilter = null;
                    break;
                case 1:
                    cfFilter = filter[0];
                    break;
                default:
                    cfFilter = arrayRange(filter);
            }

            dc.events.trigger(function() {
                dimension.filter(cfFilter);
                dc.redrawAll();
                updateMarkers();
            });

            return arrayFill(filter);
        });

        // Adiciona markers para cada ponto.
        function updateMarkers() {

            setTimeout(function() {

                // Limpa markers antes de recriá-los
                markers.clearLayers();

                var d = dimWeekday.top(Infinity);

                d.forEach(function(pt) {

                    var latlng = [pt.lat, pt.lon];
                    var title = "(" + pt.lat + "," + pt.lon + ")";
                    //var title = "(" + pt.weekday + "," + pt.hour + ")";
                    var options = {
                        title: title
                    };
                    var marker = new L.marker(latlng, options);
                    markers.addLayer(marker);
                });

            }.bind(this), 750);
        }

        dc.renderAll();

        updateMarkers();
    });

    // geoJSON de São Paulo
    d3.json("../geoJSON/saopaulo.json", function(err, geo) {
        if (!err) {
            geoSP.addData(geo);
        }
    });
}());
