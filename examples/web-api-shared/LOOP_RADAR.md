# Loop Radar — web + api + shared-types

Last updated: 2026-06-08
Updated by: Beacon

## Current build objective

Ship a working signup flow: the web form posts to the API, the API validates and
stores the user, and both sides share the `User` type from `packages/shared`.

## P0 build factors

### 1. Contract stability
Status: 🔴 gate everything else
`packages/shared/User` is the type both agents depend on. Lock its shape before
web and api build against it. Any change is a proposal.
Likely owner: operator / contracts. Approval: required.

### 2. Mocks-first independence
Status: 🟡
web and api should not block each other. web builds against a mock API response
shaped like `User`; api builds against the same fixture.
Likely owners: web, api. Approval: yes for behavior.

### 3. Demo coherence
Status: 🟡
The signup flow must work end to end for the demo: form → API → stored → success.
Likely owners: web, api. Approval: yes.

## Rules for Beacon

Create task briefs from this radar. Never approve. Never code. Keep ≤3 P0 briefs.
