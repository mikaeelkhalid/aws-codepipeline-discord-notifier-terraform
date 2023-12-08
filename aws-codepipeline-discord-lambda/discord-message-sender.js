const axios = require('axios');
const DISCORD_WEBHOOK_URL = process.env.DISCORD_WEBHOOK_URL;

module.exports.postMessage = (message) => {
  axios({
    method: 'post',
    headers: {
      'Content-Type': 'application/json',
    },
    url: DISCORD_WEBHOOK_URL,
    data: message,
  });
};

