import { Context, Handler, Callback } from 'aws-lambda';

export const handler: Handler = async (event, context: Context, callback: Callback) => {
  console.log('Received event:', JSON.stringify(event, null, 2));

  const response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: 'Hey madafaka!',
      event,
      context,
    }),
  };
  callback(null, response);
};
