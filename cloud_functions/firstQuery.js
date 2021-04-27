var BigQuery = require('@google-cloud/bigquery');

exports.firstQuery = (req, res) => {
  var bigQuery = BigQuery({ projectId: 'PROJECT ID' });
    bigQuery.query({
        query: 'SELECT EXTRACT(DATE FROM TIMESTAMP_SECONDS(tpep_pickup_datetime)) AS dt, sum(passenger_count) as pc FROM `PROJECT-ID.taxiDatas.tripData` group by dt order by dt limit 5',
        useLegacySql: false
    }).then(function (result) {
        return res.status(200).send(result);
    }).catch(function (error) {
        return res.status(500).json(error);
    });
};