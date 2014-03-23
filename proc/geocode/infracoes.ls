require! {
    async
    csv
    fs
    _: lodash
}

geo = require \node-geocoder .getGeocoder \google \http

addrs = {}
geoCodes = {}
obtainGeocode = (addr, callback) ->
    if addr of geoCodes
        console.log "geocode already exists; addr = #addr"
        callback null, geoCodes[addr]
    else
        geo.geocode addr, (err, res) ->
            if err
                console.dir err
                geoCodes[addr] = ""
            else
                console.log "new geocode; addr = #addr, res ="
                #console.dir res
                geoCodes[addr] = res
                callback err, res

toFile = "infracoes.csv"
toStream = fs.createWriteStream toFile,
    encoding: "utf8"

writeCsvLine = (obj) ->
    toStream.write _.values(obj).join ","
    toStream.write "\n"

writeCsvHead = (obj) ->
    toStream.write _.keys(obj).join ","
    toStream.write "\n"

wroteHead = false

csv!from.path "../dados/InfracaoTransito/Infracoes de Transito.csv",
    columns: true
    delimiter: ";"

.to.array (data) ->
    #console.dir data
    async.eachSeries data,
        (item, cbk) ->
            if item.Descricao_local
                addr = item.Descricao_local
                addr = addr.replace /(A?\(|-)SENTIDO.*$/, ""
                addr = addr.replace /OPOSTO( *AO)?/g, ""
                addr = addr + " Sao Paulo Brazil"
                obtainGeocode addr, (err, res) ->
                    if not err
                        if res.0
                            item.lat = res.0.latitude
                            item.lon = res.0.longitude
                            unless wroteHead
                                writeCsvHead(item)
                                wroteHead := true
                            writeCsvLine(item)
                    cbk null
            else
                cbk null
        (err) ->
            if err
                console.dir err
