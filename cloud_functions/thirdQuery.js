var BigQuery = require('@google-cloud/bigquery');

exports.thirdQuery = (req, res) => {

    var startDate = req.query.startDate;
    var endDate = req.query.endDate;
    startDate = startDate.toString();
    endDate = endDate.toString();
  var bigQuery = BigQuery({ projectId: 'PROJECT ID' });
    bigQuery.query({
        query: 'SELECT PULocationID,DOLocationID,tpep_pickup_datetime,trip_distance from `PROJECT-ID.taxiDatas.tripData` WHERE tpep_pickup_datetime > '+startDate+' AND tpep_pickup_datetime < '+endDate+' ORDER BY trip_distance DESC LIMIT 1',
        useLegacySql: false
    }).then(function (result) {
        var text = JSON.stringify(result);
        var ress = text.slice(2, text.length-2);
        var json = JSON.parse(ress);
        var puID = json.PULocationID.toString();
        var doID = json.DOLocationID.toString();
        bigQuery.query({
            query : 'SELECT latitude,longitude FROM `PROJECT-ID.taxiDatas.taxiZones` WHERE LocationID='+puID+' or LocationID='+doID+' ORDER BY LocationID',
            useLegacySql: false
        }).then(function(result){
            return res.status(200).send(result);
        }).catch(function(error){
            return res.status(500).json(error);
        })
    }).catch(function (error) {
        return res.status(500).json(error);
    });
};