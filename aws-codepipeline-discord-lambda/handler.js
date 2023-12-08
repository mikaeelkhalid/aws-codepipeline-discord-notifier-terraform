const DiscordMessageSender = require('./discord-message-sender');
const Constants = require('./constants');
const DiscordHelper = require('./discord-helper');

function processEvent(event, _) {
  console.log(JSON.stringify(event, 2, null));
  const eventDetails = event.detail;

  if (eventDetails.action && !Constants.RELEVANT_STAGES.find((_) => eventDetails.action.toUpperCase())) {
    console.log(`Untracked Stage: ${eventDetails.action.toUpperCase()}`);
    return Promise.resolve();
  }

  return DiscordHelper.createDiscordMessage(eventDetails).then(DiscordMessageSender.postMessage);
}

exports.handle = (event, _, callback) => {
  processEvent(event)
    .then((_) => {
      callback(null, 'Discord Message successfully pushed');
    })
    .catch((err) => callback(err));
};

