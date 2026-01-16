# ⚙️ Slack setup for n8n workflows

This document describes how to setup your Slack system for interacting with the [ChatOps Agentic Network Automation Workflow](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/docs/chatops_workflow.md) in this repository.</br>
**Buckle up!**

1. Create a Workspace in your Slack. In this case, we will use ```My Network Ops✨```

</br>
<div align="center">
<img src="../images/slack_workspace.png"/>
</div>
</br>

2. Create Slack App at `api.slack.com/apps` in the Workspace aforementioned. Our app will be called ```Packetl```

</br>
<div align="center">
<img src="../images/slack_app.png"/>
</div>
</br>

3. Navigate to `OAuth & Permissions` and add the following `Bot Token Scopes`:
- `app_mentions:read`
- `channels:history`
- `channels:read`
- `chat:write`
- `groups:history`
- `groups:read`
- `im:history`
- `im:read`
- `im:write`

4. Also in `OAuth & Permissions`, scroll to `OAuth Tokens` and generate a new token. Take note of this token as we will need them later.

</br>
<div align="center">
<img src="../images/slack_oauth_token.png"/>
</div>
</br>

5. Click the button `Reinstall to My Network Ops✨` to activate this token.

6. In your n8n workflow, open the `Slack Trigger` block. Select `Credential to connect with` and add a new credential. In the `Access Token` field, put the OAuth token generated in step no.4. and test the connection.

</br>
<div align="center">
<img src="../images/slack_account.png"/>
</div>
</br>

> ⚠️ If the connection is unsuccessful, try with deleting the parameter `Signature Secret`. It will populate automatically once the connection is established.

7. Back in your `Slack Trigger` block, open the drop-down option of `Webhook URLs`. Depending on the following, you will copy one or the other URL:

- If your n8n workflow is in **test mode**, copy the `Test URL` part
- If your n8n workflow is **active**, copy the `Production URL` part

</br>
<div align="center">
<img src="../images/slack_webhook.png"/>
</div>
</br>

8. Go back to your app in `api.slack.com/apps`. Navigate to `Enable Event Subscriptions` > `Enable Events` > `Request URL` and provide the URL from the previous step

</br>
<div align="center">
<img src="../images/slack_event_subs_url.png"/>
</div>
</br>

> ⚠️ If you are using your n8n in **Test mode**, you need to click `Execute step` in your `Slack Trigger` **before** adding the webhook URL in the Slack Request URL field. Otherwise, the request will fail! You don't need to do this if your n8n workflow is **active**.

</br>
<div align="center">
<img src="../images/slack_test.png"/>
</div>
</br>

9. In the same page, scroll to `Subscribe to bot events`. Add the event `app_mention`. Afterwards, click on `Save Changes`

</br>
<div align="center">
<img src="../images/slack_subscribe_events.png"/>
</div>
</br>

10. Finally, navigate to `Interactivity and Shorcuts`, and in the `Interactivity > Request URL` section, provide the URL of your webhooks. This will enable your app to interact via Cards and buttons with the workflow.

</br>
<div align="center">
<img src="../images/slack_interactivity.png"/>
</div>
</br>

11. Navigate to `Settings` > `Install App` and click again `Reinstall to My Network Ops✨`

**Ready to test!** Create a new channel in your workspace, add the `Packetl` app and tag it to ask any question about your network:

</br>
<div align="center">
<img src="../images/slack_read.png"/>
</div>
</br>