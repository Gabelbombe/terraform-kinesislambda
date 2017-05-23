// applications/kinesis_streamer/lib/handler.js
import AWS from 'aws-sdk';
const kinesis = new AWS.Kinesis();

export function receiveEvent(event, context, callback) {
  console.log('[note] -> demoHandler');
  console.log(`[info] Event:   ${JSON.stringify(event,   null, 2)}`);
  console.log(`[info] Context: ${JSON.stringify(context, null, 2)}`);

  const base64Data    = event.Records[0].kinesis.data;
  const base64Decoded = new Buffer(base64Data, 'base64').toString()

  console.log(base64Decoded);
  return callback();
}

export function publishEvent(event, context, callback) {
  console.log('[note] <- demoHandler');
  console.log(`[info] Event:   ${JSON.stringify(event, null, 2)}`);
  console.log(`[info] Context: ${JSON.stringify(context, null, 2)}`);

  const params = {
    Data: '{ sample: "json-object" }',
    PartitionKey: 'resource-1',
    StreamName: 'terraform-kinesis-streamer-demo-stream'
  };

  console.log('[info] putting record');
  kinesis.putRecord(params, (err, data) => {
    if (err) {
      console.error('[warn] error putting record');
      console.error(err);

      return callback(err);
    }
    console.log('[info] kinesis put success');
    console.log(JSON.stringify(data, null, 2));

    return callback();
  });
}
