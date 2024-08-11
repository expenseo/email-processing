import { Context, Handler, Callback } from 'aws-lambda';

export const handler: Handler = async (event, context: Context, callback: Callback) => {
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
