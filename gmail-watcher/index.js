const { authorize } = require("./auth");
const { google } = require("googleapis");

async function setupGmailWatch() {
  try {
    const auth = await authorize();
    const gmail = google.gmail({ version: "v1", auth });

    const response = await gmail.users.watch({
      userId: 'me',
      resource: {
        labelIds: ['INBOX'],
        topicName: `projects/${process.env.GCP_PROJECT_ID}/topics/${process.env.GCP_GMAIL_PUB_SUB_TOPIC_NAME}`,
      },
    });

    console.log("✅ Gmail Watch Registered:", response.data);
  } catch (error) {
    console.error("❌ Error setting up Gmail watch:", error);
  }
}

setupGmailWatch();
