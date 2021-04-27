var BigQuery = require('@google-cloud/bigquery');

exports.secondQuery = (req, res) => {

    var startDate = req.query.startDate;
    var endDate = req.query.endDate;
    startDate = startDate.toString();
    endDate = endDate.toString();
  var bigQuery = BigQuery({ projectId: 'PROJECT ID' });
    bigQuery.query({
        query: 'SELECT tpep_pickup_datetime,trip_distance from `PROJECT-ID.taxiDatas.tripData` WHERE tpep_pickup_datetime > '+startDate+' AND tpep_pickup_datetime < '+endDate+' AND trip_distance != 0 ORDER BY trip_distance ASC LIMIT 5',
        useLegacySql: false
    }).then(function (result) {
        return res.status(200).send(result);
    }).catch(function (error) {
        return res.status(500).json(error);
    });
};