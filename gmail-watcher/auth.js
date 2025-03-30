const fs = require("fs");
const path = require("path");
const { google } = require("googleapis");
const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');
const client = new SecretManagerServiceClient();

// Path to store the access token after authentication
const TOKEN_PATH = path.join(__dirname, "token.json");
// Required Gmail API scopes
const SCOPES = [
  "https://www.googleapis.com/auth/gmail.modify",
  "https://www.googleapis.com/auth/gmail.metadata"
];


/**
 * Retrieves Gmail credentials from Google Cloud Secret Manager.
 *
 * This function accesses the latest version of the secret named `gmail-credentials`
 * in the specified Google Cloud project and parses it as JSON.
 *
 * @async
 * @function
 * @returns {Promise<Object>} A promise that resolves to the parsed credentials object.
 * @throws {Error} If there is an issue accessing the secret or parsing the data.
 */
async function getCredentials() {
  const [version] = await client.accessSecretVersion({
    name: `projects/${process.env.GCP_PROJECT_ID}/secrets/gmail-credentials/versions/latest`,
  });
  console.log("🚀 Loaded credentials from Secret Manager", version.payload.data.toString());
  return JSON.parse(version.payload.data.toString());
}

/**
 * Authorizes the application to access the user's Google account.
 * 
 * This function retrieves OAuth2 credentials, checks for an existing token,
 * and either uses the token or prompts the user to generate a new one.
 * 
 * @async
 * @function
 * @returns {Promise<google.auth.OAuth2>} A promise that resolves to an authenticated OAuth2 client.
 * @throws {Error} If there is an issue retrieving credentials or generating a new token.
 */
async function authorize() {
  const credentials = await getCredentials();
  const { client_secret, client_id, redirect_uris } = credentials.installed;
  const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);

  // Check if we already have a token
  if (fs.existsSync(TOKEN_PATH)) {
    const token = fs.readFileSync(TOKEN_PATH);
    oAuth2Client.setCredentials(JSON.parse(token));
    return oAuth2Client;
  }

  return getNewToken(oAuth2Client);
}

/**
 * Prompts the user to authorize the application and retrieves a new OAuth2 token.
 *
 * @param {google.auth.OAuth2} oAuth2Client - The OAuth2 client to get the token for.
 * @returns {Promise<google.auth.OAuth2>} A promise that resolves with the authenticated OAuth2 client.
 *
 * @throws Will reject the promise if there is an error retrieving the access token.
 *
 * @description
 * This function generates an authorization URL, prompts the user to visit the URL,
 * and enter the authorization code. It then exchanges the code for an access token,
 * sets the credentials on the OAuth2 client, and saves the token to a file for future use.
 */
function getNewToken(oAuth2Client) {
  return new Promise((resolve, reject) => {
    const authUrl = oAuth2Client.generateAuthUrl({
      access_type: "offline",
      scope: SCOPES,
    });

    console.log("\n🚀 Open this URL in your browser and authorize the app:");
    console.log(authUrl);

    // Ask the user to enter the authorization code, this will be changed once the frontend is ready
    const readline = require("readline").createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    readline.question("\nEnter the code from the page: ", (code) => {
      readline.close();
      oAuth2Client.getToken(code, (err, token) => {
        if (err) {
          console.error("❌ Error retrieving access token:", err);
          return reject(err);
        }
        oAuth2Client.setCredentials(token);

        // Save token for future use
        fs.writeFileSync(TOKEN_PATH, JSON.stringify(token));
        console.log("\n✅ Authentication successful! Token saved.");
        resolve(oAuth2Client);
      });
    });
  });
}

module.exports = { authorize };
