# CRM email integration

## Goal

Give each CRM user a familiar mailbox inside TapCRM and let them attach email conversations to the CRM records they work with. Users can connect Gmail, Microsoft 365/Outlook, Yahoo, and other providers that support standard mail protocols.

## First delivery

- Connect and disconnect mailboxes. Use provider OAuth where available (Google and Microsoft); use IMAP/SMTP with an app password or OAuth for other providers. Never ask for or store an account's normal sign-in password.
- Show a unified inbox with folders, message search, read/unread state, sent mail, and drafts.
- Compose, reply, reply-all, forward, and send messages with attachments.
- Archive, delete, flag/star, and mark messages read or unread.
- Link or unlink a message thread to a CRM contact, client, lead, or deal; show linked messages on that record.
- Keep mailbox data private to its owner by default. Any future shared mailbox needs explicit organization-level permissions and audit events.

## Suggested design

1. Add a `mail` module with provider adapters behind one interface. Keep Google Gmail API, Microsoft Graph, and generic IMAP/SMTP details out of route handlers.
2. Store mailbox metadata and message/thread indexes in tenant-scoped tables. Encrypt refresh/access tokens and IMAP/SMTP credentials with an application-managed key; never return credentials from the API or log message bodies and tokens.
3. Add authenticated routes for mailbox setup, folders, messages, search, send, message actions, and CRM links. Validate provider callback state and bind every operation to the signed-in user and organization.
4. Sync incrementally in background jobs, with provider cursors, retry/backoff, and idempotent upserts. Sending should use an outbox so retries do not duplicate messages.
5. Add an Email workspace in the client and a related-email panel on supported CRM records. Use the same mail APIs for all providers.

## Provider setup required for deployment

Google and Microsoft OAuth applications must be registered with redirect URLs for each deployment. Other mail providers need their documented IMAP/SMTP endpoints and an app password or OAuth configuration. Keep client secrets and the token-encryption key in the deployment secret manager; only variable names and setup instructions belong in `.env.example`.

## Rollout

Land the data/security boundary and provider connection flow first, then inbox actions and CRM linking, then background sync and attachments. Keep each part behind the mail feature permission until provider credentials and deployment callbacks are configured.
