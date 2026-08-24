-- Commit Ledger entries for Slack approval cards and later audit lookup.
DO $$
BEGIN
    IF to_regclass('public.commit_proposals') IS NOT NULL
       AND to_regclass('public.commit_ledger_entries') IS NULL THEN
        ALTER TABLE commit_proposals RENAME TO commit_ledger_entries;
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS commit_ledger_entries (
    proposal_id        TEXT PRIMARY KEY,
    requester_user_id  TEXT,
    requester_user_name TEXT,
    channel             TEXT NOT NULL,
    thread_ts           TEXT NOT NULL,
    device              TEXT NOT NULL,
    vendor              TEXT NOT NULL,
    safety_reason       TEXT,
    precheck_evidence   TEXT,
    commit_payload      TEXT NOT NULL,
    status              TEXT NOT NULL DEFAULT 'pending', -- pending | approved | cancelled | expired
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at          TIMESTAMPTZ NOT NULL,
    decided_at          TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_commit_ledger_entries_status ON commit_ledger_entries (status);

ALTER TABLE commit_ledger_entries ADD COLUMN IF NOT EXISTS requester_user_id TEXT;
ALTER TABLE commit_ledger_entries ADD COLUMN IF NOT EXISTS requester_user_name TEXT;
